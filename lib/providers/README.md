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

### Provider Testing
```