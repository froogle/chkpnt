// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameItem _$GameItemFromJson(Map<String, dynamic> json) {
  return _GameItem.fromJson(json);
}

/// @nodoc
mixin _$GameItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;

  /// Serializes this GameItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameItemCopyWith<GameItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameItemCopyWith<$Res> {
  factory $GameItemCopyWith(GameItem value, $Res Function(GameItem) then) =
      _$GameItemCopyWithImpl<$Res, GameItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String platform,
    GameStatus status,
    double progress,
  });
}

/// @nodoc
class _$GameItemCopyWithImpl<$Res, $Val extends GameItem>
    implements $GameItemCopyWith<$Res> {
  _$GameItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? platform = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            platform:
                null == platform
                    ? _value.platform
                    : platform // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as GameStatus,
            progress:
                null == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameItemImplCopyWith<$Res>
    implements $GameItemCopyWith<$Res> {
  factory _$$GameItemImplCopyWith(
    _$GameItemImpl value,
    $Res Function(_$GameItemImpl) then,
  ) = __$$GameItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String platform,
    GameStatus status,
    double progress,
  });
}

/// @nodoc
class __$$GameItemImplCopyWithImpl<$Res>
    extends _$GameItemCopyWithImpl<$Res, _$GameItemImpl>
    implements _$$GameItemImplCopyWith<$Res> {
  __$$GameItemImplCopyWithImpl(
    _$GameItemImpl _value,
    $Res Function(_$GameItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? platform = null,
    Object? status = null,
    Object? progress = null,
  }) {
    return _then(
      _$GameItemImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        platform:
            null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as GameStatus,
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameItemImpl implements _GameItem {
  const _$GameItemImpl({
    required this.id,
    required this.title,
    required this.platform,
    required this.status,
    required this.progress,
  });

  factory _$GameItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String platform;
  @override
  final GameStatus status;
  @override
  final double progress;

  @override
  String toString() {
    return 'GameItem(id: $id, title: $title, platform: $platform, status: $status, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, platform, status, progress);

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      __$$GameItemImplCopyWithImpl<_$GameItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameItemImplToJson(this);
  }
}

abstract class _GameItem implements GameItem {
  const factory _GameItem({
    required final String id,
    required final String title,
    required final String platform,
    required final GameStatus status,
    required final double progress,
  }) = _$GameItemImpl;

  factory _GameItem.fromJson(Map<String, dynamic> json) =
      _$GameItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get platform;
  @override
  GameStatus get status;
  @override
  double get progress;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
