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

GameId _$GameIdFromJson(Map<String, dynamic> json) {
  return _GameId.fromJson(json);
}

/// @nodoc
mixin _$GameId {
  String get value => throw _privateConstructorUsedError;

  /// Serializes this GameId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameIdCopyWith<GameId> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameIdCopyWith<$Res> {
  factory $GameIdCopyWith(GameId value, $Res Function(GameId) then) =
      _$GameIdCopyWithImpl<$Res, GameId>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$GameIdCopyWithImpl<$Res, $Val extends GameId>
    implements $GameIdCopyWith<$Res> {
  _$GameIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _value.copyWith(
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameIdImplCopyWith<$Res> implements $GameIdCopyWith<$Res> {
  factory _$$GameIdImplCopyWith(
    _$GameIdImpl value,
    $Res Function(_$GameIdImpl) then,
  ) = __$$GameIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$GameIdImplCopyWithImpl<$Res>
    extends _$GameIdCopyWithImpl<$Res, _$GameIdImpl>
    implements _$$GameIdImplCopyWith<$Res> {
  __$$GameIdImplCopyWithImpl(
    _$GameIdImpl _value,
    $Res Function(_$GameIdImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _$GameIdImpl(
        null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameIdImpl implements _GameId {
  const _$GameIdImpl(this.value);

  factory _$GameIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameIdImplFromJson(json);

  @override
  final String value;

  @override
  String toString() {
    return 'GameId(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameIdImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of GameId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameIdImplCopyWith<_$GameIdImpl> get copyWith =>
      __$$GameIdImplCopyWithImpl<_$GameIdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameIdImplToJson(this);
  }
}

abstract class _GameId implements GameId {
  const factory _GameId(final String value) = _$GameIdImpl;

  factory _GameId.fromJson(Map<String, dynamic> json) = _$GameIdImpl.fromJson;

  @override
  String get value;

  /// Create a copy of GameId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameIdImplCopyWith<_$GameIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameItem _$GameItemFromJson(Map<String, dynamic> json) {
  return _GameItem.fromJson(json);
}

/// @nodoc
mixin _$GameItem {
  GameId get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  DateTime get lastStatusChange => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get remoteImageUrl => throw _privateConstructorUsedError;
  bool get isPhysical => throw _privateConstructorUsedError;

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
    GameId id,
    String title,
    String platform,
    GameStatus status,
    DateTime lastModified,
    DateTime lastStatusChange,
    String? imagePath,
    String? remoteImageUrl,
    bool isPhysical,
  });

  $GameIdCopyWith<$Res> get id;
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
    Object? lastModified = null,
    Object? lastStatusChange = null,
    Object? imagePath = freezed,
    Object? remoteImageUrl = freezed,
    Object? isPhysical = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as GameId,
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
            lastModified:
                null == lastModified
                    ? _value.lastModified
                    : lastModified // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastStatusChange:
                null == lastStatusChange
                    ? _value.lastStatusChange
                    : lastStatusChange // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            imagePath:
                freezed == imagePath
                    ? _value.imagePath
                    : imagePath // ignore: cast_nullable_to_non_nullable
                        as String?,
            remoteImageUrl:
                freezed == remoteImageUrl
                    ? _value.remoteImageUrl
                    : remoteImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            isPhysical:
                null == isPhysical
                    ? _value.isPhysical
                    : isPhysical // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameIdCopyWith<$Res> get id {
    return $GameIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
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
    GameId id,
    String title,
    String platform,
    GameStatus status,
    DateTime lastModified,
    DateTime lastStatusChange,
    String? imagePath,
    String? remoteImageUrl,
    bool isPhysical,
  });

  @override
  $GameIdCopyWith<$Res> get id;
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
    Object? lastModified = null,
    Object? lastStatusChange = null,
    Object? imagePath = freezed,
    Object? remoteImageUrl = freezed,
    Object? isPhysical = null,
  }) {
    return _then(
      _$GameItemImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as GameId,
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
        lastModified:
            null == lastModified
                ? _value.lastModified
                : lastModified // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastStatusChange:
            null == lastStatusChange
                ? _value.lastStatusChange
                : lastStatusChange // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        imagePath:
            freezed == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                    as String?,
        remoteImageUrl:
            freezed == remoteImageUrl
                ? _value.remoteImageUrl
                : remoteImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        isPhysical:
            null == isPhysical
                ? _value.isPhysical
                : isPhysical // ignore: cast_nullable_to_non_nullable
                    as bool,
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
    required this.lastModified,
    required this.lastStatusChange,
    this.imagePath,
    this.remoteImageUrl,
    this.isPhysical = false,
  });

  factory _$GameItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameItemImplFromJson(json);

  @override
  final GameId id;
  @override
  final String title;
  @override
  final String platform;
  @override
  final GameStatus status;
  @override
  final DateTime lastModified;
  @override
  final DateTime lastStatusChange;
  @override
  final String? imagePath;
  @override
  final String? remoteImageUrl;
  @override
  @JsonKey()
  final bool isPhysical;

  @override
  String toString() {
    return 'GameItem(id: $id, title: $title, platform: $platform, status: $status, lastModified: $lastModified, lastStatusChange: $lastStatusChange, imagePath: $imagePath, remoteImageUrl: $remoteImageUrl, isPhysical: $isPhysical)';
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
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.lastStatusChange, lastStatusChange) ||
                other.lastStatusChange == lastStatusChange) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.remoteImageUrl, remoteImageUrl) ||
                other.remoteImageUrl == remoteImageUrl) &&
            (identical(other.isPhysical, isPhysical) ||
                other.isPhysical == isPhysical));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    platform,
    status,
    lastModified,
    lastStatusChange,
    imagePath,
    remoteImageUrl,
    isPhysical,
  );

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
    required final GameId id,
    required final String title,
    required final String platform,
    required final GameStatus status,
    required final DateTime lastModified,
    required final DateTime lastStatusChange,
    final String? imagePath,
    final String? remoteImageUrl,
    final bool isPhysical,
  }) = _$GameItemImpl;

  factory _GameItem.fromJson(Map<String, dynamic> json) =
      _$GameItemImpl.fromJson;

  @override
  GameId get id;
  @override
  String get title;
  @override
  String get platform;
  @override
  GameStatus get status;
  @override
  DateTime get lastModified;
  @override
  DateTime get lastStatusChange;
  @override
  String? get imagePath;
  @override
  String? get remoteImageUrl;
  @override
  bool get isPhysical;

  /// Create a copy of GameItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameItemImplCopyWith<_$GameItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
