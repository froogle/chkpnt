import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;
import 'package:chkpnt/models/backup_models.dart';
import 'package:chkpnt/services/backup_archive_service.dart';

class BackupValidationService {
  static const String currentBackupVersion = '1.2.0';
  static const List<String> compatibleVersions = ['1.0.0', '1.1.0', '1.2.0'];

  final BackupArchiveService _archiveService;

  BackupValidationService(this._archiveService);

  Future<BackupValidationResult> validateBackupFile(String backupFilePath) async {
    final File backupFile = File(backupFilePath);
    
    if (!await backupFile.exists()) {
      return const BackupValidationResult.invalid('Backup file does not exist');
    }

    final Archive archive = _decodeZipArchive(backupFile);
    if (archive.isEmpty) {
      return const BackupValidationResult.corrupted('Failed to decode ZIP archive');
    }

    final BackupValidationResult requiredFilesResult = _validateRequiredFiles(archive);
    if (requiredFilesResult.when(
        valid: (_) => false,
        invalid: (_) => true,
        corrupted: (_) => true,
      )) {
      return requiredFilesResult;
    }

    return _validateMetadataAndImages(archive);
  }

  Archive _decodeZipArchive(File backupFile) {
    try {
      return _archiveService.decodeZipFile(backupFile);
    } catch (e) {
      return Archive();
    }
  }

  BackupValidationResult _validateRequiredFiles(Archive archive) {
    final ArchiveFile? metadataFile = _archiveService.findFileInArchive(
      archive, 
      BackupArchiveService.metadataFileName,
    );
    final ArchiveFile? databaseFile = _archiveService.findFileInArchive(
      archive,
      BackupArchiveService.databaseFileName,
    );
    
    if (metadataFile == null) {
      return const BackupValidationResult.invalid('Missing metadata.json file');
    }
    
    if (databaseFile == null) {
      return const BackupValidationResult.invalid('Missing database.json file');
    }

    return BackupValidationResult.valid(BackupMetadata(
      version: '',
      createdAt: DateTime.now(),
      gameCount: 0,
      imageCount: 0,
      includedImages: const [],
    ));
  }

  BackupValidationResult _validateMetadataAndImages(Archive archive) {
    try {
      final ArchiveFile metadataFile = _archiveService.findFileInArchive(
        archive,
        BackupArchiveService.metadataFileName,
      )!;
      
      final BackupMetadata metadata = _parseMetadataFile(metadataFile);
      final BackupValidationResult versionResult = _validateVersion(metadata);
      
      if (versionResult.when(
          valid: (_) => false,
          invalid: (_) => true,
          corrupted: (_) => true,
        )) {
        return versionResult;
      }

      return _validateImageFiles(archive, metadata);
    } catch (e) {
      return BackupValidationResult.corrupted('Invalid metadata format: ${e.toString()}');
    }
  }

  BackupMetadata _parseMetadataFile(ArchiveFile metadataFile) {
    final String metadataJson = utf8.decode(metadataFile.content as List<int>);
    final Map<String, dynamic> metadataMap = json.decode(metadataJson);
    return BackupMetadata.fromJson(metadataMap);
  }

  BackupValidationResult _validateVersion(BackupMetadata metadata) {
    if (!compatibleVersions.contains(metadata.version)) {
      return BackupValidationResult.invalid(
        'Incompatible backup version: ${metadata.version} (supported: ${compatibleVersions.join(", ")})'
      );
    }
    return BackupValidationResult.valid(metadata);
  }

  BackupValidationResult _validateImageFiles(Archive archive, BackupMetadata metadata) {
    if (metadata.imageCount == 0) {
      return BackupValidationResult.valid(metadata);
    }

    final List<String> archiveImageFiles = _archiveService.getArchiveImageFileNames(archive);
    
    if (archiveImageFiles.isEmpty) {
      return const BackupValidationResult.invalid('No image files found despite imageCount > 0');
    }

    return _validateExpectedImages(archiveImageFiles, metadata);
  }

  BackupValidationResult _validateExpectedImages(List<String> archiveImageFiles, BackupMetadata metadata) {
    final Set<String> expectedImages = metadata.includedImages.toSet();
    final Set<String> actualImages = archiveImageFiles.toSet();
    final Set<String> missingImages = expectedImages.difference(actualImages);

    if (missingImages.isNotEmpty) {
      return BackupValidationResult.invalid('Missing expected image files: ${missingImages.join(', ')}');
    }

    return BackupValidationResult.valid(metadata);
  }

  Future<BackupFileInfo> getBackupFileInfo(String backupFilePath) async {
    final File backupFile = File(backupFilePath);
    final int fileSize = await backupFile.length();
    final DateTime createdAt = (await backupFile.stat()).modified;
    final String fileName = path.basename(backupFilePath);

    final BackupValidationResult validationResult = await validateBackupFile(backupFilePath);
    BackupMetadata? metadata = validationResult.when(
      valid: (backupMetadata) => backupMetadata,
      invalid: (_) => null,
      corrupted: (_) => null,
    );

    return BackupFileInfo(
      filePath: backupFilePath,
      fileName: fileName,
      fileSizeBytes: fileSize,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}