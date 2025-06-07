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
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$$GameItemImplToJson(_$GameItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'platform': instance.platform,
      'status': _$GameStatusEnumMap[instance.status]!,
      'imagePath': instance.imagePath,
    };

const _$GameStatusEnumMap = {
  GameStatus.playing: 'playing',
  GameStatus.completed: 'completed',
  GameStatus.backlog: 'backlog',
  GameStatus.abandoned: 'abandoned',
  GameStatus.wishlist: 'wishlist',
  GameStatus.ordered: 'ordered',
};
