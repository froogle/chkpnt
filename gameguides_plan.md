# Game Guides Feature Implementation Plan

## Overview

Add the ability to save, view, and manage game guides from GameFAQs within the ChkPnt app. Users can browse GameFAQs in an embedded browser, save guides as JSON files, and read them with customisable display settings.

## Key Requirements Summary

- **Browser**: `webview_flutter` package, starts at gamefaqs.gamespot.com
- **Navigation**: Back, Close, conditional "Save This Guide" button
- **Storage**: Guide JSON files linked to games (one-to-many)
- **Reader**: White text on black (invertible), global font size, simple scroll
- **Position**: Section + block index tracking (close enough)
- **Backup**: Extend ZIP archive with `guides/` directory

---

## Phase 1: Foundation - Library Integration & Database Schema

**Goal**: Set up the guides library and database table for storing guide metadata.

### Tasks

1. **Copy guides library into project**
   - Copy `/home/froogle/develops/chkpnt_research/guides/lib/` contents to `lib/services/guide_parser/`
   - Update imports to work within chkpnt package structure
   - Add required dependencies to `pubspec.yaml`: `html: ^0.15.4`

2. **Create Guide model** (`lib/models/guide_models.dart`)
   - `GuideId` value class (UUID-based, like `GameId`)
   - `GuideItem` Freezed model with fields:
     - `id: GuideId`
     - `gameId: GameId` (foreign key)
     - `title: String`
     - `author: String`
     - `fileName: String` (unique JSON filename)
     - `lastReadSection: int` (default 0)
     - `lastReadBlock: int` (default 0)
     - `createdAt: DateTime`

3. **Add Guides table to Drift database** (`lib/repositories/drift_game_repository.dart`)
   - Create `Guides` table class with foreign key to `Games`
   - Increment `schemaVersion` to 3
   - Add migration in `onUpgrade` to create table
   - Add conversion methods (`_guideToGuideItem`, `_guideItemToCompanion`)
   - Add CRUD operations for guides

4. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Testable Outcome
- App launches without errors
- Database migrates to v3 successfully
- No UI changes yet (internal only)

---

## Phase 2: Guide Repository & Provider Layer

**Goal**: Create repository interface and Riverpod providers for guide data access.

### Tasks

1. **Create GuideRepository interface** (`lib/repositories/guide_repository.dart`)
   - `Stream<List<GuideItem>> watchGuidesForGame(GameId gameId)`
   - `Future<List<GuideItem>> getGuidesForGame(GameId gameId)`
   - `Future<GuideItem> createGuide(GuideItem guide)`
   - `Future<GuideItem> updateGuideReadPosition(GuideId id, int section, int block)`
   - `Future<void> deleteGuide(GuideId id)`

2. **Implement DriftGuideRepository** (in `drift_game_repository.dart` or separate file)
   - Implement all interface methods
   - Handle guide JSON file deletion when guide record deleted

3. **Create guide providers** (`lib/providers/guide_provider.dart`)
   - `guideRepositoryProvider`
   - `guidesForGameStreamProvider(GameId)` - Family provider
   - `guideListForGameProvider(GameId)` - consumes stream

4. **Create GuideStorageService** (`lib/services/guide_storage_service.dart`)
   - `Future<String> saveGuideJson(String jsonContent)` - saves to `guides/` directory, returns filename
   - `Future<String> loadGuideJson(String fileName)` - reads guide content
   - `Future<void> deleteGuideFile(String fileName)`
   - `Future<List<File>> getAllGuideFiles()` - for backup

5. **Ensure backward-compatible backup restore**
   - Update `importFromJson()` to handle backups without `guides` key
   - If `guides` key missing in backup JSON, treat as empty array (no guides)
   - Update restore process to handle missing `guides/` directory in archive
   - Test: restore a v2 backup (pre-guides) on v3 schema - must work seamlessly

### Testable Outcome
- Can programmatically create/read/delete guide records
- Guide files stored in app storage
- Restoring a pre-guides backup still works correctly
- No UI changes yet

---

## Phase 3: Guide Browser Screen

**Goal**: Embedded browser for navigating GameFAQs and detecting guide pages.

### Tasks

1. **Add webview_flutter dependency** (`pubspec.yaml`)
   ```yaml
   webview_flutter: ^4.10.0
   ```

2. **Create GuideBrowserScreen** (`lib/screens/guide_browser/guide_browser_screen.dart`)
   - Receives `GameId` parameter (to link saved guide)
   - Full-screen with custom app bar
   - Back button (browser history)
   - Close button (return to game detail)
   - Conditional "Save This Guide" button

3. **Implement URL detection**
   - Regex: `gamefaqs\.gamespot\.com/[^/]+/\d+-[^/]+/faqs/\d+$`
   - Show/hide save button based on URL match

4. **Create GuideBrowserPageRoute** (`lib/screens/guide_browser/widgets/guide_browser_page_route.dart`)
   - Custom page route with slide-up animation (like EditScreenPageRoute)

5. **Wire up navigation from GameDetailSheet**
   - Update `_buildGuides()` in `game_detail_sheet.dart`
   - Show "No guides saved" + "Find a Guide" button
   - "Find a Guide" closes sheet and navigates to browser

### Testable Outcome
- Tap "Find a Guide" from game detail sheet
- Browser opens at gamefaqs.gamespot.com
- Can navigate around GameFAQs
- "Save This Guide" button appears on guide URLs
- Back/Close buttons work
- Save button does nothing yet (next phase)

---

## Phase 4: Guide Saving

**Goal**: Extract HTML from browser, parse with library, save guide.

### Tasks

1. **Implement HTML extraction**
   - Use `runJavaScriptReturningResult('document.documentElement.outerHTML')`
   - Handle string escaping from JavaScript result

2. **Implement save flow in GuideBrowserScreen**
   - Extract HTML on save button tap
   - Parse with `GuideContentFetcher().parseFromHtml(html)`
   - Generate unique filename (UUID + timestamp)
   - Save JSON via `GuideStorageService`
   - Create `GuideItem` record in database
   - Show success snackbar with guide title
   - Navigate back to game detail sheet

3. **Handle parse errors**
   - Catch exceptions from parser
   - Show brief error message: "Unable to save this guide. Try finding another."
   - Stay on browser so user can try different guide

### Testable Outcome
- Navigate to a guide on GameFAQs
- Tap "Save This Guide"
- Guide saves successfully (or shows error)
- Return to game detail sheet
- Guide appears in guides section

---

## Phase 5: Guides Section in Game Detail Sheet

**Goal**: Display saved guides and allow opening them.

### Tasks

1. **Update GameDetailSheet `_buildGuides()` method**
   - Watch `guidesForGameStreamProvider(game.id)`
   - If no guides: "No guides saved" + "Find a Guide" button
   - If guides exist: List guide titles + "Find a Guide" button

2. **Create GuideListTile widget** (`lib/screens/main/widgets/guide_list_tile.dart`)
   - Displays guide title
   - Tap navigates to guide reader (Phase 6)
   - Consistent styling with app theme

3. **Style the guides section**
   - Section header "Guides"
   - Subtle dividers between guides
   - "Find a Guide" button at bottom of list

### Testable Outcome
- Game detail sheet shows saved guides by title
- "Find a Guide" button always available
- Tapping guide title does nothing yet (next phase)

---

## Phase 6: Guide Reader Screen

**Goal**: Full-screen reader with text reflow and styling.

### Tasks

1. **Create GuideReaderScreen** (`lib/screens/guide_reader/guide_reader_screen.dart`)
   - Receives `GuideItem` parameter
   - Loads JSON content via `GuideStorageService`
   - Parses JSON into sections/blocks structure

2. **Implement content rendering**
   - `ListView.builder` for sections
   - Section headers (bold, larger font)
   - Regular blocks: reflowed text, Helvetica-like font
   - Preformatted blocks: Courier font, horizontal scroll, no reflow

3. **Create GuideReaderPageRoute**
   - Custom slide-up animation (consistent with other full-screen views)

4. **Wire up navigation**
   - Tapping guide in detail sheet opens reader
   - Back button returns to game detail sheet

### Testable Outcome
- Tap saved guide in detail sheet
- Reader opens with full guide content
- Text reflows to screen width
- Preformatted content displays correctly
- Can scroll through entire guide
- Back button works

---

## Phase 7: Reader Toolbar & Preferences

**Goal**: Font size, colour inversion, and deletion.

### Tasks

1. **Create global reader preferences**
   - Add to existing preferences/settings system or create `GuideReaderPreferences`
   - `fontSize: double` (default 16.0)
   - `invertedColours: bool` (default false - white on black)
   - Persist using SharedPreferences

2. **Create GuideReaderToolbar widget**
   - Tap anywhere on reader to show/hide toolbar
   - Font size controls (A- / A+)
   - Colour invert toggle
   - Delete button

3. **Implement colour schemes**
   - Default: white text (#FFFFFF) on black background (#000000)
   - Inverted: black text (#000000) on white background (#FFFFFF)
   - Preformatted blocks: slightly different background shade

4. **Implement font size adjustment**
   - Min: 12.0, Max: 28.0, Step: 2.0
   - Apply to regular text only (preformatted stays fixed or scales proportionally)

5. **Implement guide deletion**
   - Confirmation dialog: "Delete this guide?"
   - Delete JSON file
   - Delete database record
   - Navigate back to game detail sheet
   - Show success snackbar

### Testable Outcome
- Tap reader to show toolbar
- Adjust font size (persists across sessions)
- Toggle colour inversion (persists)
- Delete guide with confirmation
- Preferences apply to all guides

---

## Phase 8: Reading Position Tracking

**Goal**: Remember where user left off in each guide.

### Tasks

1. **Track scroll position**
   - Use `ScrollController` to monitor position
   - On scroll stop, calculate current section/block index
   - Debounce updates (don't save on every scroll event)

2. **Save position on exit**
   - When navigating away from reader, save current section/block
   - Call `updateGuideReadPosition(guideId, section, block)`

3. **Restore position on open**
   - When opening guide, read `lastReadSection` and `lastReadBlock`
   - Calculate approximate scroll offset
   - Use `scrollController.jumpTo()` after build

4. **Handle edge cases**
   - Guide content changed (section/block no longer exists): scroll to nearest valid position
   - First time opening: start at top

### Testable Outcome
- Open guide, scroll partway through
- Close reader, reopen same guide
- Reader scrolls to approximate previous position
- Position saved per-guide (different games/guides have independent positions)

---

## Phase 9: Backup & Restore Integration

**Goal**: Include guides in backup/restore operations.

### Tasks

1. **Update BackupArchiveService**
   - Add `guidesDirectoryName = 'guides'`
   - Add `_addGuidesToArchive()` method
   - Collect all guide JSON files from storage

2. **Update BackupMetadata model**
   - Add `guideCount: int` field
   - Add `includedGuides: List<String>` (filenames)

3. **Update FullBackupService**
   - `collectAllGuides()` method (similar to `collectAllImages`)
   - Include guides in `BackupData`
   - Update `createBackupMetadata()` to count guides

4. **Update restore process**
   - Extract `guides/` directory from archive
   - Copy guide files to app storage
   - Guide database records restored via `database.json`

5. **Update BackupValidationService**
   - Validate guide files exist in archive
   - Check guide count matches metadata

6. **Update database export/import**
   - Include guides table in `exportDatabaseToJson()`
   - Import guides records in `importFromJson()`

### Testable Outcome
- Create backup with games that have guides
- Backup file contains `guides/` directory with JSON files
- Restore backup on fresh install
- Games appear with their saved guides
- Guide content readable after restore

---

## Phase 10: Polish & Edge Cases

**Goal**: Handle errors gracefully and polish the experience.

### Tasks

1. **Loading states**
   - Show loading indicator while parsing guide
   - Show loading while saving guide

2. **Error handling**
   - Guide file missing: show error, offer to delete record
   - Guide parse error on read: show error message
   - Network issues in browser: let webview handle naturally

3. **Empty states**
   - No internet in browser: webview shows error page
   - Corrupted guide file: graceful error with delete option

4. **UI polish**
   - Consistent animations
   - Proper keyboard handling in browser
   - Test on various screen sizes

5. **Clean up**
   - Remove any debug prints
   - Ensure all resources disposed properly
   - Memory management for large guides

### Testable Outcome
- App handles all error cases gracefully
- No crashes or unhandled exceptions
- Smooth user experience throughout

---

## File Structure Summary

```
lib/
├── models/
│   └── guide_models.dart              # GuideId, GuideItem
├── repositories/
│   ├── guide_repository.dart          # Interface
│   └── drift_game_repository.dart     # + Guides table, guide methods
├── providers/
│   └── guide_provider.dart            # Riverpod providers
├── services/
│   ├── guide_storage_service.dart     # JSON file operations
│   └── guide_parser/                  # Copied from chkpnt_research
│       └── guide_content.dart         # Parser library
├── screens/
│   ├── guide_browser/
│   │   ├── guide_browser_screen.dart
│   │   └── widgets/
│   │       └── guide_browser_page_route.dart
│   ├── guide_reader/
│   │   ├── guide_reader_screen.dart
│   │   └── widgets/
│   │       ├── guide_reader_page_route.dart
│   │       ├── guide_reader_toolbar.dart
│   │       ├── guide_section_widget.dart
│   │       └── guide_block_widget.dart
│   └── main/widgets/
│       ├── game_detail_sheet.dart     # Updated
│       └── guide_list_tile.dart       # New
└── styles/
    └── guide_reader_styles.dart       # Reader styling constants
```

---

## Dependencies to Add

```yaml
dependencies:
  webview_flutter: ^4.10.0
  html: ^0.15.4  # Required by guide parser
```

---

## Database Migration

**From v2 to v3:**
- Add `Guides` table
- Foreign key constraint to `Games.id`
- Cascade delete when game deleted

---

## Critical Files to Modify

1. `pubspec.yaml` - add dependencies
2. `lib/repositories/drift_game_repository.dart` - add Guides table, increment version
3. `lib/screens/main/widgets/game_detail_sheet.dart` - add guides section
4. `lib/services/backup_archive_service.dart` - add guides to archive
5. `lib/services/full_backup_service.dart` - collect/restore guides
6. `lib/models/backup_models.dart` - add guide count to metadata
