# Providers Directory

This directory contains **streaming-based Riverpod providers** for reactive state management throughout the application.

## 🎯 Purpose

Providers manage application state using **streaming data sources** and serve as the bridge between UI and business logic:
- **Streaming State Management** - Real-time reactive updates from data repositories
- **Async State Handling** - Proper loading, error, and data states with `AsyncValue`
- **Repository Integration** - Connect UI to persistent storage through repository pattern
- **Dependency Injection** - Provide services and repositories to widgets
- **Reactive Updates** - Automatically notify UI of state changes
- **Lifecycle Management** - Handle state creation, caching, and disposal

## 🔄 **Streaming Architecture Overview**

```dart
// Repository provides streaming data
abstract class GameRepository {
  Stream<List<GameItem>> watchGames();    // Streaming source
  Future<GameItem> createGame(GameItem game);  // Mutations
}

// Provider consumes stream and exposes to UI
@riverpod
class GameList extends _$GameList {
  @override
  Stream<List<GameItem>> build() {
    final repository = ref.read(gameRepositoryProvider);
    return repository.watchGames();  // Stream from repository
  }

  // Async mutations
  Future<void> addGame(GameItem game) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.createGame(game);
    // Stream automatically updates UI
  }
}

// UI consumes with AsyncValue handling
final gamesAsync = ref.watch(gamesStreamProvider);
return gamesAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
  data: (games) => GamesList(games: games),
);
```

## 🧩 Implemented Providers

### **Streaming Game State Providers** (`game_provider.dart`)

#### **Repository Provider**
```dart
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  return InMemoryGameRepository(); // Easy to swap for persistent storage
}
```

#### **Core Streaming Providers**

**`gamesStreamProvider`** - **Primary streaming data source**
```dart
@riverpod
Stream<List<GameItem>> gamesStream(GamesStreamRef ref) {
  final repository = ref.read(gameRepositoryProvider);
  return repository.watchGames(); // Stream from repository
}
```

**`gameListProvider`** - **Synchronous access to current state**
```dart
@riverpod
class GameList extends _$GameList {
  @override
  Stream<List<GameItem>> build() {
    return ref.read(gameRepositoryProvider).watchGames();
  }

  // Async mutations - repository handles persistence
  Future<void> addGame(GameItem game) async {
    await ref.read(gameRepositoryProvider).createGame(game);
  }

  Future<void> updateGame(GameItem updatedGame) async {
    await ref.read(gameRepositoryProvider).updateGame(updatedGame);
  }

  Future<void> removeGame(GameId gameId) async {
    await ref.read(gameRepositoryProvider).deleteGame(gameId);
  }

  Future<void> startPlaying(GameId gameId) async {
    final games = await ref.read(gameRepositoryProvider).getAllGames();
    final game = games.firstWhere((g) => g.id == gameId);
    final updatedGame = game.copyWith(
      status: GameStatus.playing,
      lastStatusChange: DateTime.now(),
    );
    await updateGame(updatedGame);
  }

  Future<void> markCompleted(GameId gameId) async {
    final games = await ref.read(gameRepositoryProvider).getAllGames();
    final game = games.firstWhere((g) => g.id == gameId);
    final updatedGame = game.copyWith(
      status: GameStatus.completed,
      lastStatusChange: DateTime.now(),
    );
    await updateGame(updatedGame);
  }

  // Convenience method for game creation with auto-timestamps
  Future<void> createGame({
    required String title,
    required String platform,
    required GameStatus status,
    String? imagePath,
    String? remoteImageUrl,
  }) async {
    final game = GameItem.create(
      title: title,
      platform: platform,
      status: status,
      imagePath: imagePath,
      remoteImageUrl: remoteImageUrl,
    );
    await addGame(game);
  }
}
```

#### **Derived Reactive Providers**

**`gamesByStatusProvider`** - **Automatically reacts to stream changes**
```dart
@riverpod
List<GameItem> gamesByStatus(GamesByStatusRef ref, GameStatus status) {
  final games = ref.watch(gameListProvider);
  return games.where((game) => game.status == status).toList();
}
```

**`gamesByPlatformProvider`** - **Platform filtering with reactive updates**
```dart
@riverpod
List<GameItem> gamesByPlatform(GamesByPlatformRef ref, String platform) {
  final games = ref.watch(gameListProvider);
  if (platform == 'All') return games;
  return games.where((game) => game.platform == platform).toList();
}
```

**`fullyFilteredGamesProvider`** - **Combined filtering with real-time updates**
```dart
@riverpod
List<GameItem> fullyFilteredGames(
  FullyFilteredGamesRef ref,
  GameStatus status,
  String platform,
  String searchQuery,
) {
  final games = ref.watch(gameListProvider);

  return games.where((game) {
    final statusMatch = game.status == status;
    final platformMatch = platform == 'All' || game.platform == platform;
    final searchMatch = searchQuery.isEmpty ||
        game.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        game.platform.toLowerCase().contains(searchQuery.toLowerCase());

    return statusMatch && platformMatch && searchMatch;
  }).toList();
}
```

**`availablePlatformsProvider`** - **Dynamic platform list**
```dart
@riverpod
List<String> availablePlatforms(AvailablePlatformsRef ref) {
  final games = ref.watch(gameListProvider);
  final platforms = games.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}
```

**`searchFilteredGamesProvider`** - **Search functionality**
```dart
@riverpod
List<GameItem> searchFilteredGames(SearchFilteredGamesRef ref, String query) {
  final games = ref.watch(gameListProvider);
  if (query.isEmpty) return games;

  final lowerQuery = query.toLowerCase();
  return games.where((game) {
    return game.title.toLowerCase().contains(lowerQuery) ||
           game.platform.toLowerCase().contains(lowerQuery);
  }).toList();
}
```

### **UI State Providers** (`ui_state_provider.dart`)

**`searchQueryProvider`** - **Search input state**
```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) { state = query; }
  void clearQuery() { state = ''; }
}
```

**`selectedPlatformProvider`** - **Platform filter state**
```dart
@riverpod
class SelectedPlatform extends _$SelectedPlatform {
  @override
  String build() => 'All';

  void selectPlatform(String platform) { state = platform; }
  void resetToAll() { state = 'All'; }
}
```

**`sectionExpansionProvider`** - **Collapsible section states**
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

  void toggleSection(String sectionName) {
    state = {...state, sectionName: !state[sectionName]!};
  }

  void expandSection(String sectionName) {
    state = {...state, sectionName: true};
  }

  void collapseSection(String sectionName) {
    state = {...state, sectionName: false};
  }

  void expandAll() {
    state = state.map((key, _) => MapEntry(key, true));
  }

  void collapseAll() {
    state = state.map((key, _) => MapEntry(key, false));
  }
}
```

## 🚀 Usage Examples

### **Reading Streaming State with Async Handling**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesStreamProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);

    return gamesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => ErrorWidget.withDetails(
        message: 'Failed to load games',
        error: error,
      ),
      data: (games) => GamesList(
        games: games,
        searchQuery: searchQuery,
        selectedPlatform: selectedPlatform,
      ),
    );
  }
}
```

### **Reading Current State (Synchronous)**
```dart
class GameCountWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Direct access to current state (may be empty during loading)
    final games = ref.watch(gameListProvider);
    return Text('Total games: ${games.length}');
  }
}
```

### **Performing Async Mutations**
```dart
// Add a new game (async operation)
await ref.read(gameListProvider.notifier).addGame(newGame);

// Update game status (async operation)
await ref.read(gameListProvider.notifier).startPlaying(gameId);

// Create game with convenience method
await ref.read(gameListProvider.notifier).createGame(
  title: 'New Game',
  platform: 'Switch',
  status: GameStatus.backlog,
);

// Update UI state (synchronous)
ref.read(searchQueryProvider.notifier).updateQuery('zelda');
ref.read(selectedPlatformProvider.notifier).selectPlatform('Switch');
ref.read(sectionExpansionProvider.notifier).toggleSection('Playing');
```

### **Complex Filtering with Real-time Updates**
```dart
// Get games that match all filters - updates automatically when data changes
final filteredGames = ref.watch(fullyFilteredGamesProvider(
  GameStatus.playing,
  'Switch',
  'zelda'
));

// UI automatically rebuilds when:
// - Game data changes (via stream)
// - Filter criteria changes
// - Search query changes
```

## 🏗️ **Architecture Benefits**

### **Streaming Architecture**
1. **Real-time Updates**: UI automatically reflects data changes from any source
2. **Repository Abstraction**: Easy to swap storage backends (memory → SQLite → Firebase)
3. **Async State Management**: Proper loading, error, and data state handling
4. **Performance**: Streams only emit when data actually changes
5. **Reactive Filtering**: All derived state automatically updates with base data

### **Repository Integration**
1. **Persistence Ready**: Easy integration with any storage solution
2. **Error Handling**: Repository errors properly propagated to UI
3. **Testing**: Easy to mock repositories for testing
4. **Caching**: Repository can implement intelligent caching strategies

### **Development Benefits**
1. **Type Safety**: Full compile-time type checking with generated code
2. **DevTools Integration**: Full debugging support with Riverpod DevTools
3. **Testability**: Easy to test with provider overrides
4. **Hot Reload**: State preservation during development

## 💾 **Repository Integration**

### **Current Implementation: In-Memory**
```dart
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  return InMemoryGameRepository(); // Provides sample data with streaming
}
```

### **Ready for Persistent Storage**
```dart
// Easy to swap implementations
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  return HiveGameRepository();      // or
  return SqliteGameRepository();    // or
  return FirebaseGameRepository();  // Your choice
}

// Repository interface ensures compatibility
abstract class GameRepository {
  Stream<List<GameItem>> watchGames();           // Streaming data
  Future<List<GameItem>> getAllGames();          // One-time access
  Future<GameItem> createGame(GameItem game);    // Mutations
  Future<GameItem> updateGame(GameItem game);
  Future<void> deleteGame(GameId gameId);
  // ... other methods
}
```

## 🧪 **Testing Streaming Providers**

### **Test Infrastructure**
```dart
// test/test_helpers.dart provides streaming-compatible testing
class TestHelpers {
  static ProviderContainer createTestContainer() {
    return ProviderContainer(
      overrides: [
        gameListProvider.overrideWith(() => TestGameListNotifier()),
      ],
    );
  }

  static Future<List<GameItem>> waitForGames(ProviderContainer container) async {
    // Helper for async data loading in tests
  }
}
```

### **Testing Async Operations**
```dart
test('should add game and update stream', () async {
  final container = TestHelpers.createTestContainer();

  // Perform async operation
  await container.read(gameListProvider.notifier).addGame(testGame);

  // Verify state change
  final games = container.read(gameListProvider);
  expect(games.contains(testGame), true);

  container.dispose();
});
```

### **Testing Stream Integration**
```dart
test('should filter games reactively', () async {
  final container = TestHelpers.createTestContainer();
  await TestHelpers.waitForGames(container);

  // Test reactive filtering
  final playingGames = container.read(
    gamesByStatusProvider(GameStatus.playing),
  );

  expect(playingGames.every((g) => g.status == GameStatus.playing), true);
  container.dispose();
});
```

## 📝 **Migration Guide**

### **From Synchronous to Streaming**

**Before:**
```dart
@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() => sampleGames; // Static data

  void addGame(GameItem game) {
    state = [...state, game]; // Direct state mutation
  }
}
```

**After:**
```dart
@riverpod
class GameList extends _$GameList {
  @override
  Stream<List<GameItem>> build() {
    return ref.read(gameRepositoryProvider).watchGames(); // Streaming data
  }

  Future<void> addGame(GameItem game) async {
    await ref.read(gameRepositoryProvider).createGame(game); // Repository mutation
    // Stream automatically updates UI
  }
}
```

### **UI Consumption Changes**

**Before:**
```dart
final games = ref.watch(gameListProvider); // Direct list access
```

**After:**
```dart
// Option 1: Use stream with AsyncValue
final gamesAsync = ref.watch(gamesStreamProvider);
return gamesAsync.when(
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(error),
  data: (games) => GamesList(games),
);

// Option 2: Use current state (may be empty during loading)
final games = ref.watch(gameListProvider);
```

## 🚀 **Next Steps**

Ready for implementation:
1. **Persistent Storage**: Implement `HiveGameRepository` or `SqliteGameRepository`
2. **Cloud Sync**: Add `FirebaseGameRepository` with offline support
3. **External APIs**: Create `ApiGameRepository` for game metadata
4. **Caching**: Implement intelligent caching strategies in repositories
5. **Background Sync**: Add background data synchronisation

The streaming architecture is production-ready and will seamlessly integrate with any storage solution!