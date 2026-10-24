import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/providers/guide_provider.dart';
import 'package:chkpnt/providers/reading_position_provider.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';
import 'package:chkpnt/services/guide_storage_service.dart';

class TempPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  TempPathProviderPlatform(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;

  @override
  Future<String?> getApplicationSupportPath() async => path;

  @override
  Future<String?> getExternalStoragePath() async => path;
}

final _content = GuideContent(
  title: 'Walkthrough',
  author: 'Author',
  sections: [
    ContentSection(
      title: 'Intro',
      blocks: [
        ContentBlock(content: 'Intro 0'),
        ContentBlock(content: 'Intro 1'),
      ],
    ),
    ContentSection(
      title: 'Boss',
      blocks: [
        ContentBlock(content: 'Boss 0'),
        ContentBlock(content: 'Boss 1'),
        ContentBlock(content: 'Boss 2'),
      ],
    ),
  ],
);

const _introHeader = 0;
const _introBlock1 = 2;
const _introSpacer = 3;
const _bossHeader = 4;
const _bossBlock0 = 5;
const _bossBlock1 = 6;
const _bossBlock2 = 7;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late GameDatabase database;
  late DriftGuideRepository repository;
  late ProviderContainer container;
  late GameItem game;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('reading_position_test_');
    PathProviderPlatform.instance = TempPathProviderPlatform(tempDir.path);
    database = GameDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftGuideRepository(database);
    container = ProviderContainer(
      overrides: [guideRepositoryProvider.overrideWithValue(repository)],
    );
    game = await database.insertGame(
      GameItem.create(
        title: 'Guided Game',
        platform: 'PS5',
        status: GameStatus.playing,
      ),
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<GuideItem> addTextGuide({int section = 0, int block = 0}) async {
    final fileName = await container
        .read(guideStorageServiceProvider)
        .saveGuideJson(_content.toJsonString());
    return repository.createGuide(
      GuideItem.create(
        gameId: game.id,
        title: 'Walkthrough',
        author: 'Author',
        fileName: fileName,
      ).copyWith(lastReadSection: section, lastReadBlock: block),
    );
  }

  Future<(TextGuideReading, ProviderSubscription<Object?>)> open(
    GuideItem guide,
  ) async {
    final provider = readingPositionProvider(guide.id);
    final subscription = container.listen(provider, (_, __) {});
    return (await container.read(provider.future), subscription);
  }

  Future<void> close(ProviderSubscription<Object?> subscription) async {
    subscription.close();
    await container.pump();
    await pumpEventQueue();
  }

  ReadingPosition readingPosition(GuideItem guide) =>
      container.read(readingPositionProvider(guide.id).notifier);

  Future<(int, int)> storedPosition(GuideItem guide) async {
    final stored = (await repository.getGuideById(guide.id))!;
    return (stored.lastReadSection, stored.lastReadBlock);
  }

  group('ReadingPosition', () {
    test('opens a new Text Guide at the start', () async {
      final guide = await addTextGuide();

      final (reading, _) = await open(guide);

      expect(reading.startIndex, _introHeader);
      expect(reading.items.length, 9);
      expect(reading.items[_bossHeader], isA<SectionHeaderItem>());
      expect(reading.items[_introSpacer], isA<SectionSpacerItem>());
    });

    test('does not store the Reading Position before the save delay', () async {
      final guide = await addTextGuide();
      await open(guide);

      readingPosition(guide).moveTo(_bossBlock1);
      await pumpEventQueue();

      expect(await storedPosition(guide), (0, 0));
    });

    test(
      'stores the section and block of the top row after the save delay',
      () async {
        final guide = await addTextGuide();
        await open(guide);

        readingPosition(guide).moveTo(_bossBlock1);
        await Future<void>.delayed(
          ReadingPosition.saveDelay + const Duration(milliseconds: 100),
        );
        await pumpEventQueue();

        expect(await storedPosition(guide), (1, 1));
      },
    );

    test('stores the latest Reading Position when the reader closes', () async {
      final guide = await addTextGuide();
      final (_, subscription) = await open(guide);

      readingPosition(guide).moveTo(_introBlock1);
      readingPosition(guide).moveTo(_bossBlock2);
      await close(subscription);

      expect(await storedPosition(guide), (1, 2));
    });

    test('returns to the same block when reopened', () async {
      final guide = await addTextGuide();
      final (_, subscription) = await open(guide);

      readingPosition(guide).moveTo(_bossBlock1);
      await close(subscription);
      final (reopened, _) = await open(guide);

      expect(reopened.startIndex, _bossBlock1);
    });

    test('stores a section header and its first block as one place', () async {
      final guide = await addTextGuide();
      final (_, subscription) = await open(guide);

      readingPosition(guide).moveTo(_bossHeader);
      await close(subscription);
      expect(await storedPosition(guide), (1, 0));

      final (_, reopenedSubscription) = await open(guide);
      readingPosition(guide).moveTo(_bossBlock0);
      await close(reopenedSubscription);
      expect(await storedPosition(guide), (1, 0));
    });

    test('stores a section spacer as the start of the next section', () async {
      final guide = await addTextGuide();
      final (_, subscription) = await open(guide);

      readingPosition(guide).moveTo(_introSpacer);
      await close(subscription);

      expect(await storedPosition(guide), (1, 0));
    });

    test('returns to the section header from the start of a section', () async {
      final guide = await addTextGuide(section: 1, block: 0);

      final (reading, _) = await open(guide);

      expect(reading.startIndex, _bossHeader);
    });

    test(
      'opens at the start when the Reading Position no longer fits',
      () async {
        final pastLastSection = await addTextGuide(section: 5, block: 0);
        final pastLastBlock = await addTextGuide(section: 0, block: 9);

        final (pastSection, _) = await open(pastLastSection);
        final (pastBlock, _) = await open(pastLastBlock);

        expect(pastSection.startIndex, _introHeader);
        expect(pastBlock.startIndex, _introHeader);
      },
    );

    test('reports an error when the content file is missing', () async {
      final guide = await repository.createGuide(
        GuideItem.create(
          gameId: game.id,
          title: 'Walkthrough',
          author: 'Author',
          fileName: 'missing.json',
        ),
      );
      final provider = readingPositionProvider(guide.id);
      container.listen(provider, (_, __) {});

      await expectLater(
        container.read(provider.future),
        throwsA(isA<GuideFileNotFoundException>()),
      );
    });
  });
}
