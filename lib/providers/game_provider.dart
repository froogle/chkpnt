import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';

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
  return games.where((game) => game.status == status).toList();
}

/// Provider for games filtered by platform - automatically updates when games change
@riverpod
List<GameItem> gamesByPlatform(Ref ref, String platform) {
  final games = ref.watch(gameListProvider);
  if (platform == 'All') return games;
  return games.where((game) => game.platform == platform).toList();
}

/// Provider for games filtered by both status and platform
@riverpod
List<GameItem> filteredGames(Ref ref, GameStatus status, String platform) {
  final games = ref.watch(gameListProvider);
  return games.where((game) {
    final matchesStatus = game.status == status;
    final matchesPlatform = platform == 'All' || game.platform == platform;
    return matchesStatus && matchesPlatform;
  }).toList();
}

/// Provider for available platforms - automatically updates when games change
@riverpod
List<String> availablePlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final platforms = games.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}

/// Provider for games filtered by search query
@riverpod
List<GameItem> searchFilteredGames(Ref ref, String searchQuery) {
  final games = ref.watch(gameListProvider);
  if (searchQuery.isEmpty) return games;

  return games.where((game) {
    final query = searchQuery.toLowerCase();
    return game.title.toLowerCase().contains(query) ||
        game.platform.toLowerCase().contains(query);
  }).toList();
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
  return games.where((game) {
    final matchesStatus = game.status == status;
    final matchesPlatform = platform == 'All' || game.platform == platform;

    bool matchesSearch = true;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      matchesSearch =
          game.title.toLowerCase().contains(query) ||
          game.platform.toLowerCase().contains(query);
    }

    return matchesStatus && matchesPlatform && matchesSearch;
  }).toList();
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
