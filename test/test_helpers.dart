import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'dart:async';
import 'dart:convert';

/// Test utilities for streaming provider tests
class TestHelpers {
  /// Sample games data for testing
  static final List<GameItem> sampleGames = [
    GameItem(
      id: GameId.generate(),
      title: 'The Legend of Zelda: Breath of the Wild',
      platform: 'Switch',
      status: GameStatus.playing,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
    GameItem(
      id: GameId.generate(),
      title: 'God of War',
      platform: 'PS5',
      status: GameStatus.playing,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
    GameItem(
      id: GameId.generate(),
      title: 'Cyberpunk 2077',
      platform: 'PC',
      status: GameStatus.completed,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
    GameItem(
      id: GameId.generate(),
      title: 'Red Dead Redemption 2',
      platform: 'Xbox',
      status: GameStatus.completed,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
    GameItem(
      id: GameId.generate(),
      title: 'Elden Ring',
      platform: 'Steam Deck',
      status: GameStatus.backlog,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
    GameItem(
      id: GameId.generate(),
      title: 'Mass Effect Legendary Edition',
      platform: 'PC',
      status: GameStatus.abandoned,
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    ),
  ];

  /// Create a test container with overrides for synchronous testing
  static ProviderContainer createTestContainer() {
    return ProviderContainer(
      overrides: [
        // Override the gameListProvider directly to provide immediate data
        gameListProvider.overrideWith(() => TestGameListNotifier()),
      ],
    );
  }

  /// Creates a basic test game with default values
  static GameItem createTestGame({
    String title = 'Test Game',
    String platform = 'PC',
    GameStatus status = GameStatus.backlog,
    String? imagePath,
    String? remoteImageUrl,
  }) {
    return GameItem.create(
      title: title,
      platform: platform,
      status: status,
      imagePath: imagePath,
      remoteImageUrl: remoteImageUrl,
    );
  }

  /// Creates a backlog game with specified platform
  static GameItem createBacklogGame({
    String title = 'Backlog Game',
    String platform = 'PC',
  }) {
    return createTestGame(
      title: title,
      platform: platform,
      status: GameStatus.backlog,
    );
  }

  /// Creates a playing game with specified platform
  static GameItem createPlayingGame({
    String title = 'Playing Game',
    String platform = 'PC',
  }) {
    return createTestGame(
      title: title,
      platform: platform,
      status: GameStatus.playing,
    );
  }

  /// Creates a completed game with specified platform
  static GameItem createCompletedGame({
    String title = 'Completed Game',
    String platform = 'PC',
  }) {
    return createTestGame(
      title: title,
      platform: platform,
      status: GameStatus.completed,
    );
  }

  /// Creates an abandoned game with specified platform
  static GameItem createAbandonedGame({
    String title = 'Abandoned Game',
    String platform = 'PC',
  }) {
    return createTestGame(
      title: title,
      platform: platform,
      status: GameStatus.abandoned,
    );
  }

  /// Creates games for search testing with specific search-friendly titles
  static List<GameItem> createSearchTestGames() {
    return [
      createTestGame(
        title: 'Cyberpunk 2077',
        platform: 'PC',
        status: GameStatus.completed,
      ),
      createTestGame(
        title: 'Cyberpunk Red',
        platform: 'PS5',
        status: GameStatus.playing,
      ),
      createTestGame(
        title: 'The Witcher 3',
        platform: 'PC',
        status: GameStatus.backlog,
      ),
    ];
  }

  /// Adds a list of games to the container's game provider
  static void addGamesToContainer(
    ProviderContainer container,
    List<GameItem> games,
  ) {
    final notifier = container.read(gameListProvider.notifier);
    for (final game in games) {
      notifier.addGame(game);
    }
  }

  /// Helper function to wait for games to load from the stream
  static Future<List<GameItem>> waitForGames(
    ProviderContainer container,
  ) async {
    // First trigger the provider to start listening
    container.read(gameListProvider);

    // Wait for the stream to emit data
    var attempts = 0;
    const maxAttempts = 50; // 5 seconds max wait

    while (attempts < maxAttempts) {
      final games = container.read(gameListProvider);
      if (games.isNotEmpty) {
        return games;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    // Return current state as fallback
    return container.read(gameListProvider);
  }

  /// Helper function to wait for a specific number of games
  static Future<List<GameItem>> waitForGameCount(
    ProviderContainer container,
    int expectedCount,
  ) async {
    var attempts = 0;
    const maxAttempts = 50; // 5 seconds max wait

    while (attempts < maxAttempts) {
      final games = container.read(gameListProvider);
      if (games.length >= expectedCount) {
        return games;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    // Return whatever we have
    return container.read(gameListProvider);
  }

  /// Helper function to wait for async operations to complete
  static Future<void> waitForAsyncOperation() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

/// Empty test notifier that provides no data (for testing empty states)
class EmptyGameListNotifier extends GameList {
  @override
  List<GameItem> build() {
    return [];
  }

  @override
  Future<void> addGame(GameItem game) async {
    // Empty implementation for testing
  }

  Future<void> createGame({
    required String title,
    required String platform,
    required GameStatus status,
    String? imagePath,
    String? remoteImageUrl,
  }) async {
    // Empty implementation for testing
  }

  @override
  Future<void> updateGame(GameItem updatedGame) async {
    // Empty implementation for testing
  }

  @override
  Future<void> removeGame(GameId gameId) async {
    // Empty implementation for testing
  }

  @override
  Future<void> startPlaying(GameId gameId) async {
    // Empty implementation for testing
  }

  @override
  Future<void> markCompleted(GameId gameId) async {
    // Empty implementation for testing
  }
}

/// Isolated test notifier that starts empty and allows adding games for isolated testing
class IsolatedTestGameListNotifier extends GameList {
  final List<GameItem> _games = [];

  @override
  List<GameItem> build() {
    return List.from(_games);
  }

  @override
  Future<void> addGame(GameItem game) async {
    _games.add(game);
    ref.invalidateSelf();
  }

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

  @override
  Future<void> updateGame(GameItem updatedGame) async {
    final index = _games.indexWhere((g) => g.id == updatedGame.id);
    if (index != -1) {
      final existingGame = _games[index];

      // Update timestamps appropriately - preserve lastStatusChange if status didn't change
      final gameWithTimestamps = updatedGame.copyWith(
        lastModified: DateTime.now(),
        lastStatusChange:
            existingGame.status != updatedGame.status
                ? DateTime.now()
                : existingGame.lastStatusChange,
      );

      _games[index] = gameWithTimestamps;
      ref.invalidateSelf();
    }
  }

  @override
  Future<void> removeGame(GameId gameId) async {
    _games.removeWhere((g) => g.id == gameId);
    ref.invalidateSelf();
  }

  @override
  Future<void> startPlaying(GameId gameId) async {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        status: GameStatus.playing,
        lastStatusChange: DateTime.now(),
        lastModified: DateTime.now(),
      );
      ref.invalidateSelf();
    }
  }

  @override
  Future<void> markCompleted(GameId gameId) async {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        status: GameStatus.completed,
        lastStatusChange: DateTime.now(),
        lastModified: DateTime.now(),
      );
      ref.invalidateSelf();
    }
  }
}

/// Test notifier that provides immediate synchronous data
class TestGameListNotifier extends GameList {
  static final List<GameItem> _staticGames = List.from(TestHelpers.sampleGames);

  List<GameItem> get _games => _staticGames;

  @override
  List<GameItem> build() {
    return List.from(_games);
  }

  @override
  Future<void> addGame(GameItem game) async {
    _games.add(game);
    ref.invalidateSelf();
  }

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

  @override
  Future<void> updateGame(GameItem updatedGame) async {
    final index = _games.indexWhere((g) => g.id == updatedGame.id);
    if (index != -1) {
      final existingGame = _games[index];

      // Update timestamps appropriately - preserve lastStatusChange if status didn't change
      final gameWithTimestamps = updatedGame.copyWith(
        lastModified: DateTime.now(),
        lastStatusChange:
            existingGame.status != updatedGame.status
                ? DateTime.now()
                : existingGame.lastStatusChange,
      );

      _games[index] = gameWithTimestamps;
      ref.invalidateSelf();
    }
  }

  @override
  Future<void> removeGame(GameId gameId) async {
    _games.removeWhere((g) => g.id == gameId);
    ref.invalidateSelf();
  }

  @override
  Future<void> startPlaying(GameId gameId) async {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        status: GameStatus.playing,
        lastStatusChange: DateTime.now(),
        lastModified: DateTime.now(),
      );
      ref.invalidateSelf();
    }
  }

  @override
  Future<void> markCompleted(GameId gameId) async {
    final index = _games.indexWhere((g) => g.id == gameId);
    if (index != -1) {
      _games[index] = _games[index].copyWith(
        status: GameStatus.completed,
        lastStatusChange: DateTime.now(),
        lastModified: DateTime.now(),
      );
      ref.invalidateSelf();
    }
  }
}

/// Test repository that provides immediate synchronous data
class TestGameRepository implements GameRepository {
  final List<GameItem> _games = List.from(TestHelpers.sampleGames);
  final StreamController<List<GameItem>> _controller =
      StreamController<List<GameItem>>.broadcast();

  TestGameRepository() {
    // Emit initial data immediately
    Future.microtask(() => _controller.add(List.from(_games)));
  }

  @override
  Stream<List<GameItem>> watchGames() async* {
    // Immediately yield current data
    yield List.from(_games);

    // Then yield all future updates
    await for (final games in _controller.stream) {
      yield games;
    }
  }

  @override
  Future<List<GameItem>> getAllGames() async {
    return List.from(_games);
  }

  @override
  Future<GameItem?> getGameById(GameId gameId) async {
    try {
      return _games.firstWhere((game) => game.id == gameId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    final gameWithTimestamps = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    );
    _games.add(gameWithTimestamps);
    _controller.add(List.from(_games));
    return gameWithTimestamps;
  }

  @override
  Future<GameItem> updateGame(GameItem game) async {
    final index = _games.indexWhere(
      (existingGame) => existingGame.id == game.id,
    );
    if (index == -1) {
      throw GameNotFoundException(game.id);
    }

    final existingGame = _games[index];
    final updatedGame = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange:
          existingGame.status != game.status
              ? DateTime.now()
              : existingGame.lastStatusChange,
    );

    _games[index] = updatedGame;
    _controller.add(List.from(_games));
    return updatedGame;
  }

  @override
  Future<void> deleteGame(GameId gameId) async {
    final initialLength = _games.length;
    _games.removeWhere((game) => game.id == gameId);

    if (_games.length == initialLength) {
      throw GameNotFoundException(gameId);
    }

    _controller.add(List.from(_games));
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  Future<String> exportDatabaseToJson() async {
    final jsonData =
        _games
            .map(
              (game) => {
                'id': game.id.value,
                'title': game.title,
                'platform': game.platform,
                'status': game.status.index,
                'lastModified': game.lastModified.toIso8601String(),
                'lastStatusChange': game.lastStatusChange.toIso8601String(),
                'imagePath': game.imagePath,
                'remoteImageUrl': game.remoteImageUrl,
              },
            )
            .toList();

    return jsonEncode({
      'version': 1,
      'exportDate': DateTime.now().toIso8601String(),
      'games': jsonData,
    });
  }

  @override
  Future<void> importFromJson(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final games =
        (data['games'] as List).map((gameData) {
          return GameItem(
            id: GameId(gameData['id']),
            title: gameData['title'],
            platform: gameData['platform'],
            status: GameStatus.values[gameData['status']],
            lastModified: DateTime.parse(gameData['lastModified']),
            lastStatusChange: DateTime.parse(gameData['lastStatusChange']),
            imagePath: gameData['imagePath'],
            remoteImageUrl: gameData['remoteImageUrl'],
          );
        }).toList();

    _games.clear();
    _games.addAll(games);
    _controller.add(List.from(_games));
  }

  @override
  Future<String?> getDatabasePath() async {
    // Test repository doesn't have a physical file
    return null;
  }
}
