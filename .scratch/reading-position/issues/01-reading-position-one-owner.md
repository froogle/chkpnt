# Give the Text Guide Reading Position one owner

Status: resolved

The Text Guide reader saves the Reading Position from four places: a 500ms scroll debounce, `dispose`, the close button and the `PopScope` handler. Closing the reader fires three of them. The value saved is the index into the screen's flattened list of section headers, blocks and spacers, written to `lastReadSection`, while `lastReadBlock` is always 0. The stored value therefore means something other than its columns, and would silently break if the flattening changed. Nothing tests any of it, and `GameDatabase` cannot be given an in-memory executor.

## Decisions

- **Stored value:** the Reading Position is a true (section, block) pair in `lastReadSection` and `lastReadBlock`. The new module converts between the pair and the flattened index in both directions.
- **Row mapping:** a section header and its first block both save as (section, 0), and (section, 0) restores to the header. A spacer saves as (next section, 0). A pair that no longer fits the content opens at the top.
- **Owner:** an autoDispose `AsyncNotifier` Family, `ReadingPosition`, keyed by `GuideId`, in `lib/providers/reading_position_provider.dart`, used as `readingPositionProvider(guideId)`.
  - `build` reads the Guide from `guideRepositoryProvider` and its content from `GuideStorageService`, flattens the content, and returns the list items with the index to start at.
  - One method takes the index of the row at the top of the reader.
  - It saves after a 500ms debounce, and saves the latest position from `ref.onDispose`. It holds the repository from `build`.
  - A failed save stays silent.
- **Flattening:** the `GuideListItem` sealed types and the flattening move from the screen into the module.
- **Screen:** `GuideReaderScreen` watches the provider and switches on its `AsyncValue`. It keeps the rendering and turns `ItemPositionsListener` output into the top row's index. It loses `_loadGuideContent`, `_buildFlattenedItems`, `_isLoading`, `_errorMessage`, `_flattenedItems`, the debounce timer, the position fields, and the saves in `dispose`, `_handleClose` and `PopScope`. Attribution, delete, preferences and the toolbar are unchanged.
- **Deleted:** `GuidesForGame.updateReadPosition`, which loses its only caller. `GuideRepository.updateGuideReadPosition` keeps its signature.
- **Database:** `GameDatabase` gains a constructor taking a `QueryExecutor`. `schemaVersion` goes to 8, with a migration that resets every Reading Position to (0, 0). The app has not shipped, so earlier flattened indices are not converted.
- **Backups:** the backup format is unchanged; importing an older backup may open a Text Guide at the wrong place once.
- **Tests:**
  - `test/providers/reading_position_provider_test.dart`, through a `ProviderContainer`. `guideRepositoryProvider` is overridden with a `DriftGuideRepository` over in-memory Drift, and content goes through the real `GuideStorageService` in a temp directory via `TempPathProviderPlatform`. Covers:
    - a new Guide opening at the start;
    - a moved-to block storing its (section, block) pair after the debounce;
    - disposal saving the latest position;
    - reopening returning to the same row, including the header and spacer rules;
    - an out-of-range pair opening at the top;
    - a missing content file giving an error state.
  - A migration test, following the existing legacy database tests, that v7 to v8 resets Reading Positions.
  - No new screen test.
- **Delivery:** branch `refactor/reading-position` from main, one PR.

## Acceptance

- The Reading Position is saved by one module, with no saves left in the reader screen.
- `lastReadSection` and `lastReadBlock` hold the section and block they name.
- The Reading Position has tests that run against in-memory Drift.

## Comments

Implemented in PR #22 (`refactor/reading-position`).
