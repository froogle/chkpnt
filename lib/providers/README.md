# Providers Directory

This directory contains Riverpod providers for state management throughout the application.

## 🎯 Purpose

Providers manage application state and serve as the bridge between UI and business logic:
- **State Management** - Hold and update application state
- **Dependency Injection** - Provide services and repositories to widgets
- **Reactive Updates** - Automatically notify UI of state changes
- **Lifecycle Management** - Handle state creation, caching, and disposal

## 🧩 Implemented Providers

### Game State Providers (`game_provider.dart`)

**`gameListProvider`** - Main games list state
```dart
@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() => _sampleGames;

  void addGame(GameItem game) { /* ... */ }
  void updateGame(GameItem updatedGame) { /* ... */ }
  void removeGame(String gameId) { /* ... */ }
  void startPlaying(String gameId) { /* ... */ }
  void markCompleted(String gameId) { /* ... */ }
}
```

**`gamesByStatusProvider`** - Games filtered by status
```dart
@riverpod
List<GameItem> gamesByStatus(GamesByStatusRef ref, GameStatus status) {
  final games = ref.watch(gameListProvider);
  return games.where((game) => game.status == status).toList();
}
```

**`filteredGamesProvider`** - Games filtered by status and platform
```dart
@riverpod
List<GameItem> filteredGames(FilteredGamesRef ref, GameStatus status, String platform) {
  // Filters games by both status and platform
}
```

**`fullyFilteredGamesProvider`** - Games filtered by status, platform, and search
```dart
@riverpod
List<GameItem> fullyFilteredGames(FullyFilteredGamesRef ref, GameStatus status, String platform, String searchQuery) {
  // Filters games by status, platform, and search query
}
```

**`availablePlatformsProvider`** - Dynamic list of available platforms
```dart
@riverpod
List<String> availablePlatforms(AvailablePlatformsRef ref) {
  // Returns ['All', ...unique platforms from games]
}
```

### UI State Providers (`ui_state_provider.dart`)

**`searchQueryProvider`** - Search input state
```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) { state = query; }
  void clearQuery() { state = ''; }
}
```

**`selectedPlatformProvider`** - Platform filter state
```dart
@riverpod
class SelectedPlatform extends _$SelectedPlatform {
  @override
  String build() => 'All';

  void selectPlatform(String platform) { state = platform; }
  void resetToAll() { state = 'All'; }
}
```

**`sectionExpansionProvider`** - Collapsible section states
```dart
@riverpod
class SectionExpansion extends _$SectionExpansion {
  @override
  Map<String, bool> build() => {
    'Playing': true,
    'Backlog': false,
    'Completed': false,
    'Abandoned': false,
  };

  void toggleSection(String sectionName) { /* ... */ }
  void expandSection(String sectionName) { /* ... */ }
  void collapseSection(String sectionName) { /* ... */ }
}
```

## 🚀 Usage Examples

### Reading State
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gameListProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    
    return YourUI();
  }
}
```

### Updating State
```dart
// Add a new game
ref.read(gameListProvider.notifier).addGame(newGame);

// Update search query
ref.read(searchQueryProvider.notifier).updateQuery('zelda');

// Change platform filter
ref.read(selectedPlatformProvider.notifier).selectPlatform('Switch');

// Toggle section expansion
ref.read(sectionExpansionProvider.notifier).toggleSection('Playing');
```

### Complex Filtering
```dart
// Get games that match all filters (status + platform + search)
final filteredGames = ref.watch(fullyFilteredGamesProvider(
  GameStatus.playing,
  'Switch',
  'zelda'
));
```

## 🏗️ Architecture Benefits

1. **Reactive Updates**: UI automatically rebuilds when state changes
2. **Efficient Filtering**: Providers cache results and only recompute when dependencies change  
3. **Type Safety**: Full compile-time type checking with generated code
4. **Performance**: Only widgets that depend on changed state rebuild
5. **Testability**: Easy to test by providing mock providers
6. **DevTools Integration**: Full debugging support with Riverpod DevTools

## 📝 Next Steps

Consider adding providers for:
- Game detail state management
- Settings and preferences
- User authentication state
- Data persistence (repositories)
- Network state and caching

## 🧪 Testing Providers

### Test Setup

Add these dependencies to your `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test: ^1.0.0
  riverpod_test: ^2.0.0
  mockito: ^5.4.2
  build_runner: ^2.4.7
```

### Basic Provider Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_test/riverpod_test.dart';
import '../lib/providers/game_provider.dart';
import '../lib/models/game_item.dart';

void main() {
  group('GameList Provider Tests', () {
    testWidgets('should start with sample games', (tester) async {
      final container = createContainer();
      
      final games = container.read(gameListProvider);
      
      expect(games, isNotEmpty);
      expect(games.length, greaterThan(0));
    });

    testWidgets('should add game correctly', (tester) async {
      final container = createContainer();
      final notifier = container.read(gameListProvider.notifier);
      
      final newGame = GameItem(
        id: 'test-id',
        title: 'Test Game',
        platform: 'PC',
        status: GameStatus.backlog,
        addedDate: DateTime.now(),
      );
      
      notifier.addGame(newGame);
      
      final games = container.read(gameListProvider);
      expect(games.any((game) => game.id == 'test-id'), isTrue);
    });

    testWidgets('should update game status', (tester) async {
      final container = createContainer();
      final notifier = container.read(gameListProvider.notifier);
      
      // Add a test game first
      final testGame = GameItem(
        id: 'test-update',
        title: 'Update Test',
        platform: 'Switch',
        status: GameStatus.backlog,
        addedDate: DateTime.now(),
      );
      notifier.addGame(testGame);
      
      // Start playing the game
      notifier.startPlaying('test-update');
      
      final games = container.read(gameListProvider);
      final updatedGame = games.firstWhere((game) => game.id == 'test-update');
      expect(updatedGame.status, GameStatus.playing);
      expect(updatedGame.startedDate, isNotNull);
    });
  });
}
```

### Testing Computed Providers

```dart
group('Filtered Games Provider Tests', () {
  testWidgets('should filter games by status', (tester) async {
    final container = createContainer();
    
    final playingGames = container.read(
      gamesByStatusProvider(GameStatus.playing)
    );
    
    expect(
      playingGames.every((game) => game.status == GameStatus.playing),
      isTrue,
    );
  });

  testWidgets('should filter by platform and status', (tester) async {
    final container = createContainer();
    
    final switchPlayingGames = container.read(
      filteredGamesProvider(GameStatus.playing, 'Switch')
    );
    
    expect(
      switchPlayingGames.every((game) => 
        game.status == GameStatus.playing && game.platform == 'Switch'
      ),
      isTrue,
    );
  });

  testWidgets('should filter by all criteria', (tester) async {
    final container = createContainer();
    
    final filteredGames = container.read(
      fullyFilteredGamesProvider(GameStatus.backlog, 'PC', 'zelda')
    );
    
    expect(
      filteredGames.every((game) => 
        game.status == GameStatus.backlog &&
        game.platform == 'PC' &&
        game.title.toLowerCase().contains('zelda')
      ),
      isTrue,
    );
  });
});
```

### Testing UI State Providers

```dart
group('UI State Provider Tests', () {
  testWidgets('search query should update correctly', (tester) async {
    final container = createContainer();
    final notifier = container.read(searchQueryProvider.notifier);
    
    // Initial state should be empty
    expect(container.read(searchQueryProvider), '');
    
    // Update query
    notifier.updateQuery('zelda');
    expect(container.read(searchQueryProvider), 'zelda');
    
    // Clear query
    notifier.clearQuery();
    expect(container.read(searchQueryProvider), '');
  });

  testWidgets('platform selection should work', (tester) async {
    final container = createContainer();
    final notifier = container.read(selectedPlatformProvider.notifier);
    
    // Initial state should be 'All'
    expect(container.read(selectedPlatformProvider), 'All');
    
    // Select platform
    notifier.selectPlatform('Switch');
    expect(container.read(selectedPlatformProvider), 'Switch');
    
    // Reset to all
    notifier.resetToAll();
    expect(container.read(selectedPlatformProvider), 'All');
  });

  testWidgets('section expansion should toggle correctly', (tester) async {
    final container = createContainer();
    final notifier = container.read(sectionExpansionProvider.notifier);
    
    final initialState = container.read(sectionExpansionProvider);
    expect(initialState['Playing'], isTrue);
    expect(initialState['Backlog'], isFalse);
    
    // Toggle playing section
    notifier.toggleSection('Playing');
    final afterToggle = container.read(sectionExpansionProvider);
    expect(afterToggle['Playing'], isFalse);
    
    // Expand backlog section
    notifier.expandSection('Backlog');
    final afterExpand = container.read(sectionExpansionProvider);
    expect(afterExpand['Backlog'], isTrue);
  });
});
```

### Testing Provider Dependencies

```dart
group('Provider Dependencies Tests', () {
  testWidgets('filtered games should react to search query changes', (tester) async {
    final container = createContainer();
    
    // Set initial filters
    container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
    container.read(searchQueryProvider.notifier).updateQuery('zelda');
    
    final initialResults = container.read(
      fullyFilteredGamesProvider(GameStatus.backlog, 'PC', 'zelda')
    );
    
    // Change search query
    container.read(searchQueryProvider.notifier).updateQuery('mario');
    
    final newResults = container.read(
      fullyFilteredGamesProvider(GameStatus.backlog, 'PC', 'mario')
    );
    
    expect(newResults, isNot(equals(initialResults)));
  });
});
```

### Mocking External Dependencies

```dart
// For providers that depend on external services
class MockGameRepository extends Mock implements GameRepository {}

group('Game Provider with Repository Tests', () {
  testWidgets('should load games from repository', (tester) async {
    final mockRepository = MockGameRepository();
    
    when(mockRepository.getAllGames()).thenReturn([
      GameItem(id: '1', title: 'Mock Game', platform: 'PC', status: GameStatus.backlog, addedDate: DateTime.now()),
    ]);
    
    final container = createContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    
    final games = container.read(gameListProvider);
    verify(mockRepository.getAllGames()).called(1);
    expect(games.length, 1);
    expect(games.first.title, 'Mock Game');
  });
});
```

### Integration Testing

```dart
group('Provider Integration Tests', () {
  testWidgets('complete game management workflow', (tester) async {
    final container = createContainer();
    
    // Add a game
    final gameNotifier = container.read(gameListProvider.notifier);
    final testGame = GameItem(
      id: 'integration-test',
      title: 'Integration Game',
      platform: 'Switch',
      status: GameStatus.backlog,
      addedDate: DateTime.now(),
    );
    gameNotifier.addGame(testGame);
    
    // Filter to show only Switch games
    container.read(selectedPlatformProvider.notifier).selectPlatform('Switch');
    
    // Search for the game
    container.read(searchQueryProvider.notifier).updateQuery('integration');
    
    // Check filtered results
    final filteredGames = container.read(
      fullyFilteredGamesProvider(GameStatus.backlog, 'Switch', 'integration')
    );
    
    expect(filteredGames.length, 1);
    expect(filteredGames.first.id, 'integration-test');
    
    // Start playing the game
    gameNotifier.startPlaying('integration-test');
    
    // Verify status changed
    final playingGames = container.read(
      gamesByStatusProvider(GameStatus.playing)
    );
    expect(playingGames.any((game) => game.id == 'integration-test'), isTrue);
  });
});
```

### Test Utilities

Create a helper file `test/test_utils.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/riverpod_test.dart';

ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  return createProviderContainer(
    overrides: overrides,
  );
}

// Helper to create test games
GameItem createTestGame({
  String? id,
  String? title,
  String? platform,
  GameStatus? status,
}) {
  return GameItem(
    id: id ?? 'test-${DateTime.now().millisecondsSinceEpoch}',
    title: title ?? 'Test Game',
    platform: platform ?? 'PC',
    status: status ?? GameStatus.backlog,
    addedDate: DateTime.now(),
  );
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run only provider tests
flutter test test/providers/

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Best Practices

1. **Test Provider Logic, Not Implementation**: Focus on testing the behavior and state changes
2. **Use Container Isolation**: Each test should use a fresh container
3. **Test Edge Cases**: Empty states, invalid inputs, boundary conditions
4. **Mock External Dependencies**: Use mocks for repositories, APIs, etc.
5. **Test Provider Interactions**: Verify how providers work together
6. **Keep Tests Fast**: Avoid unnecessary delays or complex setup
7. **Descriptive Test Names**: Make test purposes clear from the name