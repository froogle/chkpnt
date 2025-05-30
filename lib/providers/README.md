# Providers Directory

This directory contains Riverpod providers for state management throughout the application.

## 🎯 Purpose

Providers manage application state and serve as the bridge between UI and business logic:
- **State Management** - Hold and update application state
- **Dependency Injection** - Provide services and repositories to widgets
- **Reactive Updates** - Automatically notify UI of state changes
- **Lifecycle Management** - Handle state creation, caching, and disposal

## 🧩 Provider Types

### Game State Providers
Future providers for game-related state:

**`gameListProvider`**
```dart
// Manages the list of all games
final gameListProvider = StateNotifierProvider<GameListNotifier, List<GameItem>>(
  (ref) => GameListNotifier(ref.watch(gameServiceProvider)),
);
```

**`gamesByStatusProvider`**
```dart
// Filtered games by status (playing, completed, etc.)
final gamesByStatusProvider = Provider.family<List<GameItem>, GameStatus>(
  (ref, status) {
    final games = ref.watch(gameListProvider);
    return games.where((game) => game.status == status).toList();
  },
);
```

**`selectedGameProvider`**
```dart
// Currently selected/viewed game
final selectedGameProvider = StateProvider<GameItem?>((ref) => null);
```

### UI State Providers

**`searchQueryProvider`**
```dart
// Search input state
final searchQueryProvider = StateProvider<String>((ref) => '');
```

**`selectedPlatformProvider`**
```dart
// Platform filter state
final selectedPlatformProvider = StateProvider<String>((ref) => 'All');
```

**`sectionExpansionProvider`**
```dart
// Collapsible section states
final sectionExpansionProvider = StateProvider<Map<String, bool>>(
  (ref) => {
    'Playing': true,
    'Backlog': false,
    'Completed': false,
    'Abandoned': false,
  },
);
```

### Service Providers

**`gameServiceProvider`**
```dart
// Game service dependency injection
final gameServiceProvider = Provider<GameService>((ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return GameServiceImpl(repository);
});
```

**`userPreferencesProvider`**
```dart
// User preferences and settings
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  (ref) => UserPreferencesNotifier(ref.watch(preferencesServiceProvider)),
);
```

## 🏗️ Provider Architecture

### StateNotifier Pattern
For complex state that needs business logic:

```dart
class GameListNotifier extends StateNotifier<List<GameItem>> {
  final GameService _gameService;

  GameListNotifier(this._gameService) : super([]) {
    _loadGames();
  }

  Future<void> _loadGames() async {
    try {
      final games = await _gameService.getAllGames();
      state = games;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addGame(GameItem game) async {
    try {
      final newGame = await _gameService.createGame(game);
      state = [...state, newGame];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateGameStatus(String gameId, GameStatus newStatus) async {
    try {
      await _gameService.updateGameStatus(gameId, newStatus);
      state = [
        for (final game in state)
          if (game.id == gameId)
            game.copyWith(status: newStatus)
          else
            game,
      ];
    } catch (e) {
      // Handle error
    }
  }
}
```

### Family Providers
For parameterized providers:

```dart
// Get games filtered by multiple criteria
final filteredGamesProvider = Provider.family<List<GameItem>, GameFilter>(
  (ref, filter) {
    final games = ref.watch(gameListProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return games
        .where((game) => _matchesFilter(game, filter))
        .where((game) => _matchesSearch(game, searchQuery))
        .toList();
  },
);
```

### Async Providers
For loading data asynchronously:

```dart
final gameStatsProvider = FutureProvider<GameStats>((ref) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.calculateStats();
});
```

## 🔄 State Flow

```
UI Widget
    ↓ (reads state)
Provider
    ↓ (calls business logic)
Service
    ↓ (data operations)
Repository
    ↓ (persistence)
Database/API
```

## 🧪 Testing Providers

### Provider Testing
```dart
testWidgets('gameListProvider loads games correctly', (tester) async {
  final container = ProviderContainer(
    overrides: [
      gameServiceProvider.overrideWithValue(mockGameService),
    ],
  );

  when(() => mockGameService.getAllGames())
      .thenAnswer((_) async => [testGame1, testGame2]);

  final notifier = container.read(gameListProvider.notifier);
  await tester.pump();

  final games = container.read(gameListProvider);
  expect(games.length, 2);
  expect(games.first.title, 'Test Game 1');
});
```

## 📋 Provider Guidelines

### State Structure
✅ **Immutable State** - Use immutable data classes
✅ **Normalized Data** - Avoid nested objects where possible
✅ **Computed Values** - Use Provider.family for derived state
✅ **Separate Concerns** - UI state vs business state

### Performance
✅ **Granular Providers** - Small, focused providers
✅ **Selective Watching** - Only watch what you need
✅ **Family Providers** - For parameterized state
✅ **AutoDispose** - Use autoDispose for temporary state

### Error Handling
✅ **AsyncValue** - Use AsyncValue for loading/error states
✅ **Try-Catch** - Handle errors in StateNotifier methods
✅ **User Feedback** - Show meaningful error messages
✅ **Fallback State** - Provide sensible defaults

## 🔄 Future Implementation

Providers will be added progressively:

1. **Basic State** - Simple StateProviders for UI state
2. **Game Management** - StateNotifiers for game CRUD
3. **Advanced Features** - Complex business logic providers
4. **Optimization** - Performance tuning and caching

## 📚 Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [State Management Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Provider Testing Guide](https://riverpod.dev/docs/cookbooks/testing)