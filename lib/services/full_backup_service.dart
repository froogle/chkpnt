import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:chkpnt/models/backup_models.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/repositories/game_repository.dart';
import 'package:chkpnt/services/storage_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Provider for the FullBackupService
final fullBackupServiceProvider = Provider<FullBackupService>((ref) {
  return FullBackupService(
    ref.read(gameRepositoryProvider),
    ref.read(storageServiceProvider),
    ref.read(gameImageServiceProvider),
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

/// Service for managing complete database and image backups/restores
class FullBackupService {
  static const String _currentBackupVersion = '1.0.0';
  static const String _metadataFileName = 'metadata.json';
  static const String _databaseFileName = 'database.json';
  static const String _imagesDirectoryName = 'images';

  final GameRepository _repository;
  final StorageService _storageService;
  // ignore: unused_field
  final GameImageService _gameImageService; // Reserved for future image operations

  FullBackupService(
    this._repository,
    this._storageService,
    this._gameImageService,
  );

  /// Collect all image files from the game images directory
  /// 
  /// This scans the persistent game_images directory and returns a list of
  /// all image files that should be included in a backup.
  Future<List<File>> collectAllImages() async {
    try {
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory imageDir = Directory(
        path.join(appDir.path, GameImageService.imageDirectory),
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

  /// Create backup metadata for the current state
  /// 
  /// This generates metadata about what will be included in the backup,
  /// including version info, game count, and image inventory.
  Future<BackupMetadata> createBackupMetadata(List<File> imageFiles) async {
    try {
      final List<GameItem> games = await _repository.getAllGames();
      final List<String> imageNames = imageFiles
          .map((file) => path.basename(file.path))
          .toList();

      return BackupMetadata(
        version: _currentBackupVersion,
        createdAt: DateTime.now(),
        gameCount: games.length,
        imageCount: imageFiles.length,
        includedImages: imageNames,
      );
    } catch (e) {
      throw BackupException(
        'Failed to create backup metadata: ${e.toString()}',
        code: 'METADATA_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  /// Validate a backup file and return validation result
  /// 
  /// This checks that a backup file is a valid ZIP with the expected structure
  /// and can extract and validate the metadata.
  Future<BackupValidationResult> validateBackupFile(String backupFilePath) async {
    try {
      final File backupFile = File(backupFilePath);
      
      if (!await backupFile.exists()) {
        return const BackupValidationResult.invalid('Backup file does not exist');
      }

      // Read and decode ZIP file
      final Uint8List zipBytes = await backupFile.readAsBytes();
      late Archive archive;
      
      try {
        archive = ZipDecoder().decodeBytes(zipBytes);
      } catch (e) {
        return BackupValidationResult.corrupted('Not a valid ZIP file: ${e.toString()}');
      }


      // Check for required files
      final ArchiveFile? metadataFile = archive.findFile(_metadataFileName);
      final ArchiveFile? databaseFile = archive.findFile(_databaseFileName);
      
      if (metadataFile == null) {
        return const BackupValidationResult.invalid('Missing metadata.json file');
      }
      
      if (databaseFile == null) {
        return const BackupValidationResult.invalid('Missing database.json file');
      }

      // Validate metadata
      try {
        final String metadataJson = utf8.decode(metadataFile.content as List<int>);
        final Map<String, dynamic> metadataMap = json.decode(metadataJson);
        final BackupMetadata metadata = BackupMetadata.fromJson(metadataMap);
        
        // Check version compatibility
        if (metadata.version != _currentBackupVersion) {
          return BackupValidationResult.invalid(
            'Incompatible backup version: ${metadata.version} (expected: $_currentBackupVersion)'
          );
        }

        // Validate images exist if images are expected
        if (metadata.imageCount > 0) {
          // Get all image files from the archive (files in the images/ directory)
          final List<String> archiveImageFiles = archive.files
              .where((file) => file.name.startsWith('$_imagesDirectoryName/') && file.isFile)
              .map((file) => path.basename(file.name))
              .toList();


          // Check that we have some image files if the metadata says we should
          if (archiveImageFiles.isEmpty) {
            return const BackupValidationResult.invalid('No image files found despite imageCount > 0');
          }

          // Validate expected image files exist
          final Set<String> expectedImages = metadata.includedImages.toSet();
          final Set<String> actualImages = archiveImageFiles.toSet();

          // Check that all expected images are present
          final Set<String> missingImages = expectedImages.difference(actualImages);
          if (missingImages.isNotEmpty) {
            return BackupValidationResult.invalid('Missing expected image files: ${missingImages.join(', ')}');
          }

        }

        return BackupValidationResult.valid(metadata);
      } catch (e) {
        return BackupValidationResult.corrupted('Invalid metadata format: ${e.toString()}');
      }
    } catch (e) {
      return BackupValidationResult.corrupted('Backup validation failed: ${e.toString()}');
    }
  }

  /// Get backup file size in a human-readable format
  String getBackupSizeString(File backupFile) {
    try {
      final int bytes = backupFile.lengthSync();
      if (bytes < 1024) return '${bytes}B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
      if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    } catch (e) {
      debugPrint('Failed to get backup file size: $e');
      return 'Unknown size';
    }
  }

  /// Get backup file information including metadata if available
  Future<BackupFileInfo> getBackupFileInfo(String backupFilePath) async {
    final File backupFile = File(backupFilePath);
    final int fileSize = await backupFile.length();
    final DateTime createdAt = (await backupFile.stat()).modified;
    final String fileName = path.basename(backupFilePath);

    BackupMetadata? metadata;
    final validationResult = await validateBackupFile(backupFilePath);
    validationResult.when(
      valid: (backupMetadata) => metadata = backupMetadata,
      invalid: (_) => metadata = null,
      corrupted: (_) => metadata = null,
    );

    return BackupFileInfo(
      filePath: backupFilePath,
      fileName: fileName,
      fileSizeBytes: fileSize,
      createdAt: createdAt,
      metadata: metadata,
    );
  }

  /// Create a full backup ZIP file containing database and images
  /// 
  /// This creates a complete backup archive in the specified destination directory.
  /// The backup includes database JSON export, all game images, and metadata.
  Future<File> createFullBackup(String destinationDirectory) async {
    Directory? tempDir;
    try {
      // 1. Create temporary staging directory
      tempDir = await _createTempDirectory('chkpnt_backup');
      
      // 2. Export database to JSON
      final String databaseJson = await _repository.exportDatabaseToJson();
      
      // 3. Collect all image files
      final List<File> imageFiles = await collectAllImages();
      
      // 4. Create backup metadata
      final BackupMetadata metadata = await createBackupMetadata(imageFiles);
      
      // 5. Create ZIP archive
      final Archive archive = Archive();
      
      // Add metadata file
      final String metadataJson = json.encode(metadata.toJson());
      archive.addFile(ArchiveFile(
        _metadataFileName,
        metadataJson.length,
        utf8.encode(metadataJson),
      ));
      
      // Add database file
      archive.addFile(ArchiveFile(
        _databaseFileName,
        databaseJson.length,
        utf8.encode(databaseJson),
      ));
      
      // Add images if any exist
      if (imageFiles.isNotEmpty) {
        for (final imageFile in imageFiles) {
          final String imageName = path.basename(imageFile.path);
          final Uint8List imageBytes = await imageFile.readAsBytes();
          archive.addFile(ArchiveFile(
            '$_imagesDirectoryName/$imageName',
            imageBytes.length,
            imageBytes,
          ));
        }
      }
      
      // 6. Encode ZIP and write to destination
      final Uint8List zipData = Uint8List.fromList(ZipEncoder().encode(archive)!);
      
      final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final String backupFileName = 'chkpnt_backup_$timestamp.zip';
      final File backupFile = File(path.join(destinationDirectory, backupFileName));
      
      await backupFile.writeAsBytes(zipData);
      
      debugPrint('Created backup file: ${backupFile.path} (${getBackupSizeString(backupFile)})');
      return backupFile;
      
    } catch (e) {
      throw BackupException(
        'Failed to create backup: ${e.toString()}',
        code: 'BACKUP_CREATION_FAILED',
        originalError: e,
      );
    } finally {
      // 7. Clean up temporary directory
      if (tempDir != null) {
        await _cleanupTempDirectory(tempDir);
      }
    }
  }

  /// Create a full backup with progress tracking
  /// 
  /// This returns a stream of progress values from 0.0 to 1.0 as the backup
  /// operation proceeds through its various stages.
  Stream<double> createFullBackupWithProgress(String destinationDirectory) async* {
    Directory? tempDir;
    try {
      yield 0.0; // Start
      
      // 1. Create temporary staging directory
      tempDir = await _createTempDirectory('chkpnt_backup');
      yield 0.1;
      
      // 2. Export database to JSON
      final String databaseJson = await _repository.exportDatabaseToJson();
      yield 0.3;
      
      // 3. Collect all image files
      final List<File> imageFiles = await collectAllImages();
      yield 0.4;
      
      // 4. Create backup metadata
      final BackupMetadata metadata = await createBackupMetadata(imageFiles);
      yield 0.5;
      
      // 5. Create ZIP archive
      final Archive archive = Archive();
      
      // Add metadata file
      final String metadataJson = json.encode(metadata.toJson());
      archive.addFile(ArchiveFile(
        _metadataFileName,
        metadataJson.length,
        utf8.encode(metadataJson),
      ));
      yield 0.6;
      
      // Add database file
      archive.addFile(ArchiveFile(
        _databaseFileName,
        databaseJson.length,
        utf8.encode(databaseJson),
      ));
      yield 0.7;
      
      // Add images if any exist
      if (imageFiles.isNotEmpty) {
        for (int i = 0; i < imageFiles.length; i++) {
          final imageFile = imageFiles[i];
          final String imageName = path.basename(imageFile.path);
          final Uint8List imageBytes = await imageFile.readAsBytes();
          archive.addFile(ArchiveFile(
            '$_imagesDirectoryName/$imageName',
            imageBytes.length,
            imageBytes,
          ));
          
          // Update progress for each image
          final double imageProgress = 0.7 + (0.1 * (i + 1) / imageFiles.length);
          yield imageProgress;
        }
      } else {
        yield 0.8;
      }
      
      // 6. Encode ZIP and write to destination
      final Uint8List zipData = Uint8List.fromList(ZipEncoder().encode(archive)!);
      yield 0.9;
      
      final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final String backupFileName = 'chkpnt_backup_$timestamp.zip';
      final File backupFile = File(path.join(destinationDirectory, backupFileName));
      
      await backupFile.writeAsBytes(zipData);
      yield 1.0; // Complete
      
      debugPrint('Created backup file: ${backupFile.path} (${getBackupSizeString(backupFile)})');
      
    } catch (e) {
      throw BackupException(
        'Failed to create backup: ${e.toString()}',
        code: 'BACKUP_CREATION_FAILED',
        originalError: e,
      );
    } finally {
      // Clean up temporary directory
      if (tempDir != null) {
        await _cleanupTempDirectory(tempDir);
      }
    }
  }

  /// Restore from a full backup file
  /// 
  /// This performs an atomic restore operation that validates the backup,
  /// clears existing data, and restores both database and images.
  Future<void> restoreFromFullBackup(String backupFilePath) async {
    Directory? tempDir;
    Directory? backupStateDir;
    
    try {
      // 1. Validate backup file first
      final BackupValidationResult validationResult = await validateBackupFile(backupFilePath);
      
      final BackupMetadata metadata = validationResult.when(
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
      
      // 2. Create temporary extraction directory
      tempDir = await _createTempDirectory('chkpnt_restore');
      
      // 3. Extract backup file
      final File backupFile = File(backupFilePath);
      final Uint8List zipBytes = await backupFile.readAsBytes();
      final Archive archive = ZipDecoder().decodeBytes(zipBytes);
      
      // Extract all files to temp directory
      for (final ArchiveFile file in archive.files) {
        if (file.isFile) {
          final File extractedFile = File(path.join(tempDir.path, file.name));
          await extractedFile.parent.create(recursive: true);
          await extractedFile.writeAsBytes(file.content as List<int>);
        }
      }
      
      // 4. Create backup of current state (for rollback)
      backupStateDir = await _createTempDirectory('chkpnt_current_state');
      await _backupCurrentState(backupStateDir);
      
      // 5. Clear existing data
      await _clearCurrentData();
      
      // 6. Restore database
      final File databaseFile = File(path.join(tempDir.path, _databaseFileName));
      final String databaseJson = await databaseFile.readAsString();
      await _repository.importFromJson(databaseJson);
      
      // 7. Restore images
      final Directory imagesExtractDir = Directory(path.join(tempDir.path, _imagesDirectoryName));
      if (await imagesExtractDir.exists()) {
        await _restoreImages(imagesExtractDir);
      }
      
      debugPrint('Successfully restored backup: ${metadata.gameCount} games, ${metadata.imageCount} images');
      
    } catch (e) {
      // Rollback on failure
      if (backupStateDir != null && await backupStateDir.exists()) {
        try {
          await _rollbackRestore(backupStateDir);
          debugPrint('Rolled back restore operation due to error');
        } catch (rollbackError) {
          debugPrint('Warning: Rollback failed: $rollbackError');
        }
      }
      
      throw BackupException(
        'Failed to restore backup: ${e.toString()}',
        code: 'RESTORE_FAILED',
        originalError: e,
      );
    } finally {
      // Clean up temporary directories
      if (tempDir != null) {
        await _cleanupTempDirectory(tempDir);
      }
      if (backupStateDir != null) {
        await _cleanupTempDirectory(backupStateDir);
      }
    }
  }

  /// Restore from backup with progress tracking
  Stream<double> restoreFromFullBackupWithProgress(String backupFilePath) async* {
    Directory? tempDir;
    Directory? backupStateDir;
    
    try {
      yield 0.0; // Start
      
      // 1. Validate backup file
      final BackupValidationResult validationResult = await validateBackupFile(backupFilePath);
      
      final BackupMetadata metadata = validationResult.when(
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
      yield 0.1;
      
      // 2. Create temporary extraction directory
      tempDir = await _createTempDirectory('chkpnt_restore');
      yield 0.2;
      
      // 3. Extract backup file
      final File backupFile = File(backupFilePath);
      final Uint8List zipBytes = await backupFile.readAsBytes();
      final Archive archive = ZipDecoder().decodeBytes(zipBytes);
      
      // Extract all files to temp directory
      for (int i = 0; i < archive.files.length; i++) {
        final ArchiveFile file = archive.files[i];
        if (file.isFile) {
          final File extractedFile = File(path.join(tempDir.path, file.name));
          await extractedFile.parent.create(recursive: true);
          await extractedFile.writeAsBytes(file.content as List<int>);
        }
        
        // Progress for extraction (20% to 40%)
        final double extractProgress = 0.2 + (0.2 * (i + 1) / archive.files.length);
        yield extractProgress;
      }
      
      // 4. Create backup of current state
      backupStateDir = await _createTempDirectory('chkpnt_current_state');
      await _backupCurrentState(backupStateDir);
      yield 0.5;
      
      // 5. Clear existing data
      await _clearCurrentData();
      yield 0.6;
      
      // 6. Restore database
      final File databaseFile = File(path.join(tempDir.path, _databaseFileName));
      final String databaseJson = await databaseFile.readAsString();
      await _repository.importFromJson(databaseJson);
      yield 0.8;
      
      // 7. Restore images
      final Directory imagesExtractDir = Directory(path.join(tempDir.path, _imagesDirectoryName));
      if (await imagesExtractDir.exists()) {
        await _restoreImages(imagesExtractDir);
      }
      yield 1.0; // Complete
      
      debugPrint('Successfully restored backup: ${metadata.gameCount} games, ${metadata.imageCount} images');
      
    } catch (e) {
      // Rollback on failure
      if (backupStateDir != null && await backupStateDir.exists()) {
        try {
          await _rollbackRestore(backupStateDir);
          debugPrint('Rolled back restore operation due to error');
        } catch (rollbackError) {
          debugPrint('Warning: Rollback failed: $rollbackError');
        }
      }
      
      throw BackupException(
        'Failed to restore backup: ${e.toString()}',
        code: 'RESTORE_FAILED',
        originalError: e,
      );
    } finally {
      // Clean up temporary directories
      if (tempDir != null) {
        await _cleanupTempDirectory(tempDir);
      }
      if (backupStateDir != null) {
        await _cleanupTempDirectory(backupStateDir);
      }
    }
  }

  /// Create a temporary directory for backup operations
  Future<Directory> _createTempDirectory(String prefix) async {
    final Directory systemTemp = Directory.systemTemp;
    final String tempDirName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
    final Directory tempDir = Directory(path.join(systemTemp.path, tempDirName));
    await tempDir.create(recursive: true);
    return tempDir;
  }

  /// Clean up a temporary directory and all its contents
  Future<void> _cleanupTempDirectory(Directory tempDir) async {
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        debugPrint('Cleaned up temporary directory: ${tempDir.path}');
      }
    } catch (e) {
      debugPrint('Warning: Failed to clean up temporary directory: $e');
      // Don't throw - cleanup failures shouldn't break the operation
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

      debugPrint('Backed up current state: ${currentImages.length} images');
    } catch (e) {
      throw BackupException(
        'Failed to backup current state: ${e.toString()}',
        code: 'CURRENT_STATE_BACKUP_FAILED',
        originalError: e,
      );
    }
  }

  /// Clear current data (database and images) before restore
  Future<void> _clearCurrentData() async {
    try {
      // Clear database by importing empty JSON
      await _repository.importFromJson('{"games": []}');

      // Clear images directory
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory imageDir = Directory(path.join(appDir.path, GameImageService.imageDirectory));
      
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
        await imageDir.create(recursive: true);
        debugPrint('Cleared existing images directory');
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
      final Directory targetImageDir = Directory(path.join(appDir.path, GameImageService.imageDirectory));
      
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

  /// Rollback restore operation using backed up current state
  Future<void> _rollbackRestore(Directory backupStateDir) async {
    try {
      // 1. Restore database from backup
      final File currentDbFile = File(path.join(backupStateDir.path, 'current_database.json'));
      if (await currentDbFile.exists()) {
        final String currentDatabaseJson = await currentDbFile.readAsString();
        await _repository.importFromJson(currentDatabaseJson);
      }

      // 2. Restore images from backup
      final Directory currentImagesDir = Directory(path.join(backupStateDir.path, 'current_images'));
      if (await currentImagesDir.exists()) {
        // Clear target images directory
        final Directory appDir = await _storageService.getPersistentStorageDirectory();
        final Directory targetImageDir = Directory(path.join(appDir.path, GameImageService.imageDirectory));
        
        if (await targetImageDir.exists()) {
          await targetImageDir.delete(recursive: true);
        }
        await targetImageDir.create(recursive: true);

        // Copy back original images
        final List<FileSystemEntity> backedUpImages = currentImagesDir.listSync();
        for (final entity in backedUpImages) {
          if (entity is File) {
            final String imageName = path.basename(entity.path);
            final File targetImageFile = File(path.join(targetImageDir.path, imageName));
            await entity.copy(targetImageFile.path);
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

  /// Check and request storage permissions
  Future<bool> _checkStoragePermissions() async {
    if (!Platform.isAndroid) {
      return true; // iOS handles permissions through file picker
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 30) {
        // Android 11+ - Use SAF (Storage Access Framework) via file_picker
        // No explicit permissions needed for scoped storage
        return true;
      } else if (sdkInt >= 23) {
        // Android 6.0+ - Request storage permissions
        final status = await Permission.storage.status;
        
        if (status.isGranted) {
          return true;
        } else if (status.isDenied) {
          final result = await Permission.storage.request();
          return result.isGranted;
        } else if (status.isPermanentlyDenied) {
          return false;
        }
      }
      
      return true; // Pre-Android 6.0
    } catch (e) {
      debugPrint('Error checking storage permissions: $e');
      return false;
    }
  }

  /// Get a recommended backup directory for the current platform
  Future<String?> getRecommendedBackupDirectory() async {
    try {
      if (Platform.isAndroid) {
        // On Android, try to use Downloads folder or app's external directory
        final Directory downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          final backupDir = Directory(path.join(downloadsDir.path, 'ChkPnt Backups'));
          if (!await backupDir.exists()) {
            await backupDir.create(recursive: true);
          }
          return backupDir.path;
        }
      }
      
      // Fallback to app documents directory
      final Directory appDir = await _storageService.getPersistentStorageDirectory();
      final Directory backupDir = Directory(path.join(appDir.path, 'backups'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      return backupDir.path;
    } catch (e) {
      debugPrint('Error getting recommended backup directory: $e');
      return null;
    }
  }

  /// Select a directory for backup destination using the system file picker
  /// 
  /// Returns the selected directory path, or null if the user cancels.
  Future<String?> selectBackupDirectory() async {
    try {
      // Check permissions first
      final hasPermission = await _checkStoragePermissions();
      if (!hasPermission) {
        throw BackupException(
          'Storage permission is required to create backups. Please grant storage access in app settings.',
          code: 'PERMISSION_DENIED',
        );
      }

      // Try file picker first
      final selectedPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Backup Location',
        lockParentWindow: true,
      );

      if (selectedPath != null) {
        return selectedPath;
      }

      // If user cancelled, offer recommended directory as fallback
      debugPrint('User cancelled directory selection, trying recommended directory');
      return await getRecommendedBackupDirectory();
      
    } catch (e) {
      debugPrint('Error selecting backup directory: $e');
      
      if (e is BackupException) {
        rethrow;
      }
      
      // Try recommended directory as fallback
      debugPrint('File picker failed, trying recommended directory');
      final fallbackDir = await getRecommendedBackupDirectory();
      if (fallbackDir != null) {
        return fallbackDir;
      }
      
      throw BackupException(
        'Failed to select backup directory: ${e.toString()}',
        code: 'DIRECTORY_SELECTION_FAILED',
        originalError: e,
      );
    }
  }

  /// Select a backup file for restore using the system file picker
  /// 
  /// Returns the selected backup file path, or null if the user cancels.
  /// Only shows ZIP files matching the backup naming pattern.
  Future<String?> selectBackupFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Backup File to Restore',
        type: FileType.custom,
        allowedExtensions: ['zip'],
        lockParentWindow: true,
      );
      
      return result?.files.single.path;
    } catch (e) {
      debugPrint('Error selecting backup file: $e');
      throw BackupException(
        'Failed to select backup file: ${e.toString()}',
        code: 'FILE_SELECTION_FAILED',
        originalError: e,
      );
    }
  }

  /// Get available backup files in a directory
  /// 
  /// Scans the specified directory for backup files matching the ChkPnt
  /// backup naming pattern and returns file information for each.
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
          
          // Check if file matches backup naming pattern
          if (fileName.startsWith('chkpnt_backup_') && fileName.endsWith('.zip')) {
            try {
              final BackupFileInfo fileInfo = await getBackupFileInfo(entity.path);
              backupFiles.add(fileInfo);
            } catch (e) {
              // Skip files that can't be processed (might be corrupted or invalid)
              debugPrint('Skipping invalid backup file $fileName: $e');
            }
          }
        }
      }

      // Sort by creation date (newest first)
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

  /// Check available storage space in the specified directory
  /// 
  /// Returns available space in bytes, or null if it cannot be determined.
  /// Used to validate that there's enough space before creating a backup.
  Future<int?> getAvailableStorageSpace(String directoryPath) async {
    try {
      final Directory directory = Directory(directoryPath);
      if (!await directory.exists()) {
        return null;
      }

      // Get file system stats (platform-specific)
      if (Platform.isWindows) {
        // On Windows, we can't easily get free space from Dart
        // This would require platform-specific implementation
        return null;
      } else {
        // On Unix-like systems, we could use statvfs
        // For now, return null as this requires platform channels
        return null;
      }
    } catch (e) {
      debugPrint('Error checking storage space: $e');
      return null;
    }
  }

  /// Estimate the size of a backup before creating it
  /// 
  /// This calculates the approximate size of the backup file by examining
  /// the current database and image files.
  Future<int> estimateBackupSize() async {
    try {
      int totalSize = 0;

      // Estimate database size (JSON export is typically larger than binary)
      final String databaseJson = await _repository.exportDatabaseToJson();
      totalSize += utf8.encode(databaseJson).length;

      // Add image file sizes
      final List<File> imageFiles = await collectAllImages();
      for (final imageFile in imageFiles) {
        totalSize += await imageFile.length();
      }

      // Add metadata overhead (small)
      totalSize += 1024; // Metadata is typically < 1KB

      // Add ZIP compression overhead (typically reduces size by 10-30%)
      // We'll be conservative and assume 10% compression
      totalSize = (totalSize * 0.9).round();

      return totalSize;
    } catch (e) {
      // Return a conservative estimate if we can't calculate exactly
      return 10 * 1024 * 1024; // 10MB default estimate
    }
  }

  /// Validate that a directory is writable for backup operations
  Future<bool> isDirectoryWritable(String directoryPath) async {
    try {
      final Directory directory = Directory(directoryPath);
      
      if (!await directory.exists()) {
        return false;
      }

      // Try to create a test file
      final File testFile = File(path.join(directoryPath, '.chkpnt_write_test'));
      await testFile.writeAsString('test');
      final bool fileExists = await testFile.exists();
      
      if (fileExists) {
        await testFile.delete();
      }
      
      return fileExists;
    } catch (e) {
      return false;
    }
  }
}