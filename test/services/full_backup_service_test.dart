import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:chkpnt/models/backup_models.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/services/guide_storage_service.dart';
import 'package:chkpnt/services/backup_archive_service.dart';
import 'package:chkpnt/services/backup_validation_service.dart';
import 'package:chkpnt/services/backup_permission_service.dart';
import 'package:chkpnt/services/full_backup_service.dart';

// Mock classes
class MockGameRepository extends Mock implements GameRepository {}

class MockStorageService extends Mock implements StorageService {}

class MockGameImageService extends Mock implements GameImageService {}

class MockGuideStorageService extends Mock implements GuideStorageService {}

class MockBackupArchiveService extends Mock implements BackupArchiveService {}

class MockBackupValidationService extends Mock
    implements BackupValidationService {}

class MockBackupPermissionService extends Mock
    implements BackupPermissionService {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockFileStat extends Mock implements FileStat {}

void main() {
  group('FullBackupService', () {
    late MockGameRepository mockRepository;
    late MockStorageService mockStorageService;
    late MockGameImageService mockGameImageService;
    late MockGuideStorageService mockGuideStorageService;
    late MockBackupArchiveService mockArchiveService;
    late MockBackupValidationService mockValidationService;
    late MockBackupPermissionService mockPermissionService;
    late FullBackupService backupService;
    late Directory tempDir;

    setUpAll(() {
      registerFallbackValue(Directory(''));
      registerFallbackValue(File(''));
      registerFallbackValue(<GameItem>[]);
      registerFallbackValue(Archive());
      registerFallbackValue(
        BackupData(
          databaseJson: '',
          imageFiles: [],
          guideFiles: [],
          metadata: BackupMetadata(
            version: '1.0.0',
            createdAt: DateTime.now(),
            gameCount: 0,
            imageCount: 0,
            includedImages: const [],
            guideCount: 0,
            includedGuides: const [],
          ),
        ),
      );
    });

    setUp(() {
      mockRepository = MockGameRepository();
      mockStorageService = MockStorageService();
      mockGameImageService = MockGameImageService();
      mockGuideStorageService = MockGuideStorageService();
      mockArchiveService = MockBackupArchiveService();
      mockValidationService = MockBackupValidationService();
      mockPermissionService = MockBackupPermissionService();

      backupService = FullBackupService(
        mockRepository,
        mockStorageService,
        mockGameImageService,
        mockGuideStorageService,
        mockArchiveService,
        mockValidationService,
        mockPermissionService,
      );

      tempDir = Directory.systemTemp.createTempSync('backup_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    group('delegation to services', () {
      test('validateBackupFile delegates to validation service', () async {
        const filePath = '/test/backup.zip';
        const expectedResult = BackupValidationResult.invalid('Test error');

        when(
          () => mockValidationService.validateBackupFile(filePath),
        ).thenAnswer((_) async => expectedResult);

        final result = await backupService.validateBackupFile(filePath);

        expect(result, equals(expectedResult));
        verify(
          () => mockValidationService.validateBackupFile(filePath),
        ).called(1);
      });

      test('getBackupFileInfo delegates to validation service', () async {
        const filePath = '/test/backup.zip';
        final expectedInfo = BackupFileInfo(
          filePath: filePath,
          fileName: 'backup.zip',
          fileSizeBytes: 1024,
          createdAt: DateTime.now(),
          metadata: null,
        );

        when(
          () => mockValidationService.getBackupFileInfo(filePath),
        ).thenAnswer((_) async => expectedInfo);

        final result = await backupService.getBackupFileInfo(filePath);

        expect(result, equals(expectedInfo));
        verify(
          () => mockValidationService.getBackupFileInfo(filePath),
        ).called(1);
      });

      test('getBackupSizeString delegates to archive service', () {
        final mockFile = MockFile();
        const expectedSize = '1.5KB';

        when(
          () => mockArchiveService.getFileSizeString(mockFile),
        ).thenReturn(expectedSize);

        final result = backupService.getBackupSizeString(mockFile);

        expect(result, equals(expectedSize));
        verify(() => mockArchiveService.getFileSizeString(mockFile)).called(1);
      });

      test('selectBackupDirectory delegates to permission service', () async {
        const expectedPath = '/selected/directory';

        when(
          () => mockPermissionService.selectBackupDirectory(),
        ).thenAnswer((_) async => expectedPath);

        final result = await backupService.selectBackupDirectory();

        expect(result, equals(expectedPath));
        verify(() => mockPermissionService.selectBackupDirectory()).called(1);
      });

      test('selectBackupFile delegates to permission service', () async {
        const expectedPath = '/selected/backup.zip';

        when(
          () => mockPermissionService.selectBackupFile(),
        ).thenAnswer((_) async => expectedPath);

        final result = await backupService.selectBackupFile();

        expect(result, equals(expectedPath));
        verify(() => mockPermissionService.selectBackupFile()).called(1);
      });

      test('isDirectoryWritable delegates to permission service', () async {
        const directoryPath = '/test/directory';

        when(
          () => mockPermissionService.isDirectoryWritable(directoryPath),
        ).thenAnswer((_) async => true);

        final result = await backupService.isDirectoryWritable(directoryPath);

        expect(result, isTrue);
        verify(
          () => mockPermissionService.isDirectoryWritable(directoryPath),
        ).called(1);
      });
    });

    group('backup creation workflow', () {
      test('createFullBackup coordinates services correctly', () async {
        final mockBackupFile = MockFile();
        const destinationDir = '/backup/destination';
        const backupFilePath = '/backup/destination/backup.zip';

        when(
          () => mockRepository.exportDatabaseToJson(),
        ).thenAnswer((_) async => '{"games": []}');
        when(() => mockRepository.getAllGames()).thenAnswer((_) async => []);
        when(
          () => mockStorageService.getPersistentStorageDirectory(),
        ).thenAnswer((_) async => tempDir);
        when(
          () => mockGuideStorageService.getAllGuideFiles(),
        ).thenAnswer((_) async => []);
        when(
          () => mockArchiveService.createArchive(any()),
        ).thenReturn(Archive());
        when(
          () => mockArchiveService.writeArchiveToFile(any(), destinationDir),
        ).thenAnswer((_) async => mockBackupFile);
        when(() => mockBackupFile.path).thenReturn(backupFilePath);
        when(
          () => mockArchiveService.getFileSizeString(mockBackupFile),
        ).thenReturn('1.0KB');

        final result = await backupService.createFullBackup(destinationDir);

        expect(result, equals(mockBackupFile));
        verify(() => mockRepository.exportDatabaseToJson()).called(1);
        verify(() => mockRepository.getAllGames()).called(1);
        verify(() => mockArchiveService.createArchive(any())).called(1);
        verify(
          () => mockArchiveService.writeArchiveToFile(any(), destinationDir),
        ).called(1);
      });

      test('createFullBackup handles errors correctly', () async {
        const destinationDir = '/backup/destination';

        when(
          () => mockRepository.exportDatabaseToJson(),
        ).thenThrow(Exception('Database export failed'));

        await expectLater(
          backupService.createFullBackup(destinationDir),
          throwsA(
            isA<BackupException>().having(
              (e) => e.code,
              'code',
              'BACKUP_CREATION_FAILED',
            ),
          ),
        );
      });
    });

    group('collectAllImages', () {
      test(
        'should return empty list when images directory does not exist',
        () async {
          final mockAppDir = MockDirectory();
          final mockImageDir = MockDirectory();

          when(
            () => mockStorageService.getPersistentStorageDirectory(),
          ).thenAnswer((_) async => mockAppDir);
          when(() => mockAppDir.path).thenReturn('/app');
          when(() => mockImageDir.exists()).thenAnswer((_) async => false);

          final result = await backupService.collectAllImages();

          expect(result, isEmpty);
        },
      );

      test('should collect image files from images directory', () async {
        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();

        final imageFile1 = File(path.join(imagesDir.path, 'game_001.jpg'));
        final imageFile2 = File(path.join(imagesDir.path, 'game_002.png'));
        final textFile = File(path.join(imagesDir.path, 'readme.txt'));

        await imageFile1.writeAsString('fake image data 1');
        await imageFile2.writeAsString('fake image data 2');
        await textFile.writeAsString('not an image');

        when(
          () => mockStorageService.getPersistentStorageDirectory(),
        ).thenAnswer((_) async => tempDir);

        final result = await backupService.collectAllImages();

        expect(result, hasLength(2));
        expect(
          result.map((f) => path.basename(f.path)),
          containsAll(['game_001.jpg', 'game_002.png']),
        );
        expect(
          result.map((f) => path.basename(f.path)),
          isNot(contains('readme.txt')),
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

        final guideFiles = [File(path.join(tempDir.path, 'guide_001.json'))];

        when(
          () => mockRepository.getAllGames(),
        ).thenAnswer((_) async => testGames);

        final result = await backupService.createBackupMetadata(
          imageFiles,
          guideFiles,
        );

        expect(result.version, equals('1.2.0'));
        expect(result.gameCount, equals(2));
        expect(result.imageCount, equals(2));
        expect(result.includedImages, equals(['game_001.jpg', 'game_002.png']));
        expect(result.guideCount, equals(1));
        expect(result.includedGuides, equals(['guide_001.json']));
        expect(result.createdAt, isA<DateTime>());
      });
    });

    group('estimateBackupSize', () {
      test('should calculate approximate size', () async {
        when(
          () => mockRepository.exportDatabaseToJson(),
        ).thenAnswer((_) async => '{"games": [{"id": "test"}]}');

        final imagesDir = Directory(path.join(tempDir.path, 'game_images'));
        await imagesDir.create();
        final imageFile = File(path.join(imagesDir.path, 'game_001.jpg'));
        await imageFile.writeAsString('test image data');

        when(
          () => mockStorageService.getPersistentStorageDirectory(),
        ).thenAnswer((_) async => tempDir);

        final result = await backupService.estimateBackupSize();

        expect(result, greaterThan(0));
        expect(result, lessThan(1024 * 1024));
      });

      test('should return default size on error', () async {
        when(
          () => mockRepository.exportDatabaseToJson(),
        ).thenThrow(Exception('Database error'));

        final result = await backupService.estimateBackupSize();

        expect(result, equals(10 * 1024 * 1024));
      });
    });
  });
}
