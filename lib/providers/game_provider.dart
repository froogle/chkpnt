import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

part 'game_provider.g.dart';

// === REPOSITORY LAYER ===
@riverpod
GameRepository gameRepository(Ref ref) {
  final storageService = ref.read(storageServiceProvider);
  final repository = DriftGameRepository(storageService);
  ref.onDispose(() => repository.dispose());
  return repository;
}

// === STREAMING PROVIDERS ===
@riverpod
Stream<List<GameItem>> gamesStream(Ref ref) {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.watchGames();
}

@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() {
    final gamesAsync = ref.watch(gamesStreamProvider);
    return gamesAsync.when(
      data: (games) => games,
      loading: () => [],
      error: (error, stack) => [],
    );
  }

  Future<void> addGame(GameItem game) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.createGame(game);
  }

  Future<void> updateGame(GameItem updatedGame) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.updateGame(updatedGame);
  }

  Future<void> removeGame(GameId gameId) async {
    final repository = ref.read(gameRepositoryProvider);
    await repository.deleteGame(gameId);
  }

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
@riverpod
List<GameItem> gamesByStatus(Ref ref, GameStatus status) {
  final games = ref.watch(gameListProvider);
  final filteredGames = games.where((game) => game.status == status).toList();

  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

@riverpod
List<GameItem> gamesByPlatform(Ref ref, String platform) {
  final games = ref.watch(gameListProvider);
  final filteredGames =
      platform == 'All'
          ? games.toList()
          : games.where((game) => game.platform == platform).toList();

  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

@riverpod
List<String> availablePlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final platforms = games.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}

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

  filteredGames.sort(
    (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
  );

  return filteredGames;
}

bool _matchesSearchQuery(GameItem game, String searchQuery) {
  final query = searchQuery.toLowerCase().trim();
  final title = game.title.toLowerCase();
  final platform = game.platform.toLowerCase();

  if (query.isEmpty) return true;

  return title.contains(query) || platform.contains(query);
}

// === BACKLOG SPECIFIC PROVIDERS ===
@riverpod
Map<String, List<GameItem>> sortedBacklogGamesByPlatform(Ref ref) {
  final games = ref.watch(gameListProvider);
  final selectedPlatform = ref.watch(selectedPlatformProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final sortType = ref.watch(backlogSortProvider);
  final sortDirection = ref.watch(backlogSortDirectionStateProvider);

  List<GameItem> backlogGames =
      games.where((game) => game.status == GameStatus.backlog).toList();

  if (selectedPlatform != 'All') {
    backlogGames =
        backlogGames
            .where((game) => game.platform == selectedPlatform)
            .toList();
  }

  if (searchQuery.isNotEmpty) {
    backlogGames =
        backlogGames.where((game) {
          return _matchesSearchQuery(game, searchQuery);
        }).toList();
  }

  final Map<String, List<GameItem>> groupedGames = {};
  for (final game in backlogGames) {
    if (!groupedGames.containsKey(game.platform)) {
      groupedGames[game.platform] = [];
    }
    groupedGames[game.platform]!.add(game);
  }

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

  final sortedMap = Map<String, List<GameItem>>.fromEntries(
    groupedGames.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );

  return sortedMap;
}

@riverpod
List<String> backlogPlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final backlogGames =
      games.where((game) => game.status == GameStatus.backlog).toList();
  final platforms = backlogGames.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}
