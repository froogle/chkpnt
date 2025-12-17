import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:chkpnt/providers/game_provider.dart';

/// Provider for the BackupArchiveService
final backupArchiveServiceProvider = Provider<BackupArchiveService>((ref) {
  return BackupArchiveService();
});

/// Provider for the BackupValidationService
final backupValidationServiceProvider = Provider<BackupValidationService>((ref) {
  return BackupValidationService(ref.read(backupArchiveServiceProvider));
});

/// Provider for the BackupPermissionService
final backupPermissionServiceProvider = Provider<BackupPermissionService>((ref) {
  return BackupPermissionService(ref.read(storageServiceProvider));
});

/// Provider for the FullBackupService
final fullBackupServiceProvider = Provider<FullBackupService>((ref) {
  return FullBackupService(
    ref.read(gameRepositoryProvider),
    ref.read(storageServiceProvider),
    ref.read(gameImageServiceProvider),
    ref.read(guideStorageServiceProvider),
    ref.read(backupArchiveServiceProvider),
    ref.read(backupValidationServiceProvider),
    ref.read(backupPermissionServiceProvider),
  );
});

/// Exception thrown during backup/restore operations
class BackupException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const BackupException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'BackupException: $message';
}

/// Result object for backup progress with optional file path when complete
class BackupProgressResult {
  final double progress;
  final String? filePath;

  const BackupProgressResult({
    required this.progress,
    this.filePath,
  });
}

/// Service for managing complete database and image backups/restores
class FullBackupService {
  static const String _currentBackupVersion = '1.2.0';

  final GameRepository _repository;
  final StorageService _storageService;
  final GuideStorageService _guideStorageService;
  final BackupArchiveService _archiveService;
  final BackupValidationService _validationService;
  final BackupPermissionService _permissionService;

  FullBackupService(
    this._repository,
    this._storageService,
    GameImageService gameImageService,
    this._guideStorageService,
    this._archiveService,
    this._validationService,
    this._permissionService,
  );

  Future<List<File>> collectAllImages() async {
    try {
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory imageDir = Directory(
        path.join(appDir.path, 'game_images'),
      );

      if (!await imageDir.exists()) {
        debugPrint('Images directory does not exist: ${imageDir.path}');
        return [];
      }

      final List<File> imageFiles = [];
      final List<FileSystemEntity> entities = imageDir.listSync();

      for (final entity in entities) {
        if (entity is File) {
          final String fileName = path.basename(entity.path);
          final String extension = path.extension(fileName).toLowerCase();
          
          // Only include supported image extensions
          if (GameImageService.supportedExtensions.contains(extension.substring(1))) {
            imageFiles.add(entity);
          }
        }
      }

      // Sort files by name for consistent backup ordering
      imageFiles.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));

      debugPrint('Collected ${imageFiles.length} image files for backup');
      return imageFiles;
    } catch (e) {
      throw BackupException(
        'Failed to collect image files: ${e.toString()}',
        code: 'IMAGE_COLLECTION_FAILED',
        originalError: e,
      );
    }
  }

  Future<List<File>> collectAllGuides() async {
    try {
      final List<File> guideFiles = await _guideStorageService.getAllGuideFiles();
      guideFiles.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
      debugPrint('Collected ${guideFiles.length} guide files for backup');
      return guideFiles;
    } catch (e) {
      throw BackupException(
        'Failed to collect guide files: ${e.toString()}',
        code: 'GUIDE_COLLECTION_FAILED',
        originalError: e,
      );
    }
  }

  Future<BackupMetadata> createBackupMetadata(List<File> imageFiles, List<File> guideFiles) async {
    try {
      final List<GameItem> games = await _repository.getAllGames();
      final List<String> imageNames = imageFiles
          .map((file) => path.basename(file.path))
          .toList();
      final List<String> guideNames = guideFiles
          .map((file) => path.basename(file.path))
          .toList();

      return BackupMetadata(
        version: _currentBackupVersion,
        createdAt: DateTime.now(),
        gameCount: games.length,
        imageCount: imageFiles.length,
        includedImages: imageNames,
        guideCount: guideFiles.length,
        includedGuides: guideNames,
      );
    } catch (e) {
      throw BackupException(
        'Failed to create backup metadata: ${e.toString()}',
        code: 'METADATA_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  Future<BackupValidationResult> validateBackupFile(String backupFilePath) async {
    return await _validationService.validateBackupFile(backupFilePath);
  }

  String getBackupSizeString(File backupFile) {
    return _archiveService.getFileSizeString(backupFile);
  }

  Future<BackupFileInfo> getBackupFileInfo(String backupFilePath) async {
    return await _validationService.getBackupFileInfo(backupFilePath);
  }

  Future<File> createFullBackup(String destinationDirectory) async {
    try {
      final BackupData backupData = await _prepareBackupData();
      final File backupFile = await _createBackupFile(backupData, destinationDirectory);
      
      debugPrint('Created backup file: ${backupFile.path} (${getBackupSizeString(backupFile)})');
      return backupFile;
      
    } catch (e) {
      throw BackupException(
        'Failed to create backup: ${e.toString()}',
        code: 'BACKUP_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  Stream<BackupProgressResult> createFullBackupWithProgress(String destinationDirectory) async* {
    try {
      yield BackupProgressResult(progress: 0.0);

      final String databaseJson = await _repository.exportDatabaseToJson();
      yield BackupProgressResult(progress: 0.25);

      final List<File> imageFiles = await collectAllImages();
      yield BackupProgressResult(progress: 0.35);

      final List<File> guideFiles = await collectAllGuides();
      yield BackupProgressResult(progress: 0.45);

      final BackupMetadata metadata = await createBackupMetadata(imageFiles, guideFiles);
      yield BackupProgressResult(progress: 0.55);

      final BackupData backupData = BackupData(
        databaseJson: databaseJson,
        imageFiles: imageFiles,
        guideFiles: guideFiles,
        metadata: metadata,
      );
      yield BackupProgressResult(progress: 0.65);

      final File backupFile = await _createBackupFile(backupData, destinationDirectory);
      yield BackupProgressResult(progress: 1.0, filePath: backupFile.path);

      debugPrint('Created backup file: ${backupFile.path} (${getBackupSizeString(backupFile)})');

    } catch (e) {
      throw BackupException(
        'Failed to create backup: ${e.toString()}',
        code: 'BACKUP_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  Future<BackupData> _prepareBackupData() async {
    final String databaseJson = await _repository.exportDatabaseToJson();
    final List<File> imageFiles = await collectAllImages();
    final List<File> guideFiles = await collectAllGuides();
    final BackupMetadata metadata = await createBackupMetadata(imageFiles, guideFiles);

    return BackupData(
      databaseJson: databaseJson,
      imageFiles: imageFiles,
      guideFiles: guideFiles,
      metadata: metadata,
    );
  }

  Future<File> _createBackupFile(BackupData backupData, String destinationDirectory) async {
    final archive = _archiveService.createArchive(backupData);
    return await _archiveService.writeArchiveToFile(archive, destinationDirectory);
  }

  Future<BackupMetadata> _validateBackupForRestore(String backupFilePath) async {
    final BackupValidationResult validationResult = await validateBackupFile(backupFilePath);
    
    return validationResult.when(
      valid: (meta) => meta,
      invalid: (reason) => throw BackupException(
        'Invalid backup file: $reason',
        code: 'INVALID_BACKUP_FILE',
      ),
      corrupted: (details) => throw BackupException(
        'Corrupted backup file: $details',
        code: 'CORRUPTED_BACKUP_FILE',
      ),
    );
  }

  Future<void> _extractBackupFile(String backupFilePath, Directory tempDir) async {
    final File backupFile = File(backupFilePath);
    final archive = _archiveService.decodeZipFile(backupFile);
    await _archiveService.extractArchiveToDirectory(archive, tempDir);
  }

  Future<void> _performAtomicRestore(Directory tempDir, BackupMetadata metadata) async {
    await _clearCurrentData();
    await _restoreDatabase(tempDir);
    await _restoreImagesFromDirectory(tempDir);
    await _restoreGuidesFromDirectory(tempDir);
  }

  Future<void> _restoreDatabase(Directory tempDir) async {
    final File databaseFile = File(path.join(tempDir.path, 'database.json'));
    final String databaseJson = await databaseFile.readAsString();
    await _repository.importFromJson(databaseJson);
  }

  Future<void> _restoreImagesFromDirectory(Directory tempDir) async {
    final Directory imagesExtractDir = Directory(path.join(tempDir.path, 'images'));
    if (await imagesExtractDir.exists()) {
      await _restoreImages(imagesExtractDir);
    }
  }

  Future<void> _restoreGuidesFromDirectory(Directory tempDir) async {
    final Directory guidesExtractDir = Directory(path.join(tempDir.path, 'guides'));
    if (await guidesExtractDir.exists()) {
      await _restoreGuides(guidesExtractDir);
    }
  }

  Future<void> _handleRestoreFailure(dynamic error, Directory? backupStateDir) async {
    if (backupStateDir != null && await backupStateDir.exists()) {
      try {
        await _rollbackRestore(backupStateDir);
        debugPrint('Rolled back restore operation due to error');
      } catch (rollbackError) {
        debugPrint('Warning: Rollback failed: $rollbackError');
      }
    }
    
    throw BackupException(
      'Failed to restore backup: ${error.toString()}',
      code: 'RESTORE_FAILED',
      originalError: error,
    );
  }

  Future<void> _cleanupRestoreTempDirectories(Directory? tempDir, Directory? backupStateDir) async {
    if (tempDir != null) {
      await _archiveService.cleanupTempDirectory(tempDir);
    }
    if (backupStateDir != null) {
      await _archiveService.cleanupTempDirectory(backupStateDir);
    }
  }

  Future<void> restoreFromFullBackup(String backupFilePath) async {
    Directory? tempDir;
    Directory? backupStateDir;
    
    try {
      final BackupMetadata metadata = await _validateBackupForRestore(backupFilePath);
      
      tempDir = await _archiveService.createTempDirectory('chkpnt_restore');
      await _extractBackupFile(backupFilePath, tempDir);
      
      backupStateDir = await _archiveService.createTempDirectory('chkpnt_current_state');
      await _backupCurrentState(backupStateDir);
      
      await _performAtomicRestore(tempDir, metadata);
      
      debugPrint('Successfully restored backup: ${metadata.gameCount} games, ${metadata.imageCount} images');
      
    } catch (e) {
      await _handleRestoreFailure(e, backupStateDir);
    } finally {
      await _cleanupRestoreTempDirectories(tempDir, backupStateDir);
    }
  }

  Stream<double> restoreFromFullBackupWithProgress(String backupFilePath) async* {
    Directory? tempDir;
    Directory? backupStateDir;
    
    try {
      yield 0.0;
      
      final BackupMetadata metadata = await _validateBackupForRestore(backupFilePath);
      yield 0.1;
      
      tempDir = await _archiveService.createTempDirectory('chkpnt_restore');
      yield 0.2;
      
      await _extractBackupFile(backupFilePath, tempDir);
      yield 0.4;
      
      backupStateDir = await _archiveService.createTempDirectory('chkpnt_current_state');
      await _backupCurrentState(backupStateDir);
      yield 0.5;
      
      await _performAtomicRestore(tempDir, metadata);
      yield 1.0;
      
      debugPrint('Successfully restored backup: ${metadata.gameCount} games, ${metadata.imageCount} images');
      
    } catch (e) {
      await _handleRestoreFailure(e, backupStateDir);
    } finally {
      await _cleanupRestoreTempDirectories(tempDir, backupStateDir);
    }
  }


  /// Create a backup of the current state for rollback purposes
  Future<void> _backupCurrentState(Directory backupStateDir) async {
    try {
      // 1. Export current database
      final String currentDatabaseJson = await _repository.exportDatabaseToJson();
      final File currentDbFile = File(path.join(backupStateDir.path, 'current_database.json'));
      await currentDbFile.writeAsString(currentDatabaseJson);

      // 2. Backup current images
      final Directory currentImagesDir = Directory(path.join(backupStateDir.path, 'current_images'));
      await currentImagesDir.create(recursive: true);

      final List<File> currentImages = await collectAllImages();
      for (final imageFile in currentImages) {
        final String imageName = path.basename(imageFile.path);
        final File backupImageFile = File(path.join(currentImagesDir.path, imageName));
        await imageFile.copy(backupImageFile.path);
      }

      // 3. Backup current guides
      final Directory currentGuidesDir = Directory(path.join(backupStateDir.path, 'current_guides'));
      await currentGuidesDir.create(recursive: true);

      final List<File> currentGuides = await collectAllGuides();
      for (final guideFile in currentGuides) {
        final String guideName = path.basename(guideFile.path);
        final File backupGuideFile = File(path.join(currentGuidesDir.path, guideName));
        await guideFile.copy(backupGuideFile.path);
      }

      debugPrint('Backed up current state: ${currentImages.length} images, ${currentGuides.length} guides');
    } catch (e) {
      throw BackupException(
        'Failed to backup current state: ${e.toString()}',
        code: 'CURRENT_STATE_BACKUP_FAILED',
        originalError: e,
      );
    }
  }

  /// Clear current data (database, images, and guides) before restore
  Future<void> _clearCurrentData() async {
    try {
      // Clear database by importing empty JSON
      await _repository.importFromJson('{"games": [], "guides": []}');

      final Directory appDir = await _storageService.getPersistentStorageDirectory();

      // Clear images directory
      final Directory imageDir = Directory(path.join(appDir.path, 'game_images'));
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
        await imageDir.create(recursive: true);
        debugPrint('Cleared existing images directory');
      }

      // Clear guides directory
      final Directory guidesDir = Directory(path.join(appDir.path, GuideStorageService.guidesDirectory));
      if (await guidesDir.exists()) {
        await guidesDir.delete(recursive: true);
        await guidesDir.create(recursive: true);
        debugPrint('Cleared existing guides directory');
      }
    } catch (e) {
      throw BackupException(
        'Failed to clear current data: ${e.toString()}',
        code: 'DATA_CLEAR_FAILED',
        originalError: e,
      );
    }
  }

  /// Restore images from extracted backup directory
  Future<void> _restoreImages(Directory imagesExtractDir) async {
    try {
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory targetImageDir = Directory(path.join(appDir.path, 'game_images'));
      
      // Ensure target directory exists
      if (!await targetImageDir.exists()) {
        await targetImageDir.create(recursive: true);
      }

      // Copy all image files from extracted directory
      final List<FileSystemEntity> extractedImages = imagesExtractDir.listSync();
      int restoredCount = 0;

      for (final entity in extractedImages) {
        if (entity is File) {
          final String imageName = path.basename(entity.path);
          final String extension = path.extension(imageName).toLowerCase();
          
          // Only restore supported image types
          if (GameImageService.supportedExtensions.contains(extension.substring(1))) {
            final File targetImageFile = File(path.join(targetImageDir.path, imageName));
            await entity.copy(targetImageFile.path);
            restoredCount++;
          }
        }
      }

      debugPrint('Restored $restoredCount image files');
    } catch (e) {
      throw BackupException(
        'Failed to restore images: ${e.toString()}',
        code: 'IMAGE_RESTORE_FAILED',
        originalError: e,
      );
    }
  }

  /// Restore guides from extracted backup directory
  Future<void> _restoreGuides(Directory guidesExtractDir) async {
    try {
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory targetGuidesDir = Directory(
        path.join(appDir.path, GuideStorageService.guidesDirectory),
      );

      if (!await targetGuidesDir.exists()) {
        await targetGuidesDir.create(recursive: true);
      }

      final List<FileSystemEntity> extractedGuides = guidesExtractDir.listSync();
      int restoredCount = 0;

      for (final entity in extractedGuides) {
        if (entity is File && entity.path.endsWith('.json')) {
          final String guideName = path.basename(entity.path);
          final File targetGuideFile = File(path.join(targetGuidesDir.path, guideName));
          await entity.copy(targetGuideFile.path);
          restoredCount++;
        }
      }

      debugPrint('Restored $restoredCount guide files');
    } catch (e) {
      throw BackupException(
        'Failed to restore guides: ${e.toString()}',
        code: 'GUIDE_RESTORE_FAILED',
        originalError: e,
      );
    }
  }

  /// Rollback restore operation using backed up current state
  Future<void> _rollbackRestore(Directory backupStateDir) async {
    try {
      final Directory appDir = await _storageService.getPersistentStorageDirectory();

      // 1. Restore database from backup
      final File currentDbFile = File(path.join(backupStateDir.path, 'current_database.json'));
      if (await currentDbFile.exists()) {
        final String currentDatabaseJson = await currentDbFile.readAsString();
        await _repository.importFromJson(currentDatabaseJson);
      }

      // 2. Restore images from backup
      final Directory currentImagesDir = Directory(path.join(backupStateDir.path, 'current_images'));
      if (await currentImagesDir.exists()) {
        final Directory targetImageDir = Directory(path.join(appDir.path, 'game_images'));

        if (await targetImageDir.exists()) {
          await targetImageDir.delete(recursive: true);
        }
        await targetImageDir.create(recursive: true);

        final List<FileSystemEntity> backedUpImages = currentImagesDir.listSync();
        for (final entity in backedUpImages) {
          if (entity is File) {
            final String imageName = path.basename(entity.path);
            final File targetImageFile = File(path.join(targetImageDir.path, imageName));
            await entity.copy(targetImageFile.path);
          }
        }
      }

      // 3. Restore guides from backup
      final Directory currentGuidesDir = Directory(path.join(backupStateDir.path, 'current_guides'));
      if (await currentGuidesDir.exists()) {
        final Directory targetGuidesDir = Directory(
          path.join(appDir.path, GuideStorageService.guidesDirectory),
        );

        if (await targetGuidesDir.exists()) {
          await targetGuidesDir.delete(recursive: true);
        }
        await targetGuidesDir.create(recursive: true);

        final List<FileSystemEntity> backedUpGuides = currentGuidesDir.listSync();
        for (final entity in backedUpGuides) {
          if (entity is File) {
            final String guideName = path.basename(entity.path);
            final File targetGuideFile = File(path.join(targetGuidesDir.path, guideName));
            await entity.copy(targetGuideFile.path);
          }
        }
      }

      debugPrint('Successfully rolled back restore operation');
    } catch (e) {
      throw BackupException(
        'Failed to rollback restore: ${e.toString()}',
        code: 'ROLLBACK_FAILED',
        originalError: e,
      );
    }
  }

  Future<String?> getRecommendedBackupDirectory() async {
    return await _permissionService.getRecommendedBackupDirectory();
  }

  Future<String?> selectBackupDirectory() async {
    return await _permissionService.selectBackupDirectory();
  }

  Future<String?> selectBackupFile() async {
    return await _permissionService.selectBackupFile();
  }

  Future<List<BackupFileInfo>> getAvailableFullBackups(String searchDirectory) async {
    try {
      final Directory directory = Directory(searchDirectory);
      if (!await directory.exists()) {
        return [];
      }

      final List<BackupFileInfo> backupFiles = [];
      final List<FileSystemEntity> entities = directory.listSync();

      for (final entity in entities) {
        if (entity is File) {
          final String fileName = path.basename(entity.path);
          
          if (fileName.startsWith('chkpnt_backup_') && fileName.endsWith('.zip')) {
            try {
              final BackupFileInfo fileInfo = await getBackupFileInfo(entity.path);
              backupFiles.add(fileInfo);
            } catch (e) {
              debugPrint('Skipping invalid backup file $fileName: $e');
            }
          }
        }
      }

      backupFiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return backupFiles;
    } catch (e) {
      throw BackupException(
        'Failed to scan for backup files: ${e.toString()}',
        code: 'BACKUP_SCAN_FAILED',
        originalError: e,
      );
    }
  }

  Future<int?> getAvailableStorageSpace(String directoryPath) async {
    try {
      final Directory directory = Directory(directoryPath);
      if (!await directory.exists()) {
        return null;
      }
      return null;
    } catch (e) {
      debugPrint('Error checking storage space: $e');
      return null;
    }
  }

  Future<int> estimateBackupSize() async {
    try {
      int totalSize = 0;

      final String databaseJson = await _repository.exportDatabaseToJson();
      totalSize += databaseJson.length;

      final List<File> imageFiles = await collectAllImages();
      for (final imageFile in imageFiles) {
        totalSize += await imageFile.length();
      }

      totalSize += 1024;
      totalSize = (totalSize * 0.9).round();

      return totalSize;
    } catch (e) {
      return 10 * 1024 * 1024;
    }
  }

  Future<bool> isDirectoryWritable(String directoryPath) async {
    return await _permissionService.isDirectoryWritable(directoryPath);
  }

  Future<String?> exportBackupFile(String backupFilePath) async {
    return await _permissionService.exportBackupFile(backupFilePath);
  }
}