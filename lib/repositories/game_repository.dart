import 'dart:async';
import 'package:chkpnt/models/game_models.dart';

/// Abstract repository interface for game data persistence
///
/// This interface defines the contract for game data operations.
/// Implementations can use different storage backends (SQLite, Hive, Firebase, etc.)
abstract class GameRepository {
  /// Stream of all games that automatically updates when data changes
  Stream<List<GameItem>> watchGames();

  /// Get all games as a one-time fetch
  Future<List<GameItem>> getAllGames();

  /// Get a specific game by ID
  Future<GameItem?> getGameById(GameId gameId);

  /// Get games filtered by status
  Future<List<GameItem>> getGamesByStatus(GameStatus status);

  /// Get games filtered by platform
  Future<List<GameItem>> getGamesByPlatform(String platform);

  /// Create a new game
  Future<GameItem> createGame(GameItem game);

  /// Update an existing game
  Future<GameItem> updateGame(GameItem game);

  /// Delete a game
  Future<void> deleteGame(GameId gameId);

  /// Search games by title or platform
  Future<List<GameItem>> searchGames(String query);

  /// Get distinct platforms from all games
  Future<List<String>> getDistinctPlatforms();

  /// Close/dispose the repository
  Future<void> dispose();
}

/// Repository exceptions for error handling
class RepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const RepositoryException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'RepositoryException: $message';
}

/// Specific repository exceptions
class GameNotFoundException extends RepositoryException {
  GameNotFoundException(GameId gameId)
    : super('Game not found: ${gameId.value}', code: 'GAME_NOT_FOUND');
}

class GameAlreadyExistsException extends RepositoryException {
  GameAlreadyExistsException(GameId gameId)
    : super('Game already exists: ${gameId.value}', code: 'GAME_EXISTS');
}

class StorageException extends RepositoryException {
  const StorageException(super.message, {super.originalError})
    : super(code: 'STORAGE_ERROR');
}
