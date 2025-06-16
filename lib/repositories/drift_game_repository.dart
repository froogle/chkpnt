import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';

part 'drift_game_repository.g.dart';

/// Drift table definition that mirrors the GameItem model exactly
class Games extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get platform => text()();
  IntColumn get status => integer()(); // Store GameStatus as int (0,1,2,3...)
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get lastStatusChange => dateTime()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get remoteImageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift database definition
@DriftDatabase(tables: [Games])
class GameDatabase extends _$GameDatabase {
  GameDatabase() : super(_openConnection()) {
    // Suppress multiple database warnings in tests
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle future schema migrations
      // if (from == 1 && to == 2) {
      //   await m.addColumn(games, games.newColumn);
      // }
    },
    beforeOpen: (details) async {
      // Ensure database integrity before opening
      await customStatement('PRAGMA foreign_keys = ON');

      // Verify database is not corrupted
      final result = await customSelect('PRAGMA integrity_check').get();
      if (result.isNotEmpty && result.first.data['integrity_check'] != 'ok') {
        throw Exception('Database corruption detected');
      }
    },
  );

  /// Convert Drift Game to GameItem model
  GameItem _gameToGameItem(Game game) {
    return GameItem(
      id: GameId(game.id),
      title: game.title,
      platform: game.platform,
      status: GameStatus.values[game.status],
      lastModified: game.lastModified,
      lastStatusChange: game.lastStatusChange,
      imagePath: game.imagePath,
      remoteImageUrl: game.remoteImageUrl,
    );
  }

  /// Convert GameItem model to Drift companion
  GamesCompanion _gameItemToCompanion(GameItem gameItem) {
    return GamesCompanion(
      id: Value(gameItem.id.value),
      title: Value(gameItem.title),
      platform: Value(gameItem.platform),
      status: Value(gameItem.status.index),
      lastModified: Value(gameItem.lastModified),
      lastStatusChange: Value(gameItem.lastStatusChange),
      imagePath: Value(gameItem.imagePath),
      remoteImageUrl: Value(gameItem.remoteImageUrl),
    );
  }

  // Database operations
  Future<List<GameItem>> getAllGamesInternal() async {
    final query = select(games)..orderBy([
      (t) => OrderingTerm(expression: t.lastModified, mode: OrderingMode.desc),
    ]);
    final results = await query.get();
    return results.map(_gameToGameItem).toList();
  }

  Stream<List<GameItem>> watchAllGames() {
    final query = select(games)..orderBy([
      (t) => OrderingTerm(expression: t.lastModified, mode: OrderingMode.desc),
    ]);
    return query.watch().map((games) => games.map(_gameToGameItem).toList());
  }

  Future<GameItem?> getGameByIdInternal(String gameId) async {
    final query = select(games)..where((t) => t.id.equals(gameId));
    final result = await query.getSingleOrNull();
    return result != null ? _gameToGameItem(result) : null;
  }

  Future<GameItem> insertGame(GameItem gameItem) async {
    await into(games).insert(_gameItemToCompanion(gameItem));
    return gameItem;
  }

  Future<GameItem> updateGameInternal(GameItem gameItem) async {
    final companion = _gameItemToCompanion(gameItem);
    await update(games).replace(companion);
    return gameItem;
  }

  Future<void> deleteGameInternal(String gameId) async {
    await (delete(games)..where((t) => t.id.equals(gameId))).go();
  }

  Future<List<GameItem>> searchGamesInternal(String query) async {
    if (query.isEmpty) return await getAllGamesInternal();

    final searchPattern = '%${query.toLowerCase()}%';
    final searchQuery = select(games)..where(
      (t) =>
          t.title.lower().like(searchPattern) |
          t.platform.lower().like(searchPattern),
    );
    final results = await searchQuery.get();
    return results.map(_gameToGameItem).toList();
  }

  Future<List<GameItem>> getGamesByStatusInternal(int statusIndex) async {
    final query = select(games)..where((t) => t.status.equals(statusIndex));
    final results = await query.get();
    return results.map(_gameToGameItem).toList();
  }

  Future<List<GameItem>> getGamesByPlatformInternal(String platform) async {
    final query = select(games)..where((t) => t.platform.equals(platform));
    final results = await query.get();
    return results.map(_gameToGameItem).toList();
  }

  Future<List<String>> getDistinctPlatformsInternal() async {
    final query = selectOnly(games, distinct: true)
      ..addColumns([games.platform]);
    final results = await query.get();
    final platforms =
        results.map((row) => row.read(games.platform)!).toList()..sort();
    return ['All', ...platforms];
  }
}

/// Drift repository implementation
class DriftGameRepository implements GameRepository {
  final GameDatabase _database;
  late final StreamController<List<GameItem>> _gamesController;

  DriftGameRepository() : _database = GameDatabase() {
    _gamesController = StreamController<List<GameItem>>.broadcast();
  }

  @override
  Stream<List<GameItem>> watchGames() {
    return _database.watchAllGames();
  }

  @override
  Future<List<GameItem>> getAllGames() async {
    try {
      return await _database.getAllGamesInternal();
    } catch (e) {
      throw StorageException('Failed to get all games', originalError: e);
    }
  }

  @override
  Future<GameItem?> getGameById(GameId gameId) async {
    try {
      return await _database.getGameByIdInternal(gameId.value);
    } catch (e) {
      throw StorageException('Failed to get game by ID', originalError: e);
    }
  }

  @override
  Future<List<GameItem>> getGamesByStatus(GameStatus status) async {
    try {
      return await _database.getGamesByStatusInternal(status.index);
    } catch (e) {
      throw StorageException('Failed to get games by status', originalError: e);
    }
  }

  @override
  Future<List<GameItem>> getGamesByPlatform(String platform) async {
    try {
      if (platform == 'All') return await getAllGames();
      return await _database.getGamesByPlatformInternal(platform);
    } catch (e) {
      throw StorageException(
        'Failed to get games by platform',
        originalError: e,
      );
    }
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    try {
      // Check if game already exists
      final existing = await getGameById(game.id);
      if (existing != null) {
        throw GameAlreadyExistsException(game.id);
      }

      // Add timestamps if not present
      final gameWithTimestamps = game.copyWith(
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );

      return await _database.insertGame(gameWithTimestamps);
    } catch (e) {
      if (e is GameAlreadyExistsException) rethrow;
      throw StorageException('Failed to create game', originalError: e);
    }
  }

  @override
  Future<GameItem> updateGame(GameItem game) async {
    try {
      // Check if game exists
      final existing = await getGameById(game.id);
      if (existing == null) {
        throw GameNotFoundException(game.id);
      }

      // Update timestamps appropriately
      final updatedGame = game.copyWith(
        lastModified: DateTime.now(),
        lastStatusChange:
            existing.status != game.status
                ? DateTime.now()
                : existing.lastStatusChange,
      );

      return await _database.updateGameInternal(updatedGame);
    } catch (e) {
      if (e is GameNotFoundException) rethrow;
      throw StorageException('Failed to update game', originalError: e);
    }
  }

  @override
  Future<void> deleteGame(GameId gameId) async {
    try {
      // Check if game exists
      final existing = await getGameById(gameId);
      if (existing == null) {
        throw GameNotFoundException(gameId);
      }

      await _database.deleteGameInternal(gameId.value);
    } catch (e) {
      if (e is GameNotFoundException) rethrow;
      throw StorageException('Failed to delete game', originalError: e);
    }
  }

  @override
  Future<List<GameItem>> searchGames(String query) async {
    try {
      if (query.isEmpty) return await getAllGames();
      return await _database.searchGamesInternal(query);
    } catch (e) {
      throw StorageException('Failed to search games', originalError: e);
    }
  }

  @override
  Future<List<String>> getDistinctPlatforms() async {
    try {
      return await _database.getDistinctPlatformsInternal();
    } catch (e) {
      throw StorageException(
        'Failed to get distinct platforms',
        originalError: e,
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _gamesController.close();
    await _database.close();
  }

  /// Backup functionality for data protection
  @override
  Future<String> exportDatabaseToJson() async {
    try {
      final games = await getAllGames();
      final jsonData =
          games
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
    } catch (e) {
      throw StorageException('Failed to export database', originalError: e);
    }
  }

  /// Import functionality for data restoration
  @override
  Future<void> importFromJson(String jsonString) async {
    try {
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

      // Clear existing data and import
      await _database.transaction(() async {
        await _database.delete(_database.games).go();
        for (final game in games) {
          await _database.insertGame(game);
        }
      });
    } catch (e) {
      throw StorageException('Failed to import database', originalError: e);
    }
  }

  /// Get database file path for manual backup
  @override
  Future<String> getDatabasePath() async {
    final dbFolder = await _getPersistentStorageDirectory();
    return p.join(dbFolder.path, 'chkpnt.db');
  }
}

/// Database connection setup with persistent storage locations
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await _getPersistentStorageDirectory();
    final file = File(p.join(dbFolder.path, 'chkpnt.db'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Get the most persistent storage directory for each platform using a hybrid approach
///
/// This hybrid strategy balances data persistence with Android 14+ compatibility:
/// - iOS/macOS: Uses Application Support Directory (persists across updates, backed up to iCloud)
/// - Android 14+: Uses Application Support Directory (avoids scoped storage permission issues)
/// - Android 13 and below: Uses External Storage with app subfolder (persists across dev rebuilds and uninstalls)
/// - Other platforms: Falls back to Application Support Directory
Future<Directory> _getPersistentStorageDirectory() async {
  try {
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS/macOS: Use Application Support Directory
      // This persists across app updates and is backed up to iCloud
      return await getApplicationSupportDirectory();
    } else if (Platform.isAndroid) {
      // Check Android version to determine storage strategy
      final isAndroid14OrLater = await _isAndroid14OrLater();

      if (isAndroid14OrLater) {
        // Android 14+: Use Application Support Directory to avoid scoped storage issues
        // Data persists through app updates but not development rebuilds
        return await getApplicationSupportDirectory();
      } else {
        // Android 13 and below: Use External Storage Directory for maximum persistence
        // This persists across app updates, uninstalls, and development rebuilds
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Create app-specific subdirectory
          final appDir = Directory('${externalDir.path}/ChkPnt');
          if (!await appDir.exists()) {
            await appDir.create(recursive: true);
          }
          return appDir;
        } else {
          // Fallback to Application Support Directory if external storage unavailable
          return await getApplicationSupportDirectory();
        }
      }
    } else {
      // Linux/Windows/Other: Use Application Support Directory
      return await getApplicationSupportDirectory();
    }
  } catch (e) {
    // Fallback to documents directory if all else fails
    return await getApplicationDocumentsDirectory();
  }
}

/// Check if the current Android version is 14 (API 34) or later
/// This helps determine the appropriate storage strategy
Future<bool> _isAndroid14OrLater() async {
  try {
    if (!Platform.isAndroid) return false;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('Device info timeout'),
    );

    // Android 14 is API level 34
    final sdkInt = androidInfo.version.sdkInt;
    return sdkInt >= 34;
  } catch (e) {
    // If we can't determine the version, assume it's a newer version for safety
    return true;
  }
}
