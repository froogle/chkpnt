// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameIdImpl _$$GameIdImplFromJson(Map<String, dynamic> json) =>
    _$GameIdImpl(json['value'] as String);

Map<String, dynamic> _$$GameIdImplToJson(_$GameIdImpl instance) =>
    <String, dynamic>{'value': instance.value};

_$GameItemImpl _$$GameItemImplFromJson(Map<String, dynamic> json) =>
    _$GameItemImpl(
      id: GameId.fromJson(json['id'] as Map<String, dynamic>),
      title: json['title'] as String,
      platform: json['platform'] as String,
      status: $enumDecode(_$GameStatusEnumMap, json['status']),
      lastModified: DateTime.parse(json['lastModified'] as String),
      lastStatusChange: DateTime.parse(json['lastStatusChange'] as String),
      imagePath: json['imagePath'] as String?,
      remoteImageUrl: json['remoteImageUrl'] as String?,
    );

Map<String, dynamic> _$$GameItemImplToJson(_$GameItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'platform': instance.platform,
      'status': _$GameStatusEnumMap[instance.status]!,
      'lastModified': instance.lastModified.toIso8601String(),
      'lastStatusChange': instance.lastStatusChange.toIso8601String(),
      'imagePath': instance.imagePath,
      'remoteImageUrl': instance.remoteImageUrl,
    };

const _$GameStatusEnumMap = {
  GameStatus.playing: 'playing',
  GameStatus.completed: 'completed',
  GameStatus.backlog: 'backlog',
  GameStatus.abandoned: 'abandoned',
  GameStatus.wishlist: 'wishlist',
  GameStatus.ordered: 'ordered',
  GameStatus.ongoing: 'ongoing',
};
