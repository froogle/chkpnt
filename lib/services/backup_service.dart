import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:chkpnt/repositories/game_repository.dart';

/// Service for managing database backups and data protection
class BackupService {
  final GameRepository _repository;

  BackupService(this._repository);

  /// Create a timestamped backup file
  Future<File> createBackup() async {
    final jsonData = await _repository.exportDatabaseToJson();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

    final documentsDir = await getApplicationDocumentsDirectory();
    final backupFile = File(
      '${documentsDir.path}/chkpnt_backup_$timestamp.json',
    );

    await backupFile.writeAsString(jsonData);
    return backupFile;
  }

  /// Restore from a backup file
  Future<void> restoreFromBackup(File backupFile) async {
    if (!await backupFile.exists()) {
      throw Exception('Backup file does not exist');
    }

    final jsonData = await backupFile.readAsString();
    await _repository.importFromJson(jsonData);
  }

  /// List all available backup files
  Future<List<File>> getAvailableBackups() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final files =
        documentsDir
            .listSync()
            .whereType<File>()
            .where((file) => file.path.contains('chkpnt_backup_'))
            .toList();

    // Sort by creation date (newest first)
    files.sort(
      (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
    );
    return files;
  }

  /// Create automatic backup if needed (e.g., daily)
  Future<void> createAutomaticBackupIfNeeded() async {
    final backups = await getAvailableBackups();

    if (backups.isEmpty) {
      // No backups exist, create one
      await createBackup();
      return;
    }

    final latestBackup = backups.first;
    final lastBackupTime = latestBackup.statSync().modified;
    final daysSinceLastBackup =
        DateTime.now().difference(lastBackupTime).inDays;

    if (daysSinceLastBackup >= 1) {
      // Create backup if it's been a day since last one
      await createBackup();

      // Clean up old backups (keep only last 7)
      if (backups.length > 7) {
        for (int i = 7; i < backups.length; i++) {
          await backups[i].delete();
        }
      }
    }
  }

  /// Get backup file size in a human-readable format
  String getBackupSizeString(File backup) {
    final bytes = backup.lengthSync();
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
