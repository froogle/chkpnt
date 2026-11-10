// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupMetadata _$BackupMetadataFromJson(Map<String, dynamic> json) =>
    _BackupMetadata(
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      gameCount: (json['gameCount'] as num).toInt(),
      imageCount: (json['imageCount'] as num).toInt(),
      includedImages: (json['includedImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      guideCount: (json['guideCount'] as num?)?.toInt() ?? 0,
      includedGuides:
          (json['includedGuides'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BackupMetadataToJson(_BackupMetadata instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
      'gameCount': instance.gameCount,
      'imageCount': instance.imageCount,
      'includedImages': instance.includedImages,
      'guideCount': instance.guideCount,
      'includedGuides': instance.includedGuides,
    };

_BackupProgress _$BackupProgressFromJson(Map<String, dynamic> json) =>
    _BackupProgress(
      progress: (json['progress'] as num).toDouble(),
      currentStep: json['currentStep'] as String,
      statusMessage: json['statusMessage'] as String?,
    );

Map<String, dynamic> _$BackupProgressToJson(_BackupProgress instance) =>
    <String, dynamic>{
      'progress': instance.progress,
      'currentStep': instance.currentStep,
      'statusMessage': instance.statusMessage,
    };

_BackupFileInfo _$BackupFileInfoFromJson(Map<String, dynamic> json) =>
    _BackupFileInfo(
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] == null
          ? null
          : BackupMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BackupFileInfoToJson(_BackupFileInfo instance) =>
    <String, dynamic>{
      'filePath': instance.filePath,
      'fileName': instance.fileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'createdAt': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata,
    };
