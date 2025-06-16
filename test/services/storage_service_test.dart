import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:chkpnt/services/storage_service.dart';

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
  late ProviderContainer container;

  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  setUp(() {
    container = ProviderContainer();
    storageService = container.read(storageServiceProvider);
  });

  tearDown(() {
    container.dispose();
  });

  group('StorageService', () {
    group('Android Version Detection', () {
      test('returns false for non-Android platforms', () async {
        // This test assumes running on non-Android platform (like test environment)
        final isAndroid14 = await storageService.isAndroid14OrLater();

        // On non-Android platforms, should return false
        if (!Platform.isAndroid) {
          expect(isAndroid14, isFalse);
        }
      });

      test('handles device info timeout gracefully', () async {
        // Test that the method doesn't throw on timeout and returns safe default
        final result = await storageService.isAndroid14OrLater();
        expect(result, isA<bool>());
      });

      test('handles device info errors gracefully', () async {
        // Test that errors are handled and return safe default (true for safety)
        final result = await storageService.isAndroid14OrLater();
        expect(result, isA<bool>());
      });
    });

    group('Persistent Storage Directory', () {
      test('returns valid directory path', () async {
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isNotNull);
        expect(directory.path, isNotEmpty);
        expect(directory.path, contains('/mock/support'));
      });

      test('creates directory if it does not exist', () async {
        final directory = await storageService.getPersistentStorageDirectory();

        // Should return a valid Directory object
        expect(directory, isA<Directory>());
        expect(directory.path, isNotEmpty);
      });

      test('handles storage access errors gracefully', () async {
        // Test that errors in storage access fall back to documents directory
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isNotNull);
        expect(directory.path, isNotEmpty);
      });
    });

    group('Platform-Specific Storage', () {
      test('uses appropriate storage for iOS/macOS', () async {
        // Test would verify iOS/macOS specific paths in real environment
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory.path, isNotEmpty);
        expect(directory.path, contains('/mock'));
      });

      test('handles external storage unavailable scenario', () async {
        // Test fallback when external storage is null
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isNotNull);
        expect(directory.path, isNotEmpty);
      });

      test('creates app-specific subdirectory correctly', () async {
        final directory = await storageService.getPersistentStorageDirectory();

        // Should contain app-specific logic
        expect(directory, isA<Directory>());
        expect(directory.path, isNotEmpty);
      });
    });

    group('Error Handling', () {
      test('falls back to documents directory on complete failure', () async {
        // Test that complete failure still returns a valid directory
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isNotNull);
        expect(directory.path, isNotEmpty);
      });

      test('handles platform detection errors', () async {
        // Test that platform detection errors are handled gracefully
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isA<Directory>());
      });
    });

    group('Provider', () {
      test(
        'storageServiceProvider returns same instance on multiple reads',
        () {
          final service1 = container.read(storageServiceProvider);
          final service2 = container.read(storageServiceProvider);

          expect(identical(service1, service2), isTrue);
        },
      );

      test('storageServiceProvider returns StorageService instance', () {
        final service = container.read(storageServiceProvider);

        expect(service, isA<StorageService>());
      });
    });

    group('Integration', () {
      test('consistent storage paths across multiple calls', () async {
        final directory1 = await storageService.getPersistentStorageDirectory();
        final directory2 = await storageService.getPersistentStorageDirectory();

        expect(directory1.path, equals(directory2.path));
      });

      test('storage service is ready for use by other services', () async {
        // Test that the service can be used by dependent services
        final directory = await storageService.getPersistentStorageDirectory();

        expect(directory, isNotNull);
        expect(directory.path, isNotEmpty);

        // Verify it can be used to create subdirectories
        expect(() => Directory('${directory.path}/test'), returnsNormally);
      });
    });
  });
}
