import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chkpnt/models/backup_models.dart';
import 'package:chkpnt/services/full_backup_service.dart';

part 'backup_state_provider.freezed.dart';
part 'backup_state_provider.g.dart';

/// State representation for backup operations
@freezed
sealed class BackupOperationState with _$BackupOperationState {
  const factory BackupOperationState.idle() = _Idle;
  const factory BackupOperationState.selectingDirectory() = _SelectingDirectory;
  const factory BackupOperationState.selectingFile() = _SelectingFile;
  const factory BackupOperationState.creatingBackup({
    required double progress,
    required String currentStep,
    String? statusMessage,
  }) = _CreatingBackup;
  const factory BackupOperationState.restoringBackup({
    required double progress,
    required String currentStep,
    String? statusMessage,
  }) = _RestoringBackup;
  const factory BackupOperationState.validatingBackup({
    required String filePath,
  }) = _ValidatingBackup;
  const factory BackupOperationState.confirmingRestore({
    required String backupFilePath,
    required BackupMetadata metadata,
  }) = _ConfirmingRestore;
  const factory BackupOperationState.success({
    required String message,
    String? filePath,
  }) = _Success;
  const factory BackupOperationState.error({
    required String message,
    String? code,
    dynamic originalError,
  }) = _Error;
}

/// Riverpod state provider for backup operations
@riverpod
class BackupState extends _$BackupState {
  @override
  BackupOperationState build() => const BackupOperationState.idle();

  /// Get the backup service instance
  FullBackupService get _backupService => ref.read(fullBackupServiceProvider);

  /// Start the backup creation flow
  Future<void> startBackup() async {
    if (state is! _Idle) {
      // Cancel any ongoing operation first
      await reset();
    }

    try {
      state = const BackupOperationState.selectingDirectory();

      // Let user select backup directory
      final String? selectedDirectory =
          await _backupService.selectBackupDirectory();

      if (selectedDirectory == null) {
        // User cancelled directory selection
        state = const BackupOperationState.idle();
        return;
      }

      // Check if directory is writable
      final bool isWritable = await _backupService.isDirectoryWritable(
        selectedDirectory,
      );
      if (!isWritable) {
        state = const BackupOperationState.error(
          message:
              'Cannot write to selected directory. Please choose a different location or check app permissions.',
          code: 'DIRECTORY_NOT_WRITABLE',
        );
        return;
      }

      // Estimate backup size
      final int estimatedSize = await _backupService.estimateBackupSize();
      final String sizeString = _formatBytes(estimatedSize);

      state = BackupOperationState.creatingBackup(
        progress: 0.0,
        currentStep: 'Starting backup...',
        statusMessage: 'Estimated size: $sizeString',
      );

      // Create backup with progress tracking
      String? backupFilePath;
      await for (final result in _backupService.createFullBackupWithProgress(
        selectedDirectory,
      )) {
        if (state is! _CreatingBackup) {
          // Operation was cancelled
          return;
        }

        final String stepMessage = _getBackupStepMessage(result.progress);
        state = BackupOperationState.creatingBackup(
          progress: result.progress,
          currentStep: stepMessage,
          statusMessage:
              result.progress < 1.0 ? 'Creating backup...' : 'Backup complete!',
        );

        // Store the result when complete
        if (result.progress >= 1.0 && result.filePath != null) {
          backupFilePath = result.filePath;
        }
      }

      if (backupFilePath != null) {
        final File backupFile = File(backupFilePath);
        final String fileSize = _backupService.getBackupSizeString(backupFile);

        // On iOS, offer to export the backup file to user's chosen location
        if (Platform.isIOS) {
          state = BackupOperationState.creatingBackup(
            progress: 1.0,
            currentStep: 'Backup complete',
            statusMessage: 'Choose where to save your backup file...',
          );

          final String? exportedPath = await _backupService.exportBackupFile(
            backupFilePath,
          );
          if (exportedPath != null) {
            state = BackupOperationState.success(
              message:
                  'Backup created and saved successfully! File size: $fileSize',
              filePath: exportedPath,
            );
          } else {
            state = BackupOperationState.success(
              message:
                  'Backup created successfully! File size: $fileSize\nBackup saved to app documents.',
              filePath: backupFilePath,
            );
          }
        } else {
          state = BackupOperationState.success(
            message: 'Backup created successfully! File size: $fileSize',
            filePath: backupFilePath,
          );
        }
      } else {
        state = const BackupOperationState.error(
          message: 'Backup creation failed: No backup file was created',
          code: 'BACKUP_CREATION_FAILED',
        );
      }
    } catch (e) {
      state = BackupOperationState.error(
        message: 'Failed to create backup: ${e.toString()}',
        code: 'BACKUP_CREATION_FAILED',
        originalError: e,
      );
    }
  }

  /// Start the backup restore flow
  Future<void> startRestore() async {
    if (state is! _Idle) {
      // Cancel any ongoing operation first
      await reset();
    }

    try {
      state = const BackupOperationState.selectingFile();

      // Let user select backup file
      final String? selectedFile = await _backupService.selectBackupFile();

      if (selectedFile == null) {
        // User cancelled file selection
        state = const BackupOperationState.idle();
        return;
      }

      // Validate backup file
      state = BackupOperationState.validatingBackup(filePath: selectedFile);

      final BackupValidationResult validationResult = await _backupService
          .validateBackupFile(selectedFile);

      validationResult.when(
        valid: (metadata) {
          // Show confirmation dialog with backup details
          state = BackupOperationState.confirmingRestore(
            backupFilePath: selectedFile,
            metadata: metadata,
          );
        },
        invalid: (reason) {
          state = BackupOperationState.error(
            message: 'Invalid backup file: $reason',
            code: 'INVALID_BACKUP_FILE',
          );
        },
        corrupted: (details) {
          state = BackupOperationState.error(
            message: 'Corrupted backup file: $details',
            code: 'CORRUPTED_BACKUP_FILE',
          );
        },
      );
    } catch (e) {
      state = BackupOperationState.error(
        message: 'Failed to validate backup file: ${e.toString()}',
        code: 'BACKUP_VALIDATION_FAILED',
        originalError: e,
      );
    }
  }

  /// Confirm and execute the backup restore
  Future<void> confirmRestore(String backupFilePath) async {
    try {
      state = const BackupOperationState.restoringBackup(
        progress: 0.0,
        currentStep: 'Starting restore...',
        statusMessage: 'This will replace all current data',
      );

      // Restore backup with progress tracking
      await for (final progress in _backupService
          .restoreFromFullBackupWithProgress(backupFilePath)) {
        if (state is! _RestoringBackup) {
          // Operation was cancelled
          return;
        }

        final String stepMessage = _getRestoreStepMessage(progress);
        state = BackupOperationState.restoringBackup(
          progress: progress,
          currentStep: stepMessage,
          statusMessage:
              progress < 1.0 ? 'Restoring data...' : 'Restore complete!',
        );
      }

      state = const BackupOperationState.success(
        message: 'Backup restored successfully! All data has been restored.',
      );
    } catch (e) {
      state = BackupOperationState.error(
        message: 'Failed to restore backup: ${e.toString()}',
        code: 'BACKUP_RESTORE_FAILED',
        originalError: e,
      );
    }
  }

  /// Cancel the current operation and reset to idle state
  Future<void> reset() async {
    state = const BackupOperationState.idle();
  }

  /// Dismiss error or success state and return to idle
  void dismissMessage() {
    if (state is _Success || state is _Error) {
      state = const BackupOperationState.idle();
    }
  }

  /// Get appropriate step message based on backup progress
  String _getBackupStepMessage(double progress) {
    if (progress < 0.1) return 'Preparing backup...';
    if (progress < 0.3) return 'Exporting database...';
    if (progress < 0.4) return 'Collecting images...';
    if (progress < 0.5) return 'Creating metadata...';
    if (progress < 0.7) return 'Building archive...';
    if (progress < 0.9) return 'Compressing data...';
    if (progress < 1.0) return 'Finalising backup...';
    return 'Backup complete!';
  }

  /// Get appropriate step message based on restore progress
  String _getRestoreStepMessage(double progress) {
    if (progress < 0.1) return 'Validating backup...';
    if (progress < 0.4) return 'Extracting files...';
    if (progress < 0.5) return 'Backing up current state...';
    if (progress < 0.6) return 'Clearing existing data...';
    if (progress < 0.8) return 'Restoring database...';
    if (progress < 1.0) return 'Restoring images...';
    return 'Restore complete!';
  }

  /// Format bytes into human-readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
