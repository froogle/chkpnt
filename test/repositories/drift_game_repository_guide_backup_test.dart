import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DriftGameRepository repository;

  setUp(() {
    repository = DriftGameRepository.withDatabase(
      GameDatabase.withExecutor(NativeDatabase.memory()),
      MockGameImageService(),
    );
  });

  tearDown(() async {
    await repository.dispose();
  });

  Future<Map<String, dynamic>> backUpWebGuide() async {
    final game = await repository.createGame(
      GameItem.create(
        title: 'Guided Game',
        platform: 'PS5',
        status: GameStatus.playing,
      ),
    );
    await repository.database.insertGuide(
      GuideItem.createHtmlLink(
        gameId: game.id,
        title: 'Web Guide',
        author: 'Author',
        sourceUrl: 'http://example.com/web-guide',
      ),
    );
    return jsonDecode(await repository.exportDatabaseToJson())
        as Map<String, dynamic>;
  }

  group('DriftGameRepository Guide backup', () {
    test('round trips a Web Guide through backup and restore', () async {
      final backup = await backUpWebGuide();
      expect(
        (backup['guides'] as List).first['format'],
        GuideFormat.html.index,
      );

      await repository.importFromJson(jsonEncode(backup));
      final restored = await repository.database.getAllGuidesInternal();

      expect(restored.length, 1);
      expect(restored.first.format, GuideFormat.html);
    });

    test(
      'restores a Guide as a Text Guide when the backup has no format',
      () async {
        final backup = await backUpWebGuide();
        ((backup['guides'] as List).first as Map<String, dynamic>).remove(
          'format',
        );

        await repository.importFromJson(jsonEncode(backup));
        final restored = await repository.database.getAllGuidesInternal();

        expect(restored.length, 1);
        expect(restored.first.format, GuideFormat.text);
      },
    );
  });
}
