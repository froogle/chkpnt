import 'dart:async';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';

/// In-memory implementation of GameRepository
///
/// This serves as a reference implementation and will be used as the current
/// data source while we prepare for persistent storage integration.
class InMemoryGameRepository implements GameRepository {
  // Sample games data
  static final List<GameItem> _sampleGames = [
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

  final List<GameItem> _games = List.from(_sampleGames);
  final StreamController<List<GameItem>> _gamesController =
      StreamController<List<GameItem>>.broadcast();

  bool _isDisposed = false;

  InMemoryGameRepository();

  void _emitGamesUpdate() {
    if (!_isDisposed) {
      _gamesController.add(List.from(_games));
    }
  }

  @override
  Stream<List<GameItem>> watchGames() async* {
    // Immediately yield current data
    yield List.from(_games);

    // Then yield all future updates
    await for (final games in _gamesController.stream) {
      yield games;
    }
  }

  @override
  Future<List<GameItem>> getAllGames() async {
    await _simulateAsyncOperation();
    return List.from(_games);
  }

  @override
  Future<GameItem?> getGameById(GameId gameId) async {
    await _simulateAsyncOperation();
    try {
      return _games.firstWhere((game) => game.id == gameId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GameItem>> getGamesByStatus(GameStatus status) async {
    await _simulateAsyncOperation();
    return _games.where((game) => game.status == status).toList();
  }

  @override
  Future<List<GameItem>> getGamesByPlatform(String platform) async {
    await _simulateAsyncOperation();
    if (platform == 'All') return List.from(_games);
    return _games.where((game) => game.platform == platform).toList();
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    await _simulateAsyncOperation();

    // Check if game already exists
    final exists = _games.any((existingGame) => existingGame.id == game.id);
    if (exists) {
      throw GameAlreadyExistsException(game.id);
    }

    // Add timestamps if not present
    final gameWithTimestamps = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    );

    _games.add(gameWithTimestamps);
    _emitGamesUpdate();

    return gameWithTimestamps;
  }

  @override
  Future<GameItem> updateGame(GameItem game) async {
    await _simulateAsyncOperation();

    final index = _games.indexWhere(
      (existingGame) => existingGame.id == game.id,
    );
    if (index == -1) {
      throw GameNotFoundException(game.id);
    }

    final existingGame = _games[index];

    // Update timestamps appropriately
    final updatedGame = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange:
          existingGame.status != game.status
              ? DateTime.now()
              : existingGame.lastStatusChange,
    );

    _games[index] = updatedGame;
    _emitGamesUpdate();

    return updatedGame;
  }

  @override
  Future<void> deleteGame(GameId gameId) async {
    await _simulateAsyncOperation();

    final initialLength = _games.length;
    _games.removeWhere((game) => game.id == gameId);

    if (_games.length == initialLength) {
      throw GameNotFoundException(gameId);
    }

    _emitGamesUpdate();
  }

  @override
  Future<List<GameItem>> searchGames(String query) async {
    await _simulateAsyncOperation();

    if (query.isEmpty) return List.from(_games);

    final lowerQuery = query.toLowerCase();
    return _games.where((game) {
      return game.title.toLowerCase().contains(lowerQuery) ||
          game.platform.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<List<String>> getDistinctPlatforms() async {
    await _simulateAsyncOperation();

    final platforms = _games.map((game) => game.platform).toSet().toList();
    platforms.sort();
    return ['All', ...platforms];
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    await _gamesController.close();
  }

  /// Simulate async database operation with small delay
  Future<void> _simulateAsyncOperation() async {
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
