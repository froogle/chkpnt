import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  late Directory tempDir;
  late DriftGameRepository repository;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('guide_backup_test_');
    PathProviderPlatform.instance = TempPathProviderPlatform(tempDir.path);
    repository = DriftGameRepository(StorageService(), MockGameImageService());
  });

  tearDown(() async {
    await repository.dispose();
    tempDir.deleteSync(recursive: true);
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
