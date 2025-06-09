import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:chkpnt/services/game_image_service.dart';

// Mock PathProviderPlatform for testing
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/mock/documents';
  }
}

void main() {
  late GameImageService gameImageService;
  late ProviderContainer container;

  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  setUp(() {
    container = ProviderContainer();
    gameImageService = container.read(gameImageServiceProvider);
  });

  tearDown(() {
    container.dispose();
  });

  group('GameImageService', () {
    group('Constants', () {
      test('has correct maximum image size', () {
        expect(GameImageService.maxImageSize, equals(1024));
      });

      test('has correct image directory name', () {
        expect(GameImageService.imageDirectory, equals('game_images'));
      });

      test('supports correct image extensions', () {
        expect(
          GameImageService.supportedExtensions,
          containsAll(['jpg', 'jpeg', 'png']),
        );
      });
    });

    group('imageExists', () {
      test('returns false for non-existent image', () async {
        final exists = await gameImageService.imageExists('nonexistent.jpg');
        expect(exists, isFalse);
      });

      test('returns false when path is invalid', () async {
        final exists = await gameImageService.imageExists('');
        expect(exists, isFalse);
      });
    });

    group('getImageFile', () {
      test('returns null for non-existent image', () async {
        final imageFile = await gameImageService.getImageFile(
          'nonexistent.jpg',
        );
        expect(imageFile, isNull);
      });

      test('returns null when path is invalid', () async {
        final imageFile = await gameImageService.getImageFile('');
        expect(imageFile, isNull);
      });
    });

    group('deleteImage', () {
      test('returns false for non-existent image', () async {
        final deleted = await gameImageService.deleteImage('nonexistent.jpg');
        expect(deleted, isFalse);
      });

      test('handles invalid path gracefully', () async {
        final deleted = await gameImageService.deleteImage('');
        expect(deleted, isFalse);
      });
    });

    group('Provider', () {
      test('gameImageServiceProvider provides GameImageService instance', () {
        final service = container.read(gameImageServiceProvider);
        expect(service, isA<GameImageService>());
      });

      test(
        'gameImageServiceProvider returns same instance on multiple reads',
        () {
          final service1 = container.read(gameImageServiceProvider);
          final service2 = container.read(gameImageServiceProvider);
          expect(identical(service1, service2), isTrue);
        },
      );
    });
  });

  group('GameImageSource enum', () {
    test('has correct values', () {
      expect(GameImageSource.values, hasLength(2));
      expect(GameImageSource.values, contains(GameImageSource.gallery));
      expect(GameImageSource.values, contains(GameImageSource.files));
    });

    test('gallery has correct string representation', () {
      expect(GameImageSource.gallery.toString(), contains('gallery'));
    });

    test('files has correct string representation', () {
      expect(GameImageSource.files.toString(), contains('files'));
    });
  });
}
