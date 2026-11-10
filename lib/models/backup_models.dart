import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_models.freezed.dart';
part 'backup_models.g.dart';

/// Metadata for backup files containing validation and version information
@freezed
abstract class BackupMetadata with _$BackupMetadata {
  const factory BackupMetadata({
    required String version,
    required DateTime createdAt,
    required int gameCount,
    required int imageCount,
    required List<String> includedImages,
    @Default(0) int guideCount,
    @Default([]) List<String> includedGuides,
  }) = _BackupMetadata;

  factory BackupMetadata.fromJson(Map<String, dynamic> json) =>
      _$BackupMetadataFromJson(json);
}

/// Result of backup file validation
@freezed
sealed class BackupValidationResult with _$BackupValidationResult {
  const factory BackupValidationResult.valid(BackupMetadata metadata) = _Valid;
  const factory BackupValidationResult.invalid(String reason) = _Invalid;
  const factory BackupValidationResult.corrupted(String details) = _Corrupted;
}

/// Progress information for backup/restore operations
@freezed
abstract class BackupProgress with _$BackupProgress {
  const factory BackupProgress({
    required double progress, // 0.0 to 1.0
    required String currentStep,
    required String? statusMessage,
  }) = _BackupProgress;

  factory BackupProgress.fromJson(Map<String, dynamic> json) =>
      _$BackupProgressFromJson(json);
}

/// Backup operation types
enum BackupOperationType { create, restore, validate }

/// Backup file information
@freezed
abstract class BackupFileInfo with _$BackupFileInfo {
  const factory BackupFileInfo({
    required String filePath,
    required String fileName,
    required int fileSizeBytes,
    required DateTime createdAt,
    BackupMetadata? metadata,
  }) = _BackupFileInfo;

  factory BackupFileInfo.fromJson(Map<String, dynamic> json) =>
      _$BackupFileInfoFromJson(json);
}
