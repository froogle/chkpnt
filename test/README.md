# Test Documentation

This directory contains unit and integration tests for the Game Library app, with a focus on the auto-expansion functionality for filtered sections.

## Test Structure

### Unit Tests

#### `providers/ui_state_provider_test.dart`
Tests the UI state management providers:
- **SectionExpansion**: Tests section expand/collapse functionality and the new `updateExpansionBasedOnResults` method
- **SearchQuery**: Tests search query state management
- **SelectedPlatform**: Tests platform filter state management

Key features tested:
- Default expansion state (Playing: true, others: false)
- Manual toggle, expand, and collapse operations
- Expand/collapse all functionality
- **NEW**: Auto-expansion based on filter results

#### `providers/game_provider_test.dart`
Tests the game data providers and filtering logic:
- **fullyFilteredGamesProvider**: Tests multi-filter functionality (status + platform + search)
- **gamesByStatus**: Tests status-based filtering
- **gamesByPlatform**: Tests platform-based filtering
- **availablePlatforms**: Tests platform list generation
- **searchFilteredGames**: Tests search functionality
- **GameList mutations**: Tests game state changes (startPlaying, markCompleted)

### Integration Tests

#### `main_screen_auto_expansion_test.dart`
Tests the complete auto-expansion workflow:
- **Platform Filter Auto-Expansion**: Verifies sections expand/collapse when platform filters are applied
- **Search Filter Auto-Expansion**: Verifies sections expand/collapse when search is used
- **Combined Filters**: Tests behavior when both platform and search filters are active
- **Filter Reset Behavior**: Ensures manual expansion state is preserved when filters are cleared
- **State Persistence**: Tests manual vs automatic expansion state management

## New Functionality Tests

### Auto-Expansion Logic
The new auto-expansion functionality is tested to ensure:

1. **Filter Detection**: Only activates when platform ≠ "All" OR search query is not empty
2. **Section Expansion**: Sections with matching games expand, empty sections collapse
3. **Filter Combinations**: Works correctly with multiple active filters
4. **State Preservation**: Manual expansion state is maintained when no filters are active
5. **Edge Cases**: Handles empty results, all sections having results, etc.

### Test Scenarios Covered

#### Platform Filtering
- ✅ PC filter: Expands Completed and Abandoned sections (based on sample data)
- ✅ Switch filter: Expands Playing section (Zelda game)
- ✅ Non-existent platform: Collapses all sections

#### Search Filtering
- ✅ "zelda" search: Expands only Playing section
- ✅ "cyber" search: Expands only Completed section
- ✅ Non-existent game search: Collapses all sections

#### Combined Filtering
- ✅ PC + "cyber": Expands only Completed section (Cyberpunk 2077)
- ✅ Switch + "zelda": Expands only Playing section

#### State Management
- ✅ Manual expansion preserved when filters are cleared
- ✅ Auto-expansion overrides manual state when filters are applied
- ✅ Filter changes trigger immediate expansion updates

## Running Tests

To run all tests:
```bash
flutter test
```

To run specific test files:
```bash
flutter test test/providers/ui_state_provider_test.dart
flutter test test/providers/game_provider_test.dart
flutter test test/main_screen_auto_expansion_test.dart
```

To run tests with coverage:
```bash
flutter test --coverage
```

## Sample Data Used in Tests

The tests rely on the sample data defined in `game_provider.dart`:
- **Playing**: Zelda (Switch), God of War (PS5)
- **Completed**: Cyberpunk 2077 (PC), Red Dead Redemption 2 (Xbox)
- **Backlog**: Elden Ring (Steam Deck)
- **Abandoned**: Mass Effect (PC)

This data is used to verify correct filtering and expansion behavior across different scenarios. 