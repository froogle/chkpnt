import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helpers.dart';

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

class MockGameImageService implements GameImageService {
  @override
  Future<String?> selectAndSaveImage(GameImageSource source) async => null;

  @override
  Future<bool> deleteImage(String imagePath) async => true;

  @override
  Future<bool> imageExists(String imagePath) async => false;

  @override
  Future<String> getImagePath(String imagePath) async => imagePath;

  @override
  Future<String?> downloadAndSaveImageFromUrl(String imageUrl) async => null;

  @override
  Future<CameraPermissionResult> checkAndRequestCameraPermission() async =>
      CameraPermissionResult.granted;

  @override
  Future<bool> openCameraSettings() async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Deselected state storage', () {
    test('keeps the database on schema version 7 with no new migration', () {
      final source =
          File('lib/repositories/drift_game_repository.dart').readAsStringSync();

      expect(source.contains('int get schemaVersion => 7;'), isTrue);
      expect(source.contains('from == 7'), isFalse);
      expect(source.contains('from < 8'), isFalse);
    });

    test('never shows the word Owned in any user-facing string literal', () {
      final ownedWord = RegExp(r'\bOwned\b');
      final offences = <String>[];

      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        if (entity.path.endsWith('.g.dart') ||
            entity.path.endsWith('.freezed.dart')) {
          continue;
        }

        for (final literal in _stringLiteralsIn(entity.readAsStringSync())) {
          if (ownedWord.hasMatch(literal)) {
            offences.add('${entity.path}: $literal');
          }
        }
      }

      expect(offences, isEmpty);
    });

    test('the Owned guard catches every quoting style', () {
      final ownedWord = RegExp(r'\bOwned\b');

      bool wouldFlag(String source) =>
          _stringLiteralsIn(source).any(ownedWord.hasMatch);

      expect(wouldFlag("return 'Owned';"), isTrue);
      expect(wouldFlag('return "Owned";'), isTrue);
      expect(wouldFlag("const label = 'Owned Games';"), isTrue);
      expect(wouldFlag("const label = 'Not Owned';"), isTrue);
      expect(wouldFlag(r"const label = '$prefix Owned';"), isTrue);
      expect(wouldFlag('const label = """Owned""";'), isTrue);
      expect(wouldFlag("const label = 'In Collection';"), isFalse);
      expect(wouldFlag('case GameStatus.owned:'), isFalse);
    });
  });

  group('Deselected games in the app lists', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('shows a deselected game in the collection but not the dashboard',
        () async {
      final deselected = GameItem.create(
        title: 'Deselected Game',
        platform: 'PS5',
        status: GameStatus.owned,
        isPhysical: true,
      );

      await container.read(gameListProvider.notifier).addGame(deselected);

      final collection = container
          .read(platformSectionsProvider(GameScreen.collection))
          .values
          .expand((games) => games);
      expect(collection.map((game) => game.title), contains('Deselected Game'));

      for (final status in [
        GameStatus.playing,
        GameStatus.backlog,
        GameStatus.ongoing,
        GameStatus.completed,
        GameStatus.abandoned,
      ]) {
        expect(
          container.read(gamesByStatusProvider(status)),
          isEmpty,
          reason: 'a deselected game must not appear under $status',
        );
      }
    });
  });

  group('Deselected state persistence', () {
    late Directory tempDir;
    late DriftGameRepository repository;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('deselection_test_');
      PathProviderPlatform.instance = TempPathProviderPlatform(tempDir.path);
      repository = DriftGameRepository(StorageService(), MockGameImageService());
    });

    tearDown(() async {
      await repository.dispose();
      tempDir.deleteSync(recursive: true);
    });

    test('reloads a deselected game as owned', () async {
      final created = await repository.createGame(
        GameItem.create(
          title: 'Was Playing',
          platform: 'PS5',
          status: GameStatus.playing,
          isPhysical: true,
        ),
      );

      await repository.updateGame(created.copyWith(status: GameStatus.owned));

      final reloaded = await repository.getGameById(created.id);
      expect(reloaded, isNotNull);
      expect(reloaded!.status, GameStatus.owned);
    });
  });
}

final _stringLiteralPattern = RegExp(
  r"""'''[\s\S]*?'''"""
  r'''|"""[\s\S]*?"""'''
  r"""|'(?:[^'\\\n]|\\.)*'"""
  r'''|"(?:[^"\\\n]|\\.)*"''',
);

Iterable<String> _stringLiteralsIn(String source) =>
    _stringLiteralPattern.allMatches(source).map((match) => match.group(0)!);
