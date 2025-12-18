// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuideIdImpl _$$GuideIdImplFromJson(Map<String, dynamic> json) =>
    _$GuideIdImpl(json['value'] as String);

Map<String, dynamic> _$$GuideIdImplToJson(_$GuideIdImpl instance) =>
    <String, dynamic>{'value': instance.value};

_$GuideItemImpl _$$GuideItemImplFromJson(Map<String, dynamic> json) =>
    _$GuideItemImpl(
      id: GuideId.fromJson(json['id'] as Map<String, dynamic>),
      gameId: GameId.fromJson(json['gameId'] as Map<String, dynamic>),
      title: json['title'] as String,
      author: json['author'] as String,
      fileName: json['fileName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastReadSection: (json['lastReadSection'] as num?)?.toInt() ?? 0,
      lastReadBlock: (json['lastReadBlock'] as num?)?.toInt() ?? 0,
      sourceUrl: json['sourceUrl'] as String?,
      hasSeenAttribution: json['hasSeenAttribution'] as bool? ?? false,
    );

Map<String, dynamic> _$$GuideItemImplToJson(_$GuideItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'title': instance.title,
      'author': instance.author,
      'fileName': instance.fileName,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastReadSection': instance.lastReadSection,
      'lastReadBlock': instance.lastReadBlock,
      'sourceUrl': instance.sourceUrl,
      'hasSeenAttribution': instance.hasSeenAttribution,
    };
