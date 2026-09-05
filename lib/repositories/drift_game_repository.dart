import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/repositories/guide_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';

part 'drift_game_repository.g.dart';

/// Drift table definition that mirrors the GameItem model exactly
class Games extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get platform => text()();
  IntColumn get status => integer()();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get lastStatusChange => dateTime()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get remoteImageUrl => text().nullable()();
  BoolColumn get isPhysical => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Guides extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get fileName => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get lastReadSection => integer().withDefault(const Constant(0))();
  IntColumn get lastReadBlock => integer().withDefault(const Constant(0))();
  TextColumn get sourceUrl => text().nullable()();
  BoolColumn get hasSeenAttribution => boolean().withDefault(const Constant(false))();
  IntColumn get format => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Games, Guides])
class GameDatabase extends _$GameDatabase {
  GameDatabase(StorageService storageService)
    : super(_openConnection(storageService)) {
    // Suppress multiple database warnings in tests
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 6;

  Future<void> ensureInitialized() async {
    await customSelect('SELECT 1').get();
  }

  Future<bool> _columnExists(String tableName, String columnName) async {
    final result = await customSelect(
      "PRAGMA table_info($tableName)",
    ).get();
    return result.any((row) => row.data['name'] == columnName);
  }

  Future<bool> _tableExists(String tableName) async {
    final result = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      variables: [Variable.withString(tableName)],
    ).get();
    return result.isNotEmpty;
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        if (!await _columnExists('games', 'is_physical')) {
          await m.addColumn(games, games.isPhysical);
        }
      }
      if (from < 3) {
        if (!await _tableExists('guides')) {
          await m.createTable(guides);
        }
      }
      if (from < 4) {
        if (!await _columnExists('guides', 'source_url')) {
          await m.addColumn(guides, guides.sourceUrl);
        }
      }
      if (from < 5) {
        if (!await _columnExists('guides', 'has_seen_attribution')) {
          await m.addColumn(guides, guides.hasSeenAttribution);
        }
      }
      if (from < 6) {
        if (!await _columnExists('guides', 'format')) {
          await m.addColumn(guides, guides.format);
        }
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');

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
      status: _statusFromIndex(game.status),
      lastModified: game.lastModified,
      lastStatusChange: game.lastStatusChange,
      imagePath: game.imagePath,
      remoteImageUrl: game.remoteImageUrl,
      isPhysical: game.isPhysical,
    );
  }

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
      isPhysical: Value(gameItem.isPhysical),
    );
  }

  GuideItem _guideToGuideItem(Guide guide) {
    return GuideItem(
      id: GuideId(guide.id),
      gameId: GameId(guide.gameId),
      title: guide.title,
      author: guide.author,
      fileName: guide.fileName,
      createdAt: guide.createdAt,
      lastReadSection: guide.lastReadSection,
      lastReadBlock: guide.lastReadBlock,
      sourceUrl: guide.sourceUrl,
      hasSeenAttribution: guide.hasSeenAttribution,
      format: GuideFormat.values[guide.format],
    );
  }

  GuidesCompanion _guideItemToCompanion(GuideItem guideItem) {
    return GuidesCompanion(
      id: Value(guideItem.id.value),
      gameId: Value(guideItem.gameId.value),
      title: Value(guideItem.title),
      author: Value(guideItem.author),
      fileName: Value(guideItem.fileName),
      createdAt: Value(guideItem.createdAt),
      lastReadSection: Value(guideItem.lastReadSection),
      lastReadBlock: Value(guideItem.lastReadBlock),
      sourceUrl: Value(guideItem.sourceUrl),
      hasSeenAttribution: Value(guideItem.hasSeenAttribution),
      format: Value(guideItem.format.index),
    );
  }

  // Game database operations
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
    await (delete(guides)..where((t) => t.gameId.equals(gameId))).go();
    await (delete(games)..where((t) => t.id.equals(gameId))).go();
  }

  // Guide database operations
  Future<List<GuideItem>> getGuidesForGameInternal(String gameId) async {
    final query = select(guides)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    final results = await query.get();
    return results.map(_guideToGuideItem).toList();
  }

  Stream<List<GuideItem>> watchGuidesForGame(String gameId) {
    final query = select(guides)
      ..where((t) => t.gameId.equals(gameId))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]);
    return query.watch().map((guides) => guides.map(_guideToGuideItem).toList());
  }

  Future<List<GuideItem>> getAllGuidesInternal() async {
    final query = select(guides)..orderBy([
      (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
    ]);
    final results = await query.get();
    return results.map(_guideToGuideItem).toList();
  }

  Future<GuideItem?> getGuideByIdInternal(String guideId) async {
    final query = select(guides)..where((t) => t.id.equals(guideId));
    final result = await query.getSingleOrNull();
    return result != null ? _guideToGuideItem(result) : null;
  }

  Future<GuideItem> insertGuide(GuideItem guideItem) async {
    await into(guides).insert(_guideItemToCompanion(guideItem));
    return guideItem;
  }

  Future<GuideItem> updateGuideInternal(GuideItem guideItem) async {
    final companion = _guideItemToCompanion(guideItem);
    await update(guides).replace(companion);
    return guideItem;
  }

  Future<void> deleteGuideInternal(String guideId) async {
    await (delete(guides)..where((t) => t.id.equals(guideId))).go();
  }
}

/// Drift repository implementation
class DriftGameRepository implements GameRepository {
  final GameDatabase _database;
  final GameImageService _imageService;
  late final StreamController<List<GameItem>> _gamesController;

  DriftGameRepository(StorageService storageService, this._imageService)
    : _database = GameDatabase(storageService) {
    _gamesController = StreamController<List<GameItem>>.broadcast();
  }

  GameDatabase get database => _database;

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

      // Clean up old image if imagePath has changed
      if (existing.imagePath != null && 
          existing.imagePath != game.imagePath &&
          existing.imagePath!.isNotEmpty) {
        try {
          await _imageService.deleteImage(existing.imagePath!);
        } catch (e) {
          // Log but don't fail the update if image deletion fails
          // The old image might have already been deleted or moved
          debugPrint('Warning: Failed to delete old image ${existing.imagePath}: $e');
        }
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
  Future<void> dispose() async {
    await _gamesController.close();
    await _database.close();
  }

  @override
  Future<String> exportDatabaseToJson() async {
    try {
      final games = await getAllGames();
      final guides = await _database.getAllGuidesInternal();

      final gamesJsonData = games.map((game) => {
        'id': game.id.value,
        'title': game.title,
        'platform': game.platform,
        'status': game.status.index,
        'lastModified': game.lastModified.toIso8601String(),
        'lastStatusChange': game.lastStatusChange.toIso8601String(),
        'imagePath': game.imagePath,
        'remoteImageUrl': game.remoteImageUrl,
        'isPhysical': game.isPhysical,
      }).toList();

      final guidesJsonData = guides.map((guide) => {
        'id': guide.id.value,
        'gameId': guide.gameId.value,
        'title': guide.title,
        'author': guide.author,
        'fileName': guide.fileName,
        'createdAt': guide.createdAt.toIso8601String(),
        'lastReadSection': guide.lastReadSection,
        'lastReadBlock': guide.lastReadBlock,
        'sourceUrl': guide.sourceUrl,
        'hasSeenAttribution': guide.hasSeenAttribution,
        'format': guide.format.index,
      }).toList();

      return jsonEncode({
        'version': 6,
        'exportDate': DateTime.now().toIso8601String(),
        'games': gamesJsonData,
        'guides': guidesJsonData,
      });
    } catch (e) {
      throw StorageException('Failed to export database', originalError: e);
    }
  }

  @override
  Future<void> importFromJson(String jsonString) async {
    try {
      await _database.ensureInitialized();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final games = (data['games'] as List).map((gameData) {
        return GameItem(
          id: GameId(gameData['id']),
          title: gameData['title'],
          platform: gameData['platform'],
          status: _statusFromIndex(gameData['status']),
          lastModified: DateTime.parse(gameData['lastModified']),
          lastStatusChange: DateTime.parse(gameData['lastStatusChange']),
          imagePath: gameData['imagePath'],
          remoteImageUrl: gameData['remoteImageUrl'],
          isPhysical: gameData['isPhysical'] ?? false,
        );
      }).toList();

      final guidesData = data['guides'] as List? ?? [];
      final guides = guidesData.map((guideData) {
        return GuideItem(
          id: GuideId(guideData['id']),
          gameId: GameId(guideData['gameId']),
          title: guideData['title'],
          author: guideData['author'],
          fileName: guideData['fileName'],
          createdAt: DateTime.parse(guideData['createdAt']),
          lastReadSection: guideData['lastReadSection'] ?? 0,
          lastReadBlock: guideData['lastReadBlock'] ?? 0,
          sourceUrl: guideData['sourceUrl'] as String?,
          hasSeenAttribution: guideData['hasSeenAttribution'] as bool? ?? false,
          format: GuideFormat.values[guideData['format'] as int? ?? 0],
        );
      }).toList();

      await _database.transaction(() async {
        await _database.delete(_database.guides).go();
        await _database.delete(_database.games).go();
        for (final game in games) {
          await _database.insertGame(game);
        }
        for (final guide in guides) {
          await _database.insertGuide(guide);
        }
      });
    } catch (e) {
      throw StorageException('Failed to import database', originalError: e);
    }
  }

  /// Get database file path for manual backup
  @override
  Future<String> getDatabasePath() async {
    final storageService = StorageService(); // TODO: This should be injected
    final dbFolder = await storageService.getPersistentStorageDirectory();
    return p.join(dbFolder.path, 'chkpnt.db');
  }
}

GameStatus _statusFromIndex(int index) =>
    index >= 0 && index < GameStatus.values.length
        ? GameStatus.values[index]
        : GameStatus.owned;

LazyDatabase _openConnection(StorageService storageService) {
  return LazyDatabase(() async {
    final dbFolder = await storageService.getPersistentStorageDirectory();
    final file = File(p.join(dbFolder.path, 'chkpnt.db'));
    return NativeDatabase.createInBackground(file);
  });
}

class DriftGuideRepository implements GuideRepository {
  final GameDatabase _database;

  DriftGuideRepository(this._database);

  @override
  Stream<List<GuideItem>> watchGuidesForGame(GameId gameId) {
    return _database.watchGuidesForGame(gameId.value);
  }

  @override
  Future<List<GuideItem>> getGuidesForGame(GameId gameId) async {
    return await _database.getGuidesForGameInternal(gameId.value);
  }

  @override
  Future<List<GuideItem>> getAllGuides() async {
    return await _database.getAllGuidesInternal();
  }

  @override
  Future<GuideItem?> getGuideById(GuideId guideId) async {
    return await _database.getGuideByIdInternal(guideId.value);
  }

  @override
  Future<GuideItem> createGuide(GuideItem guide) async {
    return await _database.insertGuide(guide);
  }

  @override
  Future<GuideItem> updateGuideReadPosition(
    GuideId guideId,
    int section,
    int block,
  ) async {
    final existing = await getGuideById(guideId);
    if (existing == null) {
      throw GuideNotFoundException(guideId);
    }

    final updated = existing.copyWith(
      lastReadSection: section,
      lastReadBlock: block,
    );

    return await _database.updateGuideInternal(updated);
  }

  @override
  Future<GuideItem> markAttributionSeen(GuideId guideId) async {
    final existing = await getGuideById(guideId);
    if (existing == null) {
      throw GuideNotFoundException(guideId);
    }

    final updated = existing.copyWith(hasSeenAttribution: true);
    return await _database.updateGuideInternal(updated);
  }

  @override
  Future<void> deleteGuide(GuideId guideId) async {
    final existing = await getGuideById(guideId);
    if (existing == null) {
      throw GuideNotFoundException(guideId);
    }

    await _database.deleteGuideInternal(guideId.value);
  }
}
