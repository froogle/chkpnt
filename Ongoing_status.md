# Implementation Plan: Adding "Ongoing" Status

## Overview

Add a new `ongoing` status for games that are frequently played but don't have a traditional "completion" state (e.g., multiplayer games, roguelikes, live service games). This status represents games the user returns to regularly.

---

## Critical Decisions

### 1. Enum Placement (Database Compatibility)

**Current enum order:**
```dart
enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered }
//                  0         1         2         3          4         5
```

**Proposed new order (ADD TO END):**
```dart
enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered, ongoing }
//                  0         1         2         3          4         5        6
```

**Rationale:** Adding `ongoing` at index 6 ensures all existing database records and backups remain valid. Old backups with status indices 0-5 will import correctly. This is the only safe approach for backwards compatibility.

### 2. Backup Compatibility Strategy

- **Old backups (v1.0.0):** Will only have status indices 0-5, which remain valid
- **New backups (v1.1.0):** Can include status index 6 (ongoing)
- **Import logic:** No migration needed since we're appending, not inserting
- **Bump backup version** to v1.1.0 for new exports (informational, not breaking)

### 3. Status Flow/Lifecycle

The `ongoing` status should be part of the main game lifecycle alongside playing, backlog, completed, and abandoned:

```
wishlist → ordered → backlog ←→ playing ←→ ongoing
                         ↓         ↓          ↓
                     abandoned  completed  completed
```

Users can transition between:
- `backlog` ↔ `ongoing` (start/stop frequent play)
- `playing` ↔ `ongoing` (active session vs regular return)
- `ongoing` → `completed` (finally "done" with it)
- `ongoing` → `abandoned` (lost interest)

---

## Implementation Steps

### Phase 1: Core Model & Database

#### 1.1 Add enum value
**File:** `lib/models/game_models.dart`

Add `ongoing` to the end of the enum:
```dart
enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered, ongoing }
```

#### 1.2 Run code generation
```bash
dart run build_runner build --delete-conflicting-outputs
```

No database migration needed - the integer column accepts any value, and index 6 is new.

---

### Phase 2: UI Display Components

#### 2.1 Status Button
**File:** `lib/shared/widgets/buttons/status_button.dart`

Add case to `_getStatusIcon()`:
```dart
case GameStatus.ongoing:
  return Icons.replay;
```

Add case to `_getStatusLabel()`:
```dart
case GameStatus.ongoing:
  return 'Ongoing';
```

#### 2.2 Game Detail Sheet Info
**File:** `lib/screens/main/widgets/game_detail_sheet_info.dart`

Add to all four switch statements:
- `_getStatusColor()` → suggest `Color(0xFF06B6D4)` (Cyan/Teal)
- `_getStatusIcon()` → `Icons.replay`
- `_buildCurrentStatusIcon()` → appropriate icon styling
- `_getStatusDisplayText()` → `'Ongoing'`

#### 2.3 Game Actions Service
**File:** `lib/services/game_actions_service.dart`

Add to all three helper methods:
- `_getStatusDisplayName()` → `'Ongoing'`
- `_getStatusIcon()` → `Icons.replay`
- `_getStatusColor()` → same cyan/teal colour

#### 2.4 Chart Data Service
**File:** `lib/services/chart_data_service.dart`

Add to `_getStatusLabels()`:
```dart
GameStatus.ongoing: 'Ongoing',
```

#### 2.5 Profile Styles
**File:** `lib/styles/profile_styles.dart`

Add to `statusColors` map:
```dart
'Ongoing': Color(0xFF06B6D4),  // Cyan/Teal
```

---

### Phase 3: Status Selector Logic

#### 3.1 Update Status Selector
**File:** `lib/shared/widgets/inputs/game_status_selector.dart`

This widget is used by both the **game edit screen** and the **game detail panel**, so updating it here covers both locations.

**Add mode list** - add `ongoing`:
```dart
return [GameStatus.playing, GameStatus.backlog, GameStatus.completed,
        GameStatus.abandoned, GameStatus.wishlist, GameStatus.ordered, GameStatus.ongoing];
```

**Main lifecycle group** - add `ongoing`:
```dart
if (widget.selectedStatus == GameStatus.playing ||
    widget.selectedStatus == GameStatus.backlog ||
    widget.selectedStatus == GameStatus.completed ||
    widget.selectedStatus == GameStatus.abandoned ||
    widget.selectedStatus == GameStatus.ongoing) {
  return [GameStatus.playing, GameStatus.backlog, GameStatus.completed,
          GameStatus.abandoned, GameStatus.ongoing];
}
```

This ensures users can:
- Select "Ongoing" when adding a new game (add mode)
- Change an existing game to "Ongoing" from the edit screen
- Change an existing game to "Ongoing" from the game detail panel

---

### Phase 4: Home Screen

#### 4.1 Add Ongoing Section
**File:** `lib/screens/main/main_screen.dart`

Insert new section between Playing and Backlog:
```dart
_buildGameSection('Playing', GameStatus.playing, isLandscape),
_buildGameSection('Ongoing/Frequently Played', GameStatus.ongoing, isLandscape),
_buildGameSection('Backlog', GameStatus.backlog, isLandscape),
_buildGameSection('Completed', GameStatus.completed, isLandscape),
_buildGameSection('Abandoned', GameStatus.abandoned, isLandscape),
```

---

### Phase 5: Backlog Screen Filter Pills

#### 5.1 Add State for Status Filters
**File:** `lib/screens/backlog/backlog_screen.dart`

Add state variables:
```dart
bool _showBacklog = true;
bool _showOngoing = true;
```

#### 5.2 Add Filter Pills UI

Add two new filter pills after the existing sort pills:
```dart
// Existing sort pills
_buildSortChip('Title', _sortByTitle, () => _toggleSort('title')),
_buildSortChip('Date Added', !_sortByTitle, () => _toggleSort('date')),

// New status filter pills
_buildStatusFilterChip('Backlog', _showBacklog, _toggleBacklogFilter),
_buildStatusFilterChip('Ongoing', _showOngoing, _toggleOngoingFilter),
```

#### 5.3 Implement Toggle Logic

```dart
void _toggleBacklogFilter() {
  setState(() {
    // Cannot turn both off - if turning backlog off, ensure ongoing is on
    if (_showBacklog && !_showOngoing) {
      _showOngoing = true;
    }
    _showBacklog = !_showBacklog;
  });
}

void _toggleOngoingFilter() {
  setState(() {
    // Cannot turn both off - if turning ongoing off, ensure backlog is on
    if (_showOngoing && !_showBacklog) {
      _showBacklog = true;
    }
    _showOngoing = !_showOngoing;
  });
}
```

#### 5.4 Update Game Filtering

Modify the filtering logic:
```dart
List<GameItem> filteredGames = games.where((game) {
  if (_showBacklog && game.status == GameStatus.backlog) return true;
  if (_showOngoing && game.status == GameStatus.ongoing) return true;
  return false;
}).toList();
```

#### 5.5 Build Status Filter Chip Widget

```dart
Widget _buildStatusFilterChip(String label, bool isActive, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.secondaryText,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.secondaryText,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ),
  );
}
```

---

### Phase 6: Backup Service

#### 6.1 Update Backup Version
**File:** `lib/services/full_backup_service.dart`

Change version constant:
```dart
static const String _backupVersion = '1.1.0';
```

#### 6.2 Add Version Handling (Optional but Recommended)

Add import version check for future-proofing:
```dart
final version = metadata['version'] as String?;
// Log or handle version differences if needed
// Currently no migration needed since we're appending to enum
```

---

### Phase 7: Tests

#### 7.1 Model Tests
**File:** `test/models/game_models_test.dart`

- Add test for `GameStatus.ongoing` existence
- Update any status enumeration tests

#### 7.2 Provider Tests
**File:** `test/providers/game_provider_test.dart`

- Add tests filtering by `ongoing` status
- Update status-related test data

#### 7.3 Widget Tests

Update tests for:
- `test/shared/widgets/buttons/status_button_test.dart`
- `test/shared/widgets/inputs/game_status_selector_test.dart`
- `test/screens/backlog/backlog_screen_test.dart`
- `test/screens/main/main_screen_test.dart`

#### 7.4 Test Helpers
**File:** `test/test_helpers.dart`

Add helper to create test games with `ongoing` status.

---

## File Change Summary

| File | Change Type |
|------|-------------|
| `lib/models/game_models.dart` | Add enum value |
| `lib/shared/widgets/buttons/status_button.dart` | Add switch cases |
| `lib/shared/widgets/inputs/game_status_selector.dart` | Add to status lists |
| `lib/screens/main/main_screen.dart` | Add section |
| `lib/screens/main/widgets/game_detail_sheet_info.dart` | Add switch cases |
| `lib/screens/backlog/backlog_screen.dart` | Add filter state, pills, logic |
| `lib/services/game_actions_service.dart` | Add switch cases |
| `lib/services/chart_data_service.dart` | Add to map |
| `lib/services/full_backup_service.dart` | Bump version |
| `lib/styles/profile_styles.dart` | Add colour |
| `test/*` (multiple files) | Update tests |

**Estimated files to modify:** ~15-20 files

---

## Backwards Compatibility Guarantee

1. **Existing database records:** Unaffected - indices 0-5 remain unchanged
2. **Old backups (v1.0.0):** Will import correctly - no migration needed
3. **New backups (v1.1.0):** Can include `ongoing` status (index 6)
4. **Importing new backup to old app:** Would fail if backup contains `ongoing` games (acceptable trade-off)

---

## Confirmed Design Decisions

- **Icon:** `Icons.replay` - represents "frequently returned to"
- **Colour:** Cyan/Teal (`0xFF06B6D4`) - distinct from existing statuses
- **Section title:** "Ongoing/Frequently Played" - clarifies that ongoing means games without a traditional end
- **Default filter state:** Both Backlog and Ongoing default to ON

---

## Execution Order

1. Phase 1 (Model) - Must be first
2. Phase 2 (UI Display) - Can run in parallel
3. Phase 3 (Status Selector) - After Phase 1
4. Phase 4 (Home Screen) - After Phase 1
5. Phase 5 (Backlog Screen) - After Phase 1
6. Phase 6 (Backup) - After Phase 1
7. Phase 7 (Tests) - After all implementation

Run `flutter analyze` and `flutter test` after each phase to catch issues early.
