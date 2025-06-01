// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameItemImpl _$$GameItemImplFromJson(Map<String, dynamic> json) =>
    _$GameItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      platform: json['platform'] as String,
      status: $enumDecode(_$GameStatusEnumMap, json['status']),
      progress: (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$$GameItemImplToJson(_$GameItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'platform': instance.platform,
      'status': _$GameStatusEnumMap[instance.status]!,
      'progress': instance.progress,
    };

const _$GameStatusEnumMap = {
  GameStatus.playing: 'playing',
  GameStatus.completed: 'completed',
  GameStatus.backlog: 'backlog',
  GameStatus.abandoned: 'abandoned',
  GameStatus.wishlist: 'wishlist',
  GameStatus.ordered: 'ordered',
};
