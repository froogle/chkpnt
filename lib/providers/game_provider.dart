import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

part 'game_provider.g.dart';

// === REPOSITORY LAYER ===
@riverpod
GameRepository gameRepository(Ref ref) {
  final storageService = ref.read(storageServiceProvider);
  final imageService = ref.read(gameImageServiceProvider);
  final repository = DriftGameRepository(storageService, imageService);
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
    await _waitForGameInStream(repository, game.id);
  }

  Future<void> _waitForGameInStream(GameRepository repository, GameId gameId) async {
    final completer = Completer<void>();
    StreamSubscription<List<GameItem>>? subscription;

    subscription = repository.watchGames().listen((games) {
      if (games.any((g) => g.id == gameId)) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        subscription?.cancel();
      }
    });

    final timeout = Future.delayed(const Duration(milliseconds: 500), () {
      if (!completer.isCompleted) {
        completer.complete();
      }
      subscription?.cancel();
    });

    await Future.any([completer.future, timeout]);
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

const mainScreenStatuses = [
  GameStatus.playing,
  GameStatus.ongoing,
  GameStatus.backlog,
  GameStatus.completed,
  GameStatus.abandoned,
];

const wishlistScreenStatuses = [GameStatus.ordered, GameStatus.wishlist];

List<GameItem> _screenGames(Ref ref, GameScreen screen) {
  final games = ref.watch(gameListProvider);

  switch (screen) {
    case GameScreen.main:
      return games
          .where((game) => mainScreenStatuses.contains(game.status))
          .toList();
    case GameScreen.wishlist:
      return games
          .where((game) => wishlistScreenStatuses.contains(game.status))
          .toList();
    case GameScreen.backlog:
      final showBacklog = ref.watch(backlogShowBacklogFilterProvider);
      final showOngoing = ref.watch(backlogShowOngoingFilterProvider);
      return games
          .where(
            (game) =>
                (showBacklog && game.status == GameStatus.backlog) ||
                (showOngoing && game.status == GameStatus.ongoing),
          )
          .toList();
    case GameScreen.collection:
      final showPhysical = ref.watch(collectionShowPhysicalFilterProvider);
      final showDigital = ref.watch(collectionShowDigitalFilterProvider);
      return games
          .where(
            (game) =>
                !wishlistScreenStatuses.contains(game.status) &&
                (game.isPhysical ? showPhysical : showDigital),
          )
          .toList();
  }
}

List<GameItem> _matchingChoiceAndSearch(Ref ref, Iterable<GameItem> games) {
  final platform = ref.watch(selectedPlatformProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return games
      .where(
        (game) =>
            (platform == null || game.platform == platform) &&
            (game.title.toLowerCase().contains(query) ||
                game.platform.toLowerCase().contains(query)),
      )
      .toList();
}

List<String> _platformsOf(Iterable<GameItem> games) =>
    games.map((game) => game.platform).toSet().toList()..sort();

int _byTitle(GameItem a, GameItem b) =>
    a.title.toLowerCase().compareTo(b.title.toLowerCase());

int _byStatusChange(GameItem a, GameItem b) =>
    a.lastStatusChange.compareTo(b.lastStatusChange);

Comparator<GameItem> _sortFor(Ref ref, GameScreen screen) {
  if (screen != GameScreen.backlog) return _byTitle;

  final Comparator<GameItem> byKey = switch (ref.watch(backlogSortProvider)) {
    BacklogSortType.title => _byTitle,
    BacklogSortType.statusChange => _byStatusChange,
  };
  final direction = ref.watch(backlogSortDirectionStateProvider);

  return direction == SortDirection.ascending ? byKey : (a, b) => byKey(b, a);
}

@riverpod
List<String> screenPlatforms(Ref ref, GameScreen screen) {
  return _platformsOf(_screenGames(ref, screen));
}

@riverpod
List<String> everyPlatform(Ref ref) {
  return _platformsOf(ref.watch(gameListProvider));
}

@riverpod
List<GameItem> statusSectionGames(Ref ref, GameStatus status) {
  final games = ref
      .watch(gameListProvider)
      .where((game) => game.status == status);
  return _matchingChoiceAndSearch(ref, games)..sort(_byTitle);
}

@riverpod
Map<String, List<GameItem>> platformSections(Ref ref, GameScreen screen) {
  final games = _matchingChoiceAndSearch(ref, _screenGames(ref, screen))
    ..sort(_sortFor(ref, screen));

  return {
    for (final platform in _platformsOf(games))
      platform: games.where((game) => game.platform == platform).toList(),
  };
}
