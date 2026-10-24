import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../test_helpers.dart';

String _backupJsonWithStatus(int status) {
  final now = DateTime(2024, 1, 1, 12).toIso8601String();
  return jsonEncode({
    'version': 6,
    'exportDate': now,
    'games': [
      {
        'id': 'unknown-status-game',
        'title': 'Unknown Status Game',
        'platform': 'PS5',
        'status': status,
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
    tempDir = Directory.systemTemp.createTempSync('owned_status_test_');
    PathProviderPlatform.instance = TempPathProviderPlatform(tempDir.path);
    repository = DriftGameRepository(StorageService(), MockGameImageService());
  });

  tearDown(() async {
    await repository.dispose();
    tempDir.deleteSync(recursive: true);
  });

  group('DriftGameRepository owned status', () {
    test('persists and reads back a physical owned game', () async {
      final game = GameItem.create(
        title: 'Boxed Owned Game',
        platform: 'PS5',
        status: GameStatus.owned,
        isPhysical: true,
      );

      await repository.createGame(game);
      final stored = await repository.getGameById(game.id);

      expect(stored, isNotNull);
      expect(stored!.status, GameStatus.owned);
      expect(stored.isPhysical, true);
    });

    test('persists and reads back a digital owned game', () async {
      final game = GameItem.create(
        title: 'Digital Owned Game',
        platform: 'PC',
        status: GameStatus.owned,
      );

      await repository.createGame(game);
      final stored = await repository.getGameById(game.id);

      expect(stored, isNotNull);
      expect(stored!.status, GameStatus.owned);
      expect(stored.isPhysical, false);
    });

    test('round trips an owned game through backup and restore', () async {
      final game = GameItem.create(
        title: 'Backed Up Owned Game',
        platform: 'Switch',
        status: GameStatus.owned,
        isPhysical: true,
      );
      await repository.createGame(game);

      final backupJson = await repository.exportDatabaseToJson();
      final exported = jsonDecode(backupJson) as Map<String, dynamic>;
      expect((exported['games'] as List).first['status'], 7);

      await repository.importFromJson(backupJson);
      final restored = await repository.getAllGames();

      expect(restored.length, 1);
      expect(restored.first.title, 'Backed Up Owned Game');
      expect(restored.first.status, GameStatus.owned);
    });

    test('restores an out of range status of 99 as owned', () async {
      await repository.importFromJson(_backupJsonWithStatus(99));

      final restored = await repository.getAllGames();

      expect(restored.length, 1);
      expect(restored.first.status, GameStatus.owned);
    });

    test('restores a negative status of -1 as owned', () async {
      await repository.importFromJson(_backupJsonWithStatus(-1));

      final restored = await repository.getAllGames();

      expect(restored.length, 1);
      expect(restored.first.status, GameStatus.owned);
    });

    test('restoring an unknown status does not throw', () async {
      await expectLater(
        repository.importFromJson(_backupJsonWithStatus(99)),
        completes,
      );
      await expectLater(
        repository.importFromJson(_backupJsonWithStatus(-1)),
        completes,
      );
    });
  });
}
