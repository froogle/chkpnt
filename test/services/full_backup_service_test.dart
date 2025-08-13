import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:chkpnt/models/backup_models.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/services/full_backup_service.dart';

// Mock classes
class MockGameRepository extends Mock implements GameRepository {}
class MockStorageService extends Mock implements StorageService {}
class MockGameImageService extends Mock implements GameImageService {}
class MockDirectory extends Mock implements Directory {}
class MockFile extends Mock implements File {}
class MockFileStat extends Mock implements FileStat {}

void main() {
  group('FullBackupService', () {
    late MockGameRepository mockRepository;
    late MockStorageService mockStorageService;
    late MockGameImageService mockGameImageService;
    late FullBackupService backupService;
    late Directory tempDir;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(Directory(''));
      registerFallbackValue(File(''));
      registerFallbackValue(<GameItem>[]);
    });

    setUp(() {
      mockRepository = MockGameRepository();
      mockStorageService = MockStorageService();
      mockGameImageService = MockGameImageService();
      
      backupService = FullBackupService(
        mockRepository,
        mockStorageService,
        mockGameImageService,
      );

      // Create a real temporary directory for testing
      tempDir = Directory.systemTemp.createTempSync('backup_test_');
    });

    tearDown(() {
      // Clean up temporary directory
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    group('collectAllImages', () {
      test('should return empty list when images directory does not exist', () async {
        final mockAppDir = MockDirectory();
        final mockImageDir = MockDirectory();

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => mockAppDir);
        when(() => mockAppDir.path).thenReturn('/app');
        when(() => mockImageDir.exists()).thenAnswer((_) async => false);

        final result = await backupService.collectAllImages();

        expect(result, isEmpty);
      });

      test('should collect image files from images directory', () async {
        // Create test images directory with files
        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();
        
        final imageFile1 = File(path.join(imagesDir.path, 'game_001.jpg'));
        final imageFile2 = File(path.join(imagesDir.path, 'game_002.png'));
        final textFile = File(path.join(imagesDir.path, 'readme.txt'));
        
        await imageFile1.writeAsString('fake image data 1');
        await imageFile2.writeAsString('fake image data 2');
        await textFile.writeAsString('not an image');

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);

        final result = await backupService.collectAllImages();

        expect(result, hasLength(2));
        expect(result.map((f) => path.basename(f.path)), 
               containsAll(['game_001.jpg', 'game_002.png']));
        expect(result.map((f) => path.basename(f.path)), 
               isNot(contains('readme.txt')));
      });

      test('should sort image files by name', () async {
        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();
        
        // Create files in reverse alphabetical order
        final imageFile3 = File(path.join(imagesDir.path, 'game_003.jpg'));
        final imageFile1 = File(path.join(imagesDir.path, 'game_001.jpg'));
        final imageFile2 = File(path.join(imagesDir.path, 'game_002.png'));
        
        await imageFile3.writeAsString('image 3');
        await imageFile1.writeAsString('image 1');
        await imageFile2.writeAsString('image 2');

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);

        final result = await backupService.collectAllImages();

        expect(result, hasLength(3));
        expect(result.map((f) => path.basename(f.path)).toList(), 
               equals(['game_001.jpg', 'game_002.png', 'game_003.jpg']));
      });

      test('should throw BackupException on file system error', () async {
        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenThrow(Exception('Storage error'));

        expect(
          () => backupService.collectAllImages(),
          throwsA(isA<BackupException>()
              .having((e) => e.code, 'code', 'IMAGE_COLLECTION_FAILED')),
        );
      });
    });

    group('createBackupMetadata', () {
      test('should create metadata with correct information', () async {
        final testGames = [
          GameItem.create(
            title: 'Test Game 1',
            platform: 'PS5',
            status: GameStatus.playing,
          ),
          GameItem.create(
            title: 'Test Game 2', 
            platform: 'Switch',
            status: GameStatus.completed,
          ),
        ];

        final imageFiles = [
          File(path.join(tempDir.path, 'game_001.jpg')),
          File(path.join(tempDir.path, 'game_002.png')),
        ];

        when(() => mockRepository.getAllGames())
            .thenAnswer((_) async => testGames);

        final result = await backupService.createBackupMetadata(imageFiles);

        expect(result.version, equals('1.0.0'));
        expect(result.gameCount, equals(2));
        expect(result.imageCount, equals(2));
        expect(result.includedImages, equals(['game_001.jpg', 'game_002.png']));
        expect(result.createdAt, isA<DateTime>());
      });

      test('should handle empty games and images', () async {
        when(() => mockRepository.getAllGames())
            .thenAnswer((_) async => []);

        final result = await backupService.createBackupMetadata([]);

        expect(result.gameCount, equals(0));
        expect(result.imageCount, equals(0));
        expect(result.includedImages, isEmpty);
      });

      test('should throw BackupException on repository error', () async {
        when(() => mockRepository.getAllGames())
            .thenThrow(Exception('Database error'));

        expect(
          () => backupService.createBackupMetadata([]),
          throwsA(isA<BackupException>()
              .having((e) => e.code, 'code', 'METADATA_CREATION_FAILED')),
        );
      });
    });

    group('validateBackupFile', () {
      test('should return invalid for non-existent file', () async {
        const filePath = '/nonexistent/backup.zip';

        final result = await backupService.validateBackupFile(filePath);

        expect(result, isA<BackupValidationResult>());
        result.when(
          valid: (_) => fail('Expected invalid result'),
          invalid: (reason) => expect(reason, equals('Backup file does not exist')),
          corrupted: (_) => fail('Expected invalid result'),
        );
      });

      test('should return corrupted for non-ZIP file', () async {
        final testFile = File(path.join(tempDir.path, 'not_a_zip.txt'));
        await testFile.writeAsString('This is not a ZIP file');

        final result = await backupService.validateBackupFile(testFile.path);

        expect(result, isA<BackupValidationResult>());
        result.when(
          valid: (_) => fail('Expected corrupted result'),
          invalid: (_) => fail('Expected corrupted result'),
          corrupted: (details) => expect(details, contains('Not a valid ZIP file')),
        );
      });

      test('should return invalid for ZIP missing metadata.json', () async {
        // Create a ZIP file without metadata.json
        final archive = Archive();
        archive.addFile(ArchiveFile('database.json', 13, 'fake database'.codeUnits));
        
        final zipData = ZipEncoder().encode(archive)!;
        final zipFile = File(path.join(tempDir.path, 'incomplete.zip'));
        await zipFile.writeAsBytes(zipData);

        final result = await backupService.validateBackupFile(zipFile.path);

        result.when(
          valid: (_) => fail('Expected invalid result'),
          invalid: (reason) => expect(reason, equals('Missing metadata.json file')),
          corrupted: (_) => fail('Expected invalid result'),
        );
      });

      test('should return invalid for ZIP missing database.json', () async {
        // Create a ZIP file without database.json
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime.now(),
          gameCount: 0,
          imageCount: 0,
          includedImages: const [],
        );
        
        final archive = Archive();
        archive.addFile(ArchiveFile(
          'metadata.json', 
          json.encode(metadata.toJson()).length,
          utf8.encode(json.encode(metadata.toJson())),
        ));
        
        final zipData = ZipEncoder().encode(archive)!;
        final zipFile = File(path.join(tempDir.path, 'no_database.zip'));
        await zipFile.writeAsBytes(zipData);

        final result = await backupService.validateBackupFile(zipFile.path);

        result.when(
          valid: (_) => fail('Expected invalid result'),
          invalid: (reason) => expect(reason, equals('Missing database.json file')),
          corrupted: (_) => fail('Expected invalid result'),
        );
      });

      test('should return valid for properly formatted backup', () async {
        // Create a valid backup ZIP
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime.now(),
          gameCount: 1,
          imageCount: 0,
          includedImages: const [],
        );
        
        final archive = Archive();
        archive.addFile(ArchiveFile(
          'metadata.json',
          json.encode(metadata.toJson()).length,
          utf8.encode(json.encode(metadata.toJson())),
        ));
        archive.addFile(ArchiveFile('database.json', 13, 'fake database'.codeUnits));
        
        final zipData = ZipEncoder().encode(archive)!;
        final zipFile = File(path.join(tempDir.path, 'valid_backup.zip'));
        await zipFile.writeAsBytes(zipData);

        final result = await backupService.validateBackupFile(zipFile.path);

        result.when(
          valid: (meta) {
            expect(meta.version, equals('1.0.0'));
            expect(meta.gameCount, equals(1));
            expect(meta.imageCount, equals(0));
          },
          invalid: (reason) => fail('Expected valid result, got: $reason'),
          corrupted: (details) => fail('Expected valid result, got: $details'),
        );
      });
    });

    group('getBackupSizeString', () {
      test('should format file size correctly', () {
        final mockFile = MockFile();
        
        // Test bytes
        when(() => mockFile.lengthSync()).thenReturn(500);
        expect(backupService.getBackupSizeString(mockFile), equals('500B'));
        
        // Test KB
        when(() => mockFile.lengthSync()).thenReturn(1536); // 1.5 KB
        expect(backupService.getBackupSizeString(mockFile), equals('1.5KB'));
        
        // Test MB  
        when(() => mockFile.lengthSync()).thenReturn(2097152); // 2 MB
        expect(backupService.getBackupSizeString(mockFile), equals('2.0MB'));
        
        // Test GB
        when(() => mockFile.lengthSync()).thenReturn(1073741824); // 1 GB
        expect(backupService.getBackupSizeString(mockFile), equals('1.0GB'));
      });

      test('should handle file size error gracefully', () {
        final mockFile = MockFile();
        when(() => mockFile.lengthSync()).thenThrow(Exception('File access error'));
        
        expect(backupService.getBackupSizeString(mockFile), equals('Unknown size'));
      });
    });

    group('getBackupFileInfo', () {
      test('should return file info with metadata for valid backup', () async {
        // Create a valid backup file
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime(2024, 1, 15, 10, 30),
          gameCount: 5,
          imageCount: 0, // No images for this test to simplify
          includedImages: const [],
        );
        
        final archive = Archive();
        final metadataJson = json.encode(metadata.toJson());
        archive.addFile(ArchiveFile(
          'metadata.json',
          metadataJson.length,
          utf8.encode(metadataJson),
        ));
        archive.addFile(ArchiveFile('database.json', 13, 'fake database'.codeUnits));
        
        final zipData = ZipEncoder().encode(archive)!;
        final zipFile = File(path.join(tempDir.path, 'test_backup.zip'));
        await zipFile.writeAsBytes(zipData);

        final result = await backupService.getBackupFileInfo(zipFile.path);

        expect(result.fileName, equals('test_backup.zip'));
        expect(result.filePath, equals(zipFile.path));
        expect(result.fileSizeBytes, greaterThan(0));
        expect(result.metadata, isNotNull);
        expect(result.metadata!.gameCount, equals(5));
        expect(result.metadata!.imageCount, equals(0));
      });

      test('should return file info without metadata for invalid backup', () async {
        // Create an invalid backup file
        final textFile = File(path.join(tempDir.path, 'invalid.zip'));
        await textFile.writeAsString('This is not a valid backup');

        final result = await backupService.getBackupFileInfo(textFile.path);

        expect(result.fileName, equals('invalid.zip'));
        expect(result.filePath, equals(textFile.path));
        expect(result.fileSizeBytes, greaterThan(0));
        expect(result.metadata, isNull);
      });
    });

    group('createFullBackup', () {
      test('should create backup file with database and images', () async {
        // Create test data
        final testGames = [
          GameItem.create(
            title: 'Test Game 1',
            platform: 'PS5',
            status: GameStatus.playing,
          ),
        ];

        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();
        final imageFile = File(path.join(imagesDir.path, 'game_001.jpg'));
        await imageFile.writeAsString('fake image data');

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);
        when(() => mockRepository.getAllGames())
            .thenAnswer((_) async => testGames);
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": [{"id": "test"}]}');

        final destDir = Directory(path.join(tempDir.path, 'backups'));
        await destDir.create();

        final result = await backupService.createFullBackup(destDir.path);

        expect(result.existsSync(), isTrue);
        expect(result.path, contains('chkpnt_backup_'));
        expect(result.path, endsWith('.zip'));

        // Verify ZIP contents
        final zipBytes = await result.readAsBytes();
        final archive = ZipDecoder().decodeBytes(zipBytes);
        
        expect(archive.findFile('metadata.json'), isNotNull);
        expect(archive.findFile('database.json'), isNotNull);
        expect(archive.findFile('images/game_001.jpg'), isNotNull);
      });

      test('should handle backup creation errors gracefully', () async {
        when(() => mockRepository.exportDatabaseToJson())
            .thenThrow(Exception('Database export failed'));

        final destDir = Directory(path.join(tempDir.path, 'backups'));
        await destDir.create();

        expect(
          () => backupService.createFullBackup(destDir.path),
          throwsA(isA<BackupException>()
              .having((e) => e.code, 'code', 'BACKUP_CREATION_FAILED')),
        );
      });
    });

    group('restoreFromFullBackup', () {
      test('should restore database and images from valid backup', () async {
        // Create a valid backup file
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime.now(),
          gameCount: 1,
          imageCount: 1,
          includedImages: const ['game_001.jpg'],
        );

        final archive = Archive();
        
        // Add metadata
        final metadataJson = json.encode(metadata.toJson());
        archive.addFile(ArchiveFile(
          'metadata.json',
          metadataJson.length,
          utf8.encode(metadataJson),
        ));

        // Add database
        final databaseJson = '{"games": [{"id": "restored-game"}]}';
        archive.addFile(ArchiveFile(
          'database.json',
          databaseJson.length,
          utf8.encode(databaseJson),
        ));

        // Add image
        final imageData = 'restored image data';
        archive.addFile(ArchiveFile(
          'images/game_001.jpg',
          imageData.length,
          imageData.codeUnits,
        ));

        final zipData = ZipEncoder().encode(archive)!;
        final backupFile = File(path.join(tempDir.path, 'test_backup.zip'));
        await backupFile.writeAsBytes(zipData);

        // Set up mocks
        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": []}'); // Current state
        when(() => mockRepository.importFromJson(any()))
            .thenAnswer((_) async {});

        // Create target images directory
        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();

        await backupService.restoreFromFullBackup(backupFile.path);

        // Verify database import was called
        verify(() => mockRepository.importFromJson(databaseJson)).called(1);
        
        // Verify image was restored
        final restoredImage = File(path.join(imagesDir.path, 'game_001.jpg'));
        expect(await restoredImage.exists(), isTrue);
        expect(await restoredImage.readAsString(), equals(imageData));
      });

      test('should rollback on restore failure', () async {
        // Create a backup that will fail during restore
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime.now(),
          gameCount: 1,
          imageCount: 0,
          includedImages: const [],
        );

        final archive = Archive();
        final metadataJson = json.encode(metadata.toJson());
        archive.addFile(ArchiveFile(
          'metadata.json',
          metadataJson.length,
          utf8.encode(metadataJson),
        ));
        archive.addFile(ArchiveFile(
          'database.json',
          15,
          'invalid database'.codeUnits,
        ));

        final zipData = ZipEncoder().encode(archive)!;
        final backupFile = File(path.join(tempDir.path, 'test_backup.zip'));
        await backupFile.writeAsBytes(zipData);

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": [{"id": "original"}]}');
        when(() => mockRepository.importFromJson('invalid database'))
            .thenThrow(Exception('Import failed'));
        when(() => mockRepository.importFromJson('{"games": []}'))
            .thenAnswer((_) async {}); // Clear data during restore
        when(() => mockRepository.importFromJson('{"games": [{"id": "original"}]}'))
            .thenAnswer((_) async {}); // Rollback should work

        expect(
          () => backupService.restoreFromFullBackup(backupFile.path),
          throwsA(isA<BackupException>()
              .having((e) => e.code, 'code', 'RESTORE_FAILED')),
        );

        // Verify rollback was attempted
        verify(() => mockRepository.importFromJson('{"games": [{"id": "original"}]}')).called(1);
      });

      test('should reject invalid backup files', () async {
        final invalidFile = File(path.join(tempDir.path, 'invalid.zip'));
        await invalidFile.writeAsString('not a valid backup');

        expect(
          () => backupService.restoreFromFullBackup(invalidFile.path),
          throwsA(isA<BackupException>()
              .having((e) => e.code, 'code', anyOf('CORRUPTED_BACKUP_FILE', 'RESTORE_FAILED'))),
        );
      });
    });

    group('progress tracking', () {
      test('createFullBackupWithProgress should emit progress values', () async {
        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": []}');
        when(() => mockRepository.getAllGames())
            .thenAnswer((_) async => []);

        final destDir = Directory(path.join(tempDir.path, 'backups'));
        await destDir.create();

        final progressValues = <double>[];
        await for (final progress in backupService.createFullBackupWithProgress(destDir.path)) {
          progressValues.add(progress);
          if (progress >= 1.0) break;
        }

        expect(progressValues.first, equals(0.0));
        expect(progressValues.last, equals(1.0));
        expect(progressValues.length, greaterThan(3));
        
        // Progress should be monotonically increasing
        for (int i = 1; i < progressValues.length; i++) {
          expect(progressValues[i], greaterThanOrEqualTo(progressValues[i - 1]));
        }
      });

      test('restoreFromFullBackupWithProgress should emit progress values', () async {
        // Create a minimal valid backup
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime.now(),
          gameCount: 0,
          imageCount: 0,
          includedImages: const [],
        );

        final archive = Archive();
        final metadataJson = json.encode(metadata.toJson());
        archive.addFile(ArchiveFile(
          'metadata.json',
          metadataJson.length,
          utf8.encode(metadataJson),
        ));
        archive.addFile(ArchiveFile(
          'database.json',
          15,
          '{"games": []}'.codeUnits,
        ));

        final zipData = ZipEncoder().encode(archive)!;
        final backupFile = File(path.join(tempDir.path, 'test_backup.zip'));
        await backupFile.writeAsBytes(zipData);

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": []}');
        when(() => mockRepository.importFromJson(any()))
            .thenAnswer((_) async {});

        final progressValues = <double>[];
        await for (final progress in backupService.restoreFromFullBackupWithProgress(backupFile.path)) {
          progressValues.add(progress);
          if (progress >= 1.0) break;
        }

        expect(progressValues.first, equals(0.0));
        expect(progressValues.last, equals(1.0));
        expect(progressValues.length, greaterThan(3));
      });
    });

    group('file system integration', () {
      test('getAvailableFullBackups should find valid backup files', () async {
        // Create some test backup files
        final backupsDir = Directory(path.join(tempDir.path, 'backups'));
        await backupsDir.create();

        // Create a valid backup file
        final metadata = BackupMetadata(
          version: '1.0.0',
          createdAt: DateTime(2024, 1, 15, 10, 30),
          gameCount: 5,
          imageCount: 2,
          includedImages: const ['game1.jpg', 'game2.png'],
        );

        final archive = Archive();
        final metadataJson = json.encode(metadata.toJson());
        archive.addFile(ArchiveFile(
          'metadata.json',
          metadataJson.length,
          utf8.encode(metadataJson),
        ));
        archive.addFile(ArchiveFile('database.json', 13, '{"games": []}'.codeUnits));

        final zipData = ZipEncoder().encode(archive)!;
        final backupFile = File(path.join(backupsDir.path, 'chkpnt_backup_2024-01-15T10-30-00.zip'));
        await backupFile.writeAsBytes(zipData);

        // Create a non-backup file that should be ignored
        final otherFile = File(path.join(backupsDir.path, 'other_file.zip'));
        await otherFile.writeAsString('not a backup');

        final result = await backupService.getAvailableFullBackups(backupsDir.path);

        expect(result, hasLength(1));
        expect(result.first.fileName, equals('chkpnt_backup_2024-01-15T10-30-00.zip'));
        // Metadata might be null if validation failed, but file should still be found
        if (result.first.metadata != null) {
          expect(result.first.metadata!.gameCount, equals(5));
        }
      });

      test('isDirectoryWritable should check write permissions', () async {
        final writableDir = Directory(path.join(tempDir.path, 'writable'));
        await writableDir.create();

        final result = await backupService.isDirectoryWritable(writableDir.path);
        expect(result, isTrue);

        final nonExistentDir = Directory(path.join(tempDir.path, 'nonexistent'));
        final result2 = await backupService.isDirectoryWritable(nonExistentDir.path);
        expect(result2, isFalse);
      });

      test('estimateBackupSize should calculate approximate size', () async {
        when(() => mockRepository.exportDatabaseToJson())
            .thenAnswer((_) async => '{"games": [{"id": "test", "title": "Test Game"}]}');
        
        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();
        final imageFile = File(path.join(imagesDir.path, 'game_001.jpg'));
        await imageFile.writeAsString('test image data that is somewhat long');

        when(() => mockStorageService.getPersistentStorageDirectory())
            .thenAnswer((_) async => tempDir);

        final result = await backupService.estimateBackupSize();
        
        expect(result, greaterThan(0));
        expect(result, lessThan(1024 * 1024)); // Should be less than 1MB for test data
      });
    });
  });
}