import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

part 'game_provider.g.dart';

// === REPOSITORY LAYER ===

/// Repository provider - this is where you can swap storage implementations
@riverpod
GameRepository gameRepository(Ref ref) {
  final repository = DriftGameRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
}

// === STREAMING PROVIDERS ===

/// Main games stream provider - replaces the synchronous gameListProvider
@riverpod
Stream<List<GameItem>> gamesStream(Ref ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGames();
}

/// Current games list provider - provides latest snapshot for UI
/// This is the main provider widgets should watch
@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() {
    // Watch the stream and return current value
    final gamesAsync = ref.watch(gamesStreamProvider);
    return gamesAsync.when(
      data: (games) => games,
      loading: () => [], // Return empty while loading
      error: (error, stack) => [], // Return empty on error
    );
  }

  // Add a new game
  Future<void> addGame(GameItem game) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.createGame(game);
  }

  /// Convenience method for creating new games without timestamp concerns.
  /// This is the preferred method for UI code to add games as it automatically
  /// handles timestamp generation.
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

  // Update an existing game
  Future<void> updateGame(GameItem updatedGame) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.updateGame(updatedGame);
  }

  // Remove a game
  Future<void> removeGame(GameId gameId) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.deleteGame(gameId);
  }

  // Start playing a game (move from backlog to playing)
  Future<void> startPlaying(GameId gameId) async {
    final currentGames = state;
    final game = currentGames.firstWhere((g) => g.id == gameId);
    final updatedGame = game.copyWith(
      status: GameStatus.playing,
      lastStatusChange: DateTime.now(),
      lastModified: DateTime.now(),
    );
    await updateGame(updatedGame);
  }

  // Mark game as completed
  Future<void> markCompleted(GameId gameId) async {
    final currentGames = state;
    final game = currentGames.firstWhere((g) => g.id == gameId);
    final updatedGame = game.copyWith(
      status: GameStatus.completed,
      lastStatusChange: DateTime.now(),
      lastModified: DateTime.now(),
    );
    await updateGame(updatedGame);
  }
}

// === DERIVED STREAMING PROVIDERS ===
// These now work with the streaming data and update automatically

/// Provider for games filtered by status - automatically updates when games change
@riverpod
List<GameItem> gamesByStatus(Ref ref, GameStatus status) {
  final games = ref.watch(gameListProvider);
  final filteredGames = games.where((game) => game.status == status).toList();

  // Sort alphabetically by title (case insensitive)
  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

/// Provider for games filtered by platform - automatically updates when games change
@riverpod
List<GameItem> gamesByPlatform(Ref ref, String platform) {
  final games = ref.watch(gameListProvider);
  final filteredGames =
      platform == 'All'
          ? games.toList()
          : games.where((game) => game.platform == platform).toList();

  // Sort alphabetically by title (case insensitive)
  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

/// Provider for games filtered by both status and platform
@riverpod
List<GameItem> filteredGames(Ref ref, GameStatus status, String platform) {
  final games = ref.watch(gameListProvider);
  final filteredGames =
      games.where((game) {
        final matchesStatus = game.status == status;
        final matchesPlatform = platform == 'All' || game.platform == platform;
        return matchesStatus && matchesPlatform;
      }).toList();

  // Sort alphabetically by title (case insensitive)
  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

/// Provider for available platforms - automatically updates when games change
@riverpod
List<String> availablePlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final platforms = games.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}

/// Provider for platforms from wishlist and ordered games only
@riverpod
List<String> wishlistPlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final wishlistAndOrderedGames =
      games
          .where(
            (game) =>
                game.status == GameStatus.wishlist ||
                game.status == GameStatus.ordered,
          )
          .toList();

  final platforms =
      wishlistAndOrderedGames.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}

/// Provider for games filtered by search query
@riverpod
List<GameItem> searchFilteredGames(Ref ref, String searchQuery) {
  final games = ref.watch(gameListProvider);
  final filteredGames =
      searchQuery.isEmpty
          ? games.toList()
          : games.where((game) {
            return _matchesSearchQuery(game, searchQuery);
          }).toList();

  // Sort alphabetically by title (case insensitive)
  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

/// Provider for games filtered by status, platform, and search
@riverpod
List<GameItem> fullyFilteredGames(
  Ref ref,
  GameStatus status,
  String platform,
  String searchQuery,
) {
  final games = ref.watch(gameListProvider);
  final filteredGames =
      games.where((game) {
        final matchesStatus = game.status == status;
        final matchesPlatform = platform == 'All' || game.platform == platform;

        bool matchesSearch = true;
        if (searchQuery.isNotEmpty) {
          matchesSearch = _matchesSearchQuery(game, searchQuery);
        }

        return matchesStatus && matchesPlatform && matchesSearch;
      }).toList();

  // Sort alphabetically by title (case insensitive)
  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

/// Simple search matching logic using case-insensitive substring matching
bool _matchesSearchQuery(GameItem game, String searchQuery) {
  final query = searchQuery.toLowerCase().trim();
  final title = game.title.toLowerCase();
  final platform = game.platform.toLowerCase();

  // If query is empty, match everything
  if (query.isEmpty) return true;

  // Simple substring match - this will find "Super Metroid" when searching "metroid"
  return title.contains(query) || platform.contains(query);
}

// === ASYNC STATE PROVIDERS ===
// These provide loading and error states for better UX

/// Raw async games provider - exposes loading/error states for UI
@riverpod
AsyncValue<List<GameItem>> gamesAsync(Ref ref) {
  return ref.watch(gamesStreamProvider);
}

/// Loading state provider for UI feedback
@riverpod
bool isGamesLoading(Ref ref) {
  final gamesAsync = ref.watch(gamesAsyncProvider);
  return gamesAsync.isLoading;
}

/// Error state provider for error handling
@riverpod
String? gamesError(Ref ref) {
  final gamesAsync = ref.watch(gamesAsyncProvider);
  return gamesAsync.hasError ? gamesAsync.error.toString() : null;
}

// === BACKLOG SPECIFIC PROVIDERS ===

/// Provider for backlog games sorted and grouped by platform
@riverpod
Map<String, List<GameItem>> sortedBacklogGamesByPlatform(Ref ref) {
  final games = ref.watch(gameListProvider);
  final selectedPlatform = ref.watch(selectedPlatformProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final sortType = ref.watch(backlogSortProvider);
  final sortDirection = ref.watch(backlogSortDirectionStateProvider);

  // Filter to backlog games only
  List<GameItem> backlogGames =
      games.where((game) => game.status == GameStatus.backlog).toList();

  // Apply platform filter
  if (selectedPlatform != 'All') {
    backlogGames =
        backlogGames
            .where((game) => game.platform == selectedPlatform)
            .toList();
  }

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    backlogGames =
        backlogGames.where((game) {
          return _matchesSearchQuery(game, searchQuery);
        }).toList();
  }

  // Group by platform
  final Map<String, List<GameItem>> groupedGames = {};
  for (final game in backlogGames) {
    if (!groupedGames.containsKey(game.platform)) {
      groupedGames[game.platform] = [];
    }
    groupedGames[game.platform]!.add(game);
  }

  // Sort games within each platform group
  for (final platform in groupedGames.keys) {
    final gamesList = groupedGames[platform]!;

    switch (sortType) {
      case BacklogSortType.title:
        gamesList.sort((a, b) {
          final comparison = a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          );
          return sortDirection == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;
      case BacklogSortType.dateAdded:
        gamesList.sort((a, b) {
          final comparison = a.lastStatusChange.compareTo(b.lastStatusChange);
          return sortDirection == SortDirection.ascending
              ? comparison
              : -comparison;
        });
        break;
    }
  }

  // Sort platform keys alphabetically
  final sortedMap = Map<String, List<GameItem>>.fromEntries(
    groupedGames.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );

  return sortedMap;
}

/// Provider for platforms available in backlog
@riverpod
List<String> backlogPlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final backlogGames =
      games.where((game) => game.status == GameStatus.backlog).toList();
  final platforms = backlogGames.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}
