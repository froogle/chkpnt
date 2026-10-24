import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helpers.dart';

// Mock PathProviderPlatform for testing
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/mock/documents';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return '/mock/support';
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return '/mock/external';
  }
}

void main() {
  late StorageService storageService;
  late GameImageService mockImageService;

  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  setUp(() {
    storageService = StorageService();
    mockImageService = MockGameImageService();
  });

  group('DriftGameRepository', () {
    group('Repository Interface', () {
      test('should implement GameRepository interface', () {
        final repository = DriftGameRepository(
          storageService,
          mockImageService,
        );
        expect(repository, isA<GameRepository>());
        repository.dispose();
      });

      test('should have required methods', () {
        final repository = DriftGameRepository(
          storageService,
          mockImageService,
        );

        // Verify methods exist without calling them to avoid DB creation
        expect(repository.getAllGames, isA<Function>());
        expect(repository.watchGames, isA<Function>());
        expect(repository.createGame, isA<Function>());
        expect(repository.updateGame, isA<Function>());
        expect(repository.deleteGame, isA<Function>());
        expect(repository.exportDatabaseToJson, isA<Function>());
        expect(repository.importFromJson, isA<Function>());
        expect(repository.getDatabasePath, isA<Function>());

        repository.dispose();
      });
    });

    group('Basic Functionality', () {
      test('should be instantiable', () {
        expect(
          () => DriftGameRepository(storageService, mockImageService),
          returnsNormally,
        );
        final repository = DriftGameRepository(
          storageService,
          mockImageService,
        );
        repository.dispose();
      });

      test('should be disposable', () {
        final repository = DriftGameRepository(
          storageService,
          mockImageService,
        );
        expect(() => repository.dispose(), returnsNormally);
      });
    });
  });
}
