import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../test_helpers.dart';

String _backupJsonWithoutBarcodeKey() {
  final now = DateTime(2024, 1, 1, 12).toIso8601String();
  return jsonEncode({
    'version': 6,
    'exportDate': now,
    'games': [
      {
        'id': 'legacy-game',
        'title': 'Legacy Game',
        'platform': 'PS5',
        'status': GameStatus.backlog.index,
        'lastModified': now,
        'lastStatusChange': now,
        'imagePath': null,
        'remoteImageUrl': null,
        'isPhysical': true,
      },
    ],
    'guides': <Map<String, dynamic>>[],
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late DriftGameRepository repository;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('barcode_repository_test_');
    PathProviderPlatform.instance = TempPathProviderPlatform(tempDir.path);
    repository = DriftGameRepository(StorageService(), MockGameImageService());
  });

  tearDown(() async {
    await repository.dispose();
    tempDir.deleteSync(recursive: true);
  });

  group('DriftGameRepository barcode persistence', () {
    test('round trips a stored barcode', () async {
      final game = GameItem.create(
        title: 'Scanned Game',
        platform: 'PS3',
        status: GameStatus.owned,
        isPhysical: true,
        barcode: '711719127451',
      );

      await repository.createGame(game);
      final stored = await repository.getGameById(game.id);

      expect(stored, isNotNull);
      expect(stored!.barcode, '711719127451');
    });

    test('round trips a null barcode', () async {
      final game = GameItem.create(
        title: 'Unscanned Game',
        platform: 'PC',
        status: GameStatus.backlog,
      );

      await repository.createGame(game);
      final stored = await repository.getGameById(game.id);

      expect(stored, isNotNull);
      expect(stored!.barcode, isNull);
    });

    test('updates a game to carry a barcode', () async {
      final game = GameItem.create(
        title: 'Later Scanned Game',
        platform: 'PS5',
        status: GameStatus.owned,
      );
      await repository.createGame(game);

      await repository.updateGame(game.copyWith(barcode: '5026555248082'));
      final stored = await repository.getGameById(game.id);

      expect(stored!.barcode, '5026555248082');
    });
  });

  group('DriftGameRepository barcode backups', () {
    test('exports and restores the barcode', () async {
      final game = GameItem.create(
        title: 'Backed Up Scan',
        platform: 'Switch',
        status: GameStatus.owned,
        isPhysical: true,
        barcode: '4012927064528',
      );
      await repository.createGame(game);

      final backupJson = await repository.exportDatabaseToJson();
      final exported = jsonDecode(backupJson) as Map<String, dynamic>;
      expect((exported['games'] as List).first['barcode'], '4012927064528');

      await repository.importFromJson(backupJson);
      final restored = await repository.getAllGames();

      expect(restored.length, 1);
      expect(restored.first.barcode, '4012927064528');
    });

    test('exports a null barcode for games that were never scanned', () async {
      await repository.createGame(
        GameItem.create(
          title: 'No Barcode',
          platform: 'PC',
          status: GameStatus.backlog,
        ),
      );

      final exported =
          jsonDecode(await repository.exportDatabaseToJson())
              as Map<String, dynamic>;

      expect((exported['games'] as List).first.containsKey('barcode'), isTrue);
      expect((exported['games'] as List).first['barcode'], isNull);
    });

    test('imports a backup that has no barcode key', () async {
      await repository.importFromJson(_backupJsonWithoutBarcodeKey());

      final restored = await repository.getAllGames();

      expect(restored.length, 1);
      expect(restored.first.title, 'Legacy Game');
      expect(restored.first.isPhysical, isTrue);
      expect(restored.first.barcode, isNull);
    });
  });

  group('DriftGameRepository schema 6 to 7 migration', () {
    test('preserves existing games and leaves barcode null', () async {
      await repository.createGame(
        GameItem.create(
          title: 'Pre Migration Game',
          platform: 'PS4',
          status: GameStatus.playing,
          isPhysical: true,
        ),
      );
      await repository.dispose();

      final legacyDatabase = GameDatabase(StorageService());
      await legacyDatabase.customStatement(
        'ALTER TABLE games DROP COLUMN barcode',
      );
      await legacyDatabase.customStatement('PRAGMA user_version = 6');
      await legacyDatabase.close();

      repository = DriftGameRepository(
        StorageService(),
        MockGameImageService(),
      );
      final migrated = await repository.getAllGames();

      expect(migrated.length, 1);
      expect(migrated.first.title, 'Pre Migration Game');
      expect(migrated.first.platform, 'PS4');
      expect(migrated.first.status, GameStatus.playing);
      expect(migrated.first.isPhysical, isTrue);
      expect(migrated.first.barcode, isNull);
    });

    test('stores a barcode after the migration has run', () async {
      await repository.createGame(
        GameItem.create(
          title: 'Pre Migration Game',
          platform: 'PS4',
          status: GameStatus.playing,
        ),
      );
      await repository.dispose();

      final legacyDatabase = GameDatabase(StorageService());
      await legacyDatabase.customStatement(
        'ALTER TABLE games DROP COLUMN barcode',
      );
      await legacyDatabase.customStatement('PRAGMA user_version = 6');
      await legacyDatabase.close();

      repository = DriftGameRepository(
        StorageService(),
        MockGameImageService(),
      );
      final scanned = GameItem.create(
        title: 'Post Migration Scan',
        platform: 'PS4',
        status: GameStatus.owned,
        barcode: '5055277016211',
      );
      await repository.createGame(scanned);

      final stored = await repository.getGameById(scanned.id);
      expect(stored!.barcode, '5055277016211');
    });
  });
}
