import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';

void main() {
  late Directory tempDir;
  late File databaseFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('reading_position_test_');
    databaseFile = File(p.join(tempDir.path, 'chkpnt.db'));
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('GameDatabase Reading Position migration', () {
    test('resets every Reading Position when upgrading from v7', () async {
      final game = GameItem.create(
        title: 'Guided Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );
      final guide = GuideItem.create(
        gameId: game.id,
        title: 'Walkthrough',
        author: 'Author',
        fileName: 'guide.json',
      ).copyWith(lastReadSection: 42, lastReadBlock: 3);

      final legacyDatabase = GameDatabase.withExecutor(
        NativeDatabase(databaseFile),
      );
      await legacyDatabase.insertGame(game);
      await legacyDatabase.insertGuide(guide);
      await legacyDatabase.customStatement('PRAGMA user_version = 7');
      await legacyDatabase.close();

      final database = GameDatabase.withExecutor(NativeDatabase(databaseFile));
      final migrated = await database.getGuideByIdInternal(guide.id.value);
      await database.close();

      expect(migrated!.lastReadSection, 0);
      expect(migrated.lastReadBlock, 0);
    });
  });
}
