import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/models/backup_models.dart';

void main() {
  group('BackupMetadata', () {
    test('should create BackupMetadata with required fields', () {
      final now = DateTime.now();
      const imageList = ['game_001.jpg', 'game_002.png'];
      
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: now,
        gameCount: 5,
        imageCount: 2,
        includedImages: imageList,
      );

      expect(metadata.version, equals('1.0.0'));
      expect(metadata.createdAt, equals(now));
      expect(metadata.gameCount, equals(5));
      expect(metadata.imageCount, equals(2));
      expect(metadata.includedImages, equals(imageList));
    });

    test('should serialize to and from JSON correctly', () {
      final originalMetadata = BackupMetadata(
        version: '1.0.0',
        createdAt: DateTime(2024, 1, 15, 14, 30, 45),
        gameCount: 3,
        imageCount: 2,
        includedImages: const ['game_001.jpg', 'game_002.png'],
      );

      // Serialize to JSON
      final json = originalMetadata.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['version'], equals('1.0.0'));
      expect(json['gameCount'], equals(3));
      expect(json['imageCount'], equals(2));
      expect(json['includedImages'], isA<List>());

      // Deserialize from JSON
      final deserializedMetadata = BackupMetadata.fromJson(json);
      expect(deserializedMetadata.version, equals(originalMetadata.version));
      expect(deserializedMetadata.createdAt, equals(originalMetadata.createdAt));
      expect(deserializedMetadata.gameCount, equals(originalMetadata.gameCount));
      expect(deserializedMetadata.imageCount, equals(originalMetadata.imageCount));
      expect(deserializedMetadata.includedImages, equals(originalMetadata.includedImages));
    });

    test('should handle empty image list', () {
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: DateTime.now(),
        gameCount: 0,
        imageCount: 0,
        includedImages: const [],
      );

      final json = metadata.toJson();
      final deserialized = BackupMetadata.fromJson(json);
      
      expect(deserialized.includedImages, isEmpty);
      expect(deserialized.imageCount, equals(0));
    });
  });

  group('BackupValidationResult', () {
    test('should create valid result', () {
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: DateTime.now(),
        gameCount: 1,
        imageCount: 0,
        includedImages: const [],
      );

      final result = BackupValidationResult.valid(metadata);
      
      expect(result, isA<BackupValidationResult>());
      result.when(
        valid: (meta) => expect(meta, equals(metadata)),
        invalid: (_) => fail('Expected valid result'),
        corrupted: (_) => fail('Expected valid result'),
      );
    });

    test('should create invalid result', () {
      const reason = 'Missing metadata file';
      const result = BackupValidationResult.invalid(reason);
      
      expect(result, isA<BackupValidationResult>());
      result.when(
        valid: (_) => fail('Expected invalid result'),
        invalid: (r) => expect(r, equals(reason)),
        corrupted: (_) => fail('Expected invalid result'),
      );
    });

    test('should create corrupted result', () {
      const details = 'ZIP file is corrupted';
      const result = BackupValidationResult.corrupted(details);
      
      expect(result, isA<BackupValidationResult>());
      result.when(
        valid: (_) => fail('Expected corrupted result'),
        invalid: (_) => fail('Expected corrupted result'),
        corrupted: (d) => expect(d, equals(details)),
      );
    });
  });

  group('BackupProgress', () {
    test('should create BackupProgress with all fields', () {
      const progress = BackupProgress(
        progress: 0.5,
        currentStep: 'Creating archive',
        statusMessage: 'Processing images...',
      );

      expect(progress.progress, equals(0.5));
      expect(progress.currentStep, equals('Creating archive'));
      expect(progress.statusMessage, equals('Processing images...'));
    });

    test('should serialize to and from JSON correctly', () {
      const original = BackupProgress(
        progress: 0.75,
        currentStep: 'Finalizing backup',
        statusMessage: 'Almost complete',
      );

      final json = original.toJson();
      final deserialized = BackupProgress.fromJson(json);

      expect(deserialized.progress, equals(original.progress));
      expect(deserialized.currentStep, equals(original.currentStep));
      expect(deserialized.statusMessage, equals(original.statusMessage));
    });

    test('should handle null statusMessage', () {
      const progress = BackupProgress(
        progress: 1.0,
        currentStep: 'Complete',
        statusMessage: null,
      );

      expect(progress.statusMessage, isNull);
      
      final json = progress.toJson();
      final deserialized = BackupProgress.fromJson(json);
      expect(deserialized.statusMessage, isNull);
    });
  });

  group('BackupFileInfo', () {
    test('should create BackupFileInfo with all fields', () {
      final createdAt = DateTime.now();
      final metadata = BackupMetadata(
        version: '1.0.0',
        createdAt: createdAt,
        gameCount: 5,
        imageCount: 3,
        includedImages: const ['game1.jpg', 'game2.png', 'game3.jpg'],
      );

      final fileInfo = BackupFileInfo(
        filePath: '/path/to/backup.zip',
        fileName: 'backup.zip',
        fileSizeBytes: 1024000,
        createdAt: createdAt,
        metadata: metadata,
      );

      expect(fileInfo.filePath, equals('/path/to/backup.zip'));
      expect(fileInfo.fileName, equals('backup.zip'));
      expect(fileInfo.fileSizeBytes, equals(1024000));
      expect(fileInfo.createdAt, equals(createdAt));
      expect(fileInfo.metadata, equals(metadata));
    });

    test('should handle null metadata', () {
      final fileInfo = BackupFileInfo(
        filePath: '/path/to/backup.zip',
        fileName: 'backup.zip',
        fileSizeBytes: 512000,
        createdAt: DateTime.now(),
        metadata: null,
      );

      expect(fileInfo.metadata, isNull);
    });

    test('should serialize to and from JSON correctly', () {
      final original = BackupFileInfo(
        filePath: '/test/path/backup.zip',
        fileName: 'backup.zip',
        fileSizeBytes: 2048000,
        createdAt: DateTime(2024, 1, 15, 16, 45, 30),
        metadata: null,
      );

      final json = original.toJson();
      final deserialized = BackupFileInfo.fromJson(json);

      expect(deserialized.filePath, equals(original.filePath));
      expect(deserialized.fileName, equals(original.fileName));
      expect(deserialized.fileSizeBytes, equals(original.fileSizeBytes));
      expect(deserialized.createdAt, equals(original.createdAt));
      expect(deserialized.metadata, equals(original.metadata));
    });
  });

  group('BackupOperationType', () {
    test('should have expected enum values', () {
      expect(BackupOperationType.values, hasLength(3));
      expect(BackupOperationType.values, contains(BackupOperationType.create));
      expect(BackupOperationType.values, contains(BackupOperationType.restore));
      expect(BackupOperationType.values, contains(BackupOperationType.validate));
    });

    test('should have correct string representations', () {
      expect(BackupOperationType.create.toString(), equals('BackupOperationType.create'));
      expect(BackupOperationType.restore.toString(), equals('BackupOperationType.restore'));
      expect(BackupOperationType.validate.toString(), equals('BackupOperationType.validate'));
    });
  });
}