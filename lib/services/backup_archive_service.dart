import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:chkpnt/models/backup_models.dart';

class BackupData {
  final String databaseJson;
  final List<File> imageFiles;
  final BackupMetadata metadata;

  const BackupData({
    required this.databaseJson,
    required this.imageFiles,
    required this.metadata,
  });
}

class BackupArchiveService {
  static const String metadataFileName = 'metadata.json';
  static const String databaseFileName = 'database.json';
  static const String imagesDirectoryName = 'images';

  Archive createArchive(BackupData backupData) {
    final Archive archive = Archive();

    _addMetadataToArchive(archive, backupData.metadata);
    _addDatabaseToArchive(archive, backupData.databaseJson);
    _addImagesToArchive(archive, backupData.imageFiles);

    return archive;
  }

  void _addMetadataToArchive(Archive archive, BackupMetadata metadata) {
    final String metadataJson = json.encode(metadata.toJson());
    archive.addFile(ArchiveFile(
      metadataFileName,
      metadataJson.length,
      utf8.encode(metadataJson),
    ));
  }

  void _addDatabaseToArchive(Archive archive, String databaseJson) {
    archive.addFile(ArchiveFile(
      databaseFileName,
      databaseJson.length,
      utf8.encode(databaseJson),
    ));
  }

  void _addImagesToArchive(Archive archive, List<File> imageFiles) {
    for (final imageFile in imageFiles) {
      final String imageName = path.basename(imageFile.path);
      final Uint8List imageBytes = imageFile.readAsBytesSync();
      archive.addFile(ArchiveFile(
        '$imagesDirectoryName/$imageName',
        imageBytes.length,
        imageBytes,
      ));
    }
  }

  Future<File> writeArchiveToFile(Archive archive, String destinationDirectory) async {
    final Uint8List zipData = Uint8List.fromList(ZipEncoder().encode(archive)!);
    final String backupFileName = _generateBackupFileName();
    final File backupFile = File(path.join(destinationDirectory, backupFileName));
    
    await backupFile.writeAsBytes(zipData);
    return backupFile;
  }

  String _generateBackupFileName() {
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    return 'chkpnt_backup_$timestamp.zip';
  }

  Archive decodeZipFile(File backupFile) {
    try {
      final Uint8List zipBytes = backupFile.readAsBytesSync();
      return ZipDecoder().decodeBytes(zipBytes);
    } catch (e) {
      throw Exception('Not a valid ZIP file: ${e.toString()}');
    }
  }

  Future<void> extractArchiveToDirectory(Archive archive, Directory targetDirectory) async {
    for (final ArchiveFile file in archive.files) {
      if (file.isFile) {
        await _extractSingleFile(file, targetDirectory);
      }
    }
  }

  Future<void> _extractSingleFile(ArchiveFile file, Directory targetDirectory) async {
    final File extractedFile = File(path.join(targetDirectory.path, file.name));
    await extractedFile.parent.create(recursive: true);
    await extractedFile.writeAsBytes(file.content as List<int>);
  }

  String getFileSizeString(File file) {
    try {
      final int bytes = file.lengthSync();
      return _formatFileSize(bytes);
    } catch (e) {
      debugPrint('Failed to get backup file size: $e');
      return 'Unknown size';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  List<String> getArchiveImageFileNames(Archive archive) {
    return archive.files
        .where((file) => file.name.startsWith('$imagesDirectoryName/') && file.isFile)
        .map((file) => path.basename(file.name))
        .toList();
  }

  ArchiveFile? findFileInArchive(Archive archive, String fileName) {
    return archive.findFile(fileName);
  }

  Future<Directory> createTempDirectory(String prefix) async {
    final Directory systemTemp = Directory.systemTemp;
    final String tempDirName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
    final Directory tempDir = Directory(path.join(systemTemp.path, tempDirName));
    await tempDir.create(recursive: true);
    return tempDir;
  }

  Future<void> cleanupTempDirectory(Directory tempDir) async {
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        debugPrint('Cleaned up temporary directory: ${tempDir.path}');
      }
    } catch (e) {
      debugPrint('Warning: Failed to clean up temporary directory: $e');
    }
  }
}