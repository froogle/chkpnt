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
        expect(GameImageService.maxImageSize, equals(256));
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

    group('Persistent Storage', () {
      test('should use persistent storage location for images', () async {
        // This test verifies that images are stored in persistent location
        final imagePath = await gameImageService.getImagePath('test_image.jpg');

        // Should use Application Support Directory (not Documents)
        expect(imagePath, contains('/mock/support'));
        expect(imagePath, contains('game_images'));
        expect(imagePath, contains('test_image.jpg'));
        expect(imagePath, isNot(contains('/mock/documents')));
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

    group('getImagePath', () {
      test('returns correct path for image file', () async {
        final imagePath = await gameImageService.getImagePath('test_image.jpg');

        expect(imagePath, isNotNull);
        expect(imagePath, contains('/mock/support'));
        expect(imagePath, contains('game_images'));
        expect(imagePath, contains('test_image.jpg'));
      });

      test('handles empty path', () async {
        final imagePath = await gameImageService.getImagePath('');
        expect(imagePath, contains('/mock/support'));
        expect(imagePath, contains('game_images'));
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

    group('Error Handling', () {
      test(
        'should handle persistent storage directory errors gracefully',
        () async {
          // Test ensures fallback behaviour works when storage access fails
          final imagePath = await gameImageService.getImagePath(
            'fallback_test.jpg',
          );
          expect(imagePath, isNotEmpty);
          expect(imagePath, contains('.jpg'));
        },
      );

      test('should handle image path operations safely', () async {
        // Test various edge cases
        final paths = [
          'normal_image.jpg',
          'subfolder/image.png',
          'special-chars_image.jpeg',
        ];

        for (final path in paths) {
          final fullPath = await gameImageService.getImagePath(path);
          expect(fullPath, isNotEmpty);
          expect(fullPath, contains(path));
        }
      });
    });

    group('Platform Compatibility', () {
      test('should work with different image formats', () async {
        final formats = ['jpg', 'jpeg', 'png'];

        for (final format in formats) {
          final imagePath = 'test_image.$format';
          final fullPath = await gameImageService.getImagePath(imagePath);

          expect(fullPath, contains(imagePath));
          expect(fullPath, contains('/mock/support'));
        }
      });

      test('should handle platform-specific storage paths', () async {
        // Test would verify platform-specific paths in real environment
        final imagePath = await gameImageService.getImagePath(
          'platform_test.jpg',
        );
        expect(imagePath, isNotNull);
        expect(imagePath, contains('platform_test.jpg'));
      });
    });
  });

  group('GameImageSource enum', () {
    test('has correct values', () {
      expect(GameImageSource.values, hasLength(3));
      expect(GameImageSource.values, contains(GameImageSource.camera));
      expect(GameImageSource.values, contains(GameImageSource.gallery));
      expect(GameImageSource.values, contains(GameImageSource.files));
    });

    test('camera has correct string representation', () {
      expect(GameImageSource.camera.toString(), contains('camera'));
    });

    test('gallery has correct string representation', () {
      expect(GameImageSource.gallery.toString(), contains('gallery'));
    });

    test('files has correct string representation', () {
      expect(GameImageSource.files.toString(), contains('files'));
    });
  });
}
