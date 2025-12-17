// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GuideId _$GuideIdFromJson(Map<String, dynamic> json) {
  return _GuideId.fromJson(json);
}

/// @nodoc
mixin _$GuideId {
  String get value => throw _privateConstructorUsedError;

  /// Serializes this GuideId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuideId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuideIdCopyWith<GuideId> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideIdCopyWith<$Res> {
  factory $GuideIdCopyWith(GuideId value, $Res Function(GuideId) then) =
      _$GuideIdCopyWithImpl<$Res, GuideId>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$GuideIdCopyWithImpl<$Res, $Val extends GuideId>
    implements $GuideIdCopyWith<$Res> {
  _$GuideIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuideId
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
abstract class _$$GuideIdImplCopyWith<$Res> implements $GuideIdCopyWith<$Res> {
  factory _$$GuideIdImplCopyWith(
    _$GuideIdImpl value,
    $Res Function(_$GuideIdImpl) then,
  ) = __$$GuideIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$GuideIdImplCopyWithImpl<$Res>
    extends _$GuideIdCopyWithImpl<$Res, _$GuideIdImpl>
    implements _$$GuideIdImplCopyWith<$Res> {
  __$$GuideIdImplCopyWithImpl(
    _$GuideIdImpl _value,
    $Res Function(_$GuideIdImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuideId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null}) {
    return _then(
      _$GuideIdImpl(
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
class _$GuideIdImpl implements _GuideId {
  const _$GuideIdImpl(this.value);

  factory _$GuideIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuideIdImplFromJson(json);

  @override
  final String value;

  @override
  String toString() {
    return 'GuideId(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideIdImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  /// Create a copy of GuideId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideIdImplCopyWith<_$GuideIdImpl> get copyWith =>
      __$$GuideIdImplCopyWithImpl<_$GuideIdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuideIdImplToJson(this);
  }
}

abstract class _GuideId implements GuideId {
  const factory _GuideId(final String value) = _$GuideIdImpl;

  factory _GuideId.fromJson(Map<String, dynamic> json) = _$GuideIdImpl.fromJson;

  @override
  String get value;

  /// Create a copy of GuideId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideIdImplCopyWith<_$GuideIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GuideItem _$GuideItemFromJson(Map<String, dynamic> json) {
  return _GuideItem.fromJson(json);
}

/// @nodoc
mixin _$GuideItem {
  GuideId get id => throw _privateConstructorUsedError;
  GameId get gameId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get lastReadSection => throw _privateConstructorUsedError;
  int get lastReadBlock => throw _privateConstructorUsedError;

  /// Serializes this GuideItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuideItemCopyWith<GuideItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuideItemCopyWith<$Res> {
  factory $GuideItemCopyWith(GuideItem value, $Res Function(GuideItem) then) =
      _$GuideItemCopyWithImpl<$Res, GuideItem>;
  @useResult
  $Res call({
    GuideId id,
    GameId gameId,
    String title,
    String author,
    String fileName,
    DateTime createdAt,
    int lastReadSection,
    int lastReadBlock,
  });

  $GuideIdCopyWith<$Res> get id;
  $GameIdCopyWith<$Res> get gameId;
}

/// @nodoc
class _$GuideItemCopyWithImpl<$Res, $Val extends GuideItem>
    implements $GuideItemCopyWith<$Res> {
  _$GuideItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? title = null,
    Object? author = null,
    Object? fileName = null,
    Object? createdAt = null,
    Object? lastReadSection = null,
    Object? lastReadBlock = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as GuideId,
            gameId:
                null == gameId
                    ? _value.gameId
                    : gameId // ignore: cast_nullable_to_non_nullable
                        as GameId,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            author:
                null == author
                    ? _value.author
                    : author // ignore: cast_nullable_to_non_nullable
                        as String,
            fileName:
                null == fileName
                    ? _value.fileName
                    : fileName // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            lastReadSection:
                null == lastReadSection
                    ? _value.lastReadSection
                    : lastReadSection // ignore: cast_nullable_to_non_nullable
                        as int,
            lastReadBlock:
                null == lastReadBlock
                    ? _value.lastReadBlock
                    : lastReadBlock // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GuideIdCopyWith<$Res> get id {
    return $GuideIdCopyWith<$Res>(_value.id, (value) {
      return _then(_value.copyWith(id: value) as $Val);
    });
  }

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameIdCopyWith<$Res> get gameId {
    return $GameIdCopyWith<$Res>(_value.gameId, (value) {
      return _then(_value.copyWith(gameId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GuideItemImplCopyWith<$Res>
    implements $GuideItemCopyWith<$Res> {
  factory _$$GuideItemImplCopyWith(
    _$GuideItemImpl value,
    $Res Function(_$GuideItemImpl) then,
  ) = __$$GuideItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GuideId id,
    GameId gameId,
    String title,
    String author,
    String fileName,
    DateTime createdAt,
    int lastReadSection,
    int lastReadBlock,
  });

  @override
  $GuideIdCopyWith<$Res> get id;
  @override
  $GameIdCopyWith<$Res> get gameId;
}

/// @nodoc
class __$$GuideItemImplCopyWithImpl<$Res>
    extends _$GuideItemCopyWithImpl<$Res, _$GuideItemImpl>
    implements _$$GuideItemImplCopyWith<$Res> {
  __$$GuideItemImplCopyWithImpl(
    _$GuideItemImpl _value,
    $Res Function(_$GuideItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameId = null,
    Object? title = null,
    Object? author = null,
    Object? fileName = null,
    Object? createdAt = null,
    Object? lastReadSection = null,
    Object? lastReadBlock = null,
  }) {
    return _then(
      _$GuideItemImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as GuideId,
        gameId:
            null == gameId
                ? _value.gameId
                : gameId // ignore: cast_nullable_to_non_nullable
                    as GameId,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        author:
            null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                    as String,
        fileName:
            null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        lastReadSection:
            null == lastReadSection
                ? _value.lastReadSection
                : lastReadSection // ignore: cast_nullable_to_non_nullable
                    as int,
        lastReadBlock:
            null == lastReadBlock
                ? _value.lastReadBlock
                : lastReadBlock // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GuideItemImpl implements _GuideItem {
  const _$GuideItemImpl({
    required this.id,
    required this.gameId,
    required this.title,
    required this.author,
    required this.fileName,
    required this.createdAt,
    this.lastReadSection = 0,
    this.lastReadBlock = 0,
  });

  factory _$GuideItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuideItemImplFromJson(json);

  @override
  final GuideId id;
  @override
  final GameId gameId;
  @override
  final String title;
  @override
  final String author;
  @override
  final String fileName;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int lastReadSection;
  @override
  @JsonKey()
  final int lastReadBlock;

  @override
  String toString() {
    return 'GuideItem(id: $id, gameId: $gameId, title: $title, author: $author, fileName: $fileName, createdAt: $createdAt, lastReadSection: $lastReadSection, lastReadBlock: $lastReadBlock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuideItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastReadSection, lastReadSection) ||
                other.lastReadSection == lastReadSection) &&
            (identical(other.lastReadBlock, lastReadBlock) ||
                other.lastReadBlock == lastReadBlock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    gameId,
    title,
    author,
    fileName,
    createdAt,
    lastReadSection,
    lastReadBlock,
  );

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuideItemImplCopyWith<_$GuideItemImpl> get copyWith =>
      __$$GuideItemImplCopyWithImpl<_$GuideItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuideItemImplToJson(this);
  }
}

abstract class _GuideItem implements GuideItem {
  const factory _GuideItem({
    required final GuideId id,
    required final GameId gameId,
    required final String title,
    required final String author,
    required final String fileName,
    required final DateTime createdAt,
    final int lastReadSection,
    final int lastReadBlock,
  }) = _$GuideItemImpl;

  factory _GuideItem.fromJson(Map<String, dynamic> json) =
      _$GuideItemImpl.fromJson;

  @override
  GuideId get id;
  @override
  GameId get gameId;
  @override
  String get title;
  @override
  String get author;
  @override
  String get fileName;
  @override
  DateTime get createdAt;
  @override
  int get lastReadSection;
  @override
  int get lastReadBlock;

  /// Create a copy of GuideItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuideItemImplCopyWith<_$GuideItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
