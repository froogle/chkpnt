// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BackupMetadata _$BackupMetadataFromJson(Map<String, dynamic> json) {
  return _BackupMetadata.fromJson(json);
}

/// @nodoc
mixin _$BackupMetadata {
  String get version => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get gameCount => throw _privateConstructorUsedError;
  int get imageCount => throw _privateConstructorUsedError;
  List<String> get includedImages => throw _privateConstructorUsedError;
  int get guideCount => throw _privateConstructorUsedError;
  List<String> get includedGuides => throw _privateConstructorUsedError;

  /// Serializes this BackupMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupMetadataCopyWith<BackupMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupMetadataCopyWith<$Res> {
  factory $BackupMetadataCopyWith(
    BackupMetadata value,
    $Res Function(BackupMetadata) then,
  ) = _$BackupMetadataCopyWithImpl<$Res, BackupMetadata>;
  @useResult
  $Res call({
    String version,
    DateTime createdAt,
    int gameCount,
    int imageCount,
    List<String> includedImages,
    int guideCount,
    List<String> includedGuides,
  });
}

/// @nodoc
class _$BackupMetadataCopyWithImpl<$Res, $Val extends BackupMetadata>
    implements $BackupMetadataCopyWith<$Res> {
  _$BackupMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? createdAt = null,
    Object? gameCount = null,
    Object? imageCount = null,
    Object? includedImages = null,
    Object? guideCount = null,
    Object? includedGuides = null,
  }) {
    return _then(
      _value.copyWith(
            version:
                null == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            gameCount:
                null == gameCount
                    ? _value.gameCount
                    : gameCount // ignore: cast_nullable_to_non_nullable
                        as int,
            imageCount:
                null == imageCount
                    ? _value.imageCount
                    : imageCount // ignore: cast_nullable_to_non_nullable
                        as int,
            includedImages:
                null == includedImages
                    ? _value.includedImages
                    : includedImages // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            guideCount:
                null == guideCount
                    ? _value.guideCount
                    : guideCount // ignore: cast_nullable_to_non_nullable
                        as int,
            includedGuides:
                null == includedGuides
                    ? _value.includedGuides
                    : includedGuides // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BackupMetadataImplCopyWith<$Res>
    implements $BackupMetadataCopyWith<$Res> {
  factory _$$BackupMetadataImplCopyWith(
    _$BackupMetadataImpl value,
    $Res Function(_$BackupMetadataImpl) then,
  ) = __$$BackupMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String version,
    DateTime createdAt,
    int gameCount,
    int imageCount,
    List<String> includedImages,
    int guideCount,
    List<String> includedGuides,
  });
}

/// @nodoc
class __$$BackupMetadataImplCopyWithImpl<$Res>
    extends _$BackupMetadataCopyWithImpl<$Res, _$BackupMetadataImpl>
    implements _$$BackupMetadataImplCopyWith<$Res> {
  __$$BackupMetadataImplCopyWithImpl(
    _$BackupMetadataImpl _value,
    $Res Function(_$BackupMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? createdAt = null,
    Object? gameCount = null,
    Object? imageCount = null,
    Object? includedImages = null,
    Object? guideCount = null,
    Object? includedGuides = null,
  }) {
    return _then(
      _$BackupMetadataImpl(
        version:
            null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        gameCount:
            null == gameCount
                ? _value.gameCount
                : gameCount // ignore: cast_nullable_to_non_nullable
                    as int,
        imageCount:
            null == imageCount
                ? _value.imageCount
                : imageCount // ignore: cast_nullable_to_non_nullable
                    as int,
        includedImages:
            null == includedImages
                ? _value._includedImages
                : includedImages // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        guideCount:
            null == guideCount
                ? _value.guideCount
                : guideCount // ignore: cast_nullable_to_non_nullable
                    as int,
        includedGuides:
            null == includedGuides
                ? _value._includedGuides
                : includedGuides // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupMetadataImpl implements _BackupMetadata {
  const _$BackupMetadataImpl({
    required this.version,
    required this.createdAt,
    required this.gameCount,
    required this.imageCount,
    required final List<String> includedImages,
    this.guideCount = 0,
    final List<String> includedGuides = const [],
  }) : _includedImages = includedImages,
       _includedGuides = includedGuides;

  factory _$BackupMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupMetadataImplFromJson(json);

  @override
  final String version;
  @override
  final DateTime createdAt;
  @override
  final int gameCount;
  @override
  final int imageCount;
  final List<String> _includedImages;
  @override
  List<String> get includedImages {
    if (_includedImages is EqualUnmodifiableListView) return _includedImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_includedImages);
  }

  @override
  @JsonKey()
  final int guideCount;
  final List<String> _includedGuides;
  @override
  @JsonKey()
  List<String> get includedGuides {
    if (_includedGuides is EqualUnmodifiableListView) return _includedGuides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_includedGuides);
  }

  @override
  String toString() {
    return 'BackupMetadata(version: $version, createdAt: $createdAt, gameCount: $gameCount, imageCount: $imageCount, includedImages: $includedImages, guideCount: $guideCount, includedGuides: $includedGuides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupMetadataImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.gameCount, gameCount) ||
                other.gameCount == gameCount) &&
            (identical(other.imageCount, imageCount) ||
                other.imageCount == imageCount) &&
            const DeepCollectionEquality().equals(
              other._includedImages,
              _includedImages,
            ) &&
            (identical(other.guideCount, guideCount) ||
                other.guideCount == guideCount) &&
            const DeepCollectionEquality().equals(
              other._includedGuides,
              _includedGuides,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    version,
    createdAt,
    gameCount,
    imageCount,
    const DeepCollectionEquality().hash(_includedImages),
    guideCount,
    const DeepCollectionEquality().hash(_includedGuides),
  );

  /// Create a copy of BackupMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupMetadataImplCopyWith<_$BackupMetadataImpl> get copyWith =>
      __$$BackupMetadataImplCopyWithImpl<_$BackupMetadataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupMetadataImplToJson(this);
  }
}

abstract class _BackupMetadata implements BackupMetadata {
  const factory _BackupMetadata({
    required final String version,
    required final DateTime createdAt,
    required final int gameCount,
    required final int imageCount,
    required final List<String> includedImages,
    final int guideCount,
    final List<String> includedGuides,
  }) = _$BackupMetadataImpl;

  factory _BackupMetadata.fromJson(Map<String, dynamic> json) =
      _$BackupMetadataImpl.fromJson;

  @override
  String get version;
  @override
  DateTime get createdAt;
  @override
  int get gameCount;
  @override
  int get imageCount;
  @override
  List<String> get includedImages;
  @override
  int get guideCount;
  @override
  List<String> get includedGuides;

  /// Create a copy of BackupMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupMetadataImplCopyWith<_$BackupMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BackupValidationResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BackupMetadata metadata) valid,
    required TResult Function(String reason) invalid,
    required TResult Function(String details) corrupted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BackupMetadata metadata)? valid,
    TResult? Function(String reason)? invalid,
    TResult? Function(String details)? corrupted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BackupMetadata metadata)? valid,
    TResult Function(String reason)? invalid,
    TResult Function(String details)? corrupted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
    required TResult Function(_Corrupted value) corrupted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
    TResult? Function(_Corrupted value)? corrupted,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    TResult Function(_Corrupted value)? corrupted,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupValidationResultCopyWith<$Res> {
  factory $BackupValidationResultCopyWith(
    BackupValidationResult value,
    $Res Function(BackupValidationResult) then,
  ) = _$BackupValidationResultCopyWithImpl<$Res, BackupValidationResult>;
}

/// @nodoc
class _$BackupValidationResultCopyWithImpl<
  $Res,
  $Val extends BackupValidationResult
>
    implements $BackupValidationResultCopyWith<$Res> {
  _$BackupValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ValidImplCopyWith<$Res> {
  factory _$$ValidImplCopyWith(
    _$ValidImpl value,
    $Res Function(_$ValidImpl) then,
  ) = __$$ValidImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BackupMetadata metadata});

  $BackupMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$ValidImplCopyWithImpl<$Res>
    extends _$BackupValidationResultCopyWithImpl<$Res, _$ValidImpl>
    implements _$$ValidImplCopyWith<$Res> {
  __$$ValidImplCopyWithImpl(
    _$ValidImpl _value,
    $Res Function(_$ValidImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? metadata = null}) {
    return _then(
      _$ValidImpl(
        null == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                as BackupMetadata,
      ),
    );
  }

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackupMetadataCopyWith<$Res> get metadata {
    return $BackupMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value));
    });
  }
}

/// @nodoc

class _$ValidImpl implements _Valid {
  const _$ValidImpl(this.metadata);

  @override
  final BackupMetadata metadata;

  @override
  String toString() {
    return 'BackupValidationResult.valid(metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidImpl &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, metadata);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidImplCopyWith<_$ValidImpl> get copyWith =>
      __$$ValidImplCopyWithImpl<_$ValidImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BackupMetadata metadata) valid,
    required TResult Function(String reason) invalid,
    required TResult Function(String details) corrupted,
  }) {
    return valid(metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BackupMetadata metadata)? valid,
    TResult? Function(String reason)? invalid,
    TResult? Function(String details)? corrupted,
  }) {
    return valid?.call(metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BackupMetadata metadata)? valid,
    TResult Function(String reason)? invalid,
    TResult Function(String details)? corrupted,
    required TResult orElse(),
  }) {
    if (valid != null) {
      return valid(metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
    required TResult Function(_Corrupted value) corrupted,
  }) {
    return valid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
    TResult? Function(_Corrupted value)? corrupted,
  }) {
    return valid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    TResult Function(_Corrupted value)? corrupted,
    required TResult orElse(),
  }) {
    if (valid != null) {
      return valid(this);
    }
    return orElse();
  }
}

abstract class _Valid implements BackupValidationResult {
  const factory _Valid(final BackupMetadata metadata) = _$ValidImpl;

  BackupMetadata get metadata;

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidImplCopyWith<_$ValidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidImplCopyWith<$Res> {
  factory _$$InvalidImplCopyWith(
    _$InvalidImpl value,
    $Res Function(_$InvalidImpl) then,
  ) = __$$InvalidImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$InvalidImplCopyWithImpl<$Res>
    extends _$BackupValidationResultCopyWithImpl<$Res, _$InvalidImpl>
    implements _$$InvalidImplCopyWith<$Res> {
  __$$InvalidImplCopyWithImpl(
    _$InvalidImpl _value,
    $Res Function(_$InvalidImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = null}) {
    return _then(
      _$InvalidImpl(
        null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$InvalidImpl implements _Invalid {
  const _$InvalidImpl(this.reason);

  @override
  final String reason;

  @override
  String toString() {
    return 'BackupValidationResult.invalid(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidImplCopyWith<_$InvalidImpl> get copyWith =>
      __$$InvalidImplCopyWithImpl<_$InvalidImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BackupMetadata metadata) valid,
    required TResult Function(String reason) invalid,
    required TResult Function(String details) corrupted,
  }) {
    return invalid(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BackupMetadata metadata)? valid,
    TResult? Function(String reason)? invalid,
    TResult? Function(String details)? corrupted,
  }) {
    return invalid?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BackupMetadata metadata)? valid,
    TResult Function(String reason)? invalid,
    TResult Function(String details)? corrupted,
    required TResult orElse(),
  }) {
    if (invalid != null) {
      return invalid(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
    required TResult Function(_Corrupted value) corrupted,
  }) {
    return invalid(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
    TResult? Function(_Corrupted value)? corrupted,
  }) {
    return invalid?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    TResult Function(_Corrupted value)? corrupted,
    required TResult orElse(),
  }) {
    if (invalid != null) {
      return invalid(this);
    }
    return orElse();
  }
}

abstract class _Invalid implements BackupValidationResult {
  const factory _Invalid(final String reason) = _$InvalidImpl;

  String get reason;

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidImplCopyWith<_$InvalidImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CorruptedImplCopyWith<$Res> {
  factory _$$CorruptedImplCopyWith(
    _$CorruptedImpl value,
    $Res Function(_$CorruptedImpl) then,
  ) = __$$CorruptedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String details});
}

/// @nodoc
class __$$CorruptedImplCopyWithImpl<$Res>
    extends _$BackupValidationResultCopyWithImpl<$Res, _$CorruptedImpl>
    implements _$$CorruptedImplCopyWith<$Res> {
  __$$CorruptedImplCopyWithImpl(
    _$CorruptedImpl _value,
    $Res Function(_$CorruptedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? details = null}) {
    return _then(
      _$CorruptedImpl(
        null == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$CorruptedImpl implements _Corrupted {
  const _$CorruptedImpl(this.details);

  @override
  final String details;

  @override
  String toString() {
    return 'BackupValidationResult.corrupted(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorruptedImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CorruptedImplCopyWith<_$CorruptedImpl> get copyWith =>
      __$$CorruptedImplCopyWithImpl<_$CorruptedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BackupMetadata metadata) valid,
    required TResult Function(String reason) invalid,
    required TResult Function(String details) corrupted,
  }) {
    return corrupted(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BackupMetadata metadata)? valid,
    TResult? Function(String reason)? invalid,
    TResult? Function(String details)? corrupted,
  }) {
    return corrupted?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BackupMetadata metadata)? valid,
    TResult Function(String reason)? invalid,
    TResult Function(String details)? corrupted,
    required TResult orElse(),
  }) {
    if (corrupted != null) {
      return corrupted(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valid value) valid,
    required TResult Function(_Invalid value) invalid,
    required TResult Function(_Corrupted value) corrupted,
  }) {
    return corrupted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valid value)? valid,
    TResult? Function(_Invalid value)? invalid,
    TResult? Function(_Corrupted value)? corrupted,
  }) {
    return corrupted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valid value)? valid,
    TResult Function(_Invalid value)? invalid,
    TResult Function(_Corrupted value)? corrupted,
    required TResult orElse(),
  }) {
    if (corrupted != null) {
      return corrupted(this);
    }
    return orElse();
  }
}

abstract class _Corrupted implements BackupValidationResult {
  const factory _Corrupted(final String details) = _$CorruptedImpl;

  String get details;

  /// Create a copy of BackupValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CorruptedImplCopyWith<_$CorruptedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupProgress _$BackupProgressFromJson(Map<String, dynamic> json) {
  return _BackupProgress.fromJson(json);
}

/// @nodoc
mixin _$BackupProgress {
  double get progress => throw _privateConstructorUsedError; // 0.0 to 1.0
  String get currentStep => throw _privateConstructorUsedError;
  String? get statusMessage => throw _privateConstructorUsedError;

  /// Serializes this BackupProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupProgressCopyWith<BackupProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupProgressCopyWith<$Res> {
  factory $BackupProgressCopyWith(
    BackupProgress value,
    $Res Function(BackupProgress) then,
  ) = _$BackupProgressCopyWithImpl<$Res, BackupProgress>;
  @useResult
  $Res call({double progress, String currentStep, String? statusMessage});
}

/// @nodoc
class _$BackupProgressCopyWithImpl<$Res, $Val extends BackupProgress>
    implements $BackupProgressCopyWith<$Res> {
  _$BackupProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? currentStep = null,
    Object? statusMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            progress:
                null == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as double,
            currentStep:
                null == currentStep
                    ? _value.currentStep
                    : currentStep // ignore: cast_nullable_to_non_nullable
                        as String,
            statusMessage:
                freezed == statusMessage
                    ? _value.statusMessage
                    : statusMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BackupProgressImplCopyWith<$Res>
    implements $BackupProgressCopyWith<$Res> {
  factory _$$BackupProgressImplCopyWith(
    _$BackupProgressImpl value,
    $Res Function(_$BackupProgressImpl) then,
  ) = __$$BackupProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double progress, String currentStep, String? statusMessage});
}

/// @nodoc
class __$$BackupProgressImplCopyWithImpl<$Res>
    extends _$BackupProgressCopyWithImpl<$Res, _$BackupProgressImpl>
    implements _$$BackupProgressImplCopyWith<$Res> {
  __$$BackupProgressImplCopyWithImpl(
    _$BackupProgressImpl _value,
    $Res Function(_$BackupProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? currentStep = null,
    Object? statusMessage = freezed,
  }) {
    return _then(
      _$BackupProgressImpl(
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
        currentStep:
            null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                    as String,
        statusMessage:
            freezed == statusMessage
                ? _value.statusMessage
                : statusMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupProgressImpl implements _BackupProgress {
  const _$BackupProgressImpl({
    required this.progress,
    required this.currentStep,
    required this.statusMessage,
  });

  factory _$BackupProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupProgressImplFromJson(json);

  @override
  final double progress;
  // 0.0 to 1.0
  @override
  final String currentStep;
  @override
  final String? statusMessage;

  @override
  String toString() {
    return 'BackupProgress(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupProgressImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, progress, currentStep, statusMessage);

  /// Create a copy of BackupProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupProgressImplCopyWith<_$BackupProgressImpl> get copyWith =>
      __$$BackupProgressImplCopyWithImpl<_$BackupProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupProgressImplToJson(this);
  }
}

abstract class _BackupProgress implements BackupProgress {
  const factory _BackupProgress({
    required final double progress,
    required final String currentStep,
    required final String? statusMessage,
  }) = _$BackupProgressImpl;

  factory _BackupProgress.fromJson(Map<String, dynamic> json) =
      _$BackupProgressImpl.fromJson;

  @override
  double get progress; // 0.0 to 1.0
  @override
  String get currentStep;
  @override
  String? get statusMessage;

  /// Create a copy of BackupProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupProgressImplCopyWith<_$BackupProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupFileInfo _$BackupFileInfoFromJson(Map<String, dynamic> json) {
  return _BackupFileInfo.fromJson(json);
}

/// @nodoc
mixin _$BackupFileInfo {
  String get filePath => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  BackupMetadata? get metadata => throw _privateConstructorUsedError;

  /// Serializes this BackupFileInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupFileInfoCopyWith<BackupFileInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupFileInfoCopyWith<$Res> {
  factory $BackupFileInfoCopyWith(
    BackupFileInfo value,
    $Res Function(BackupFileInfo) then,
  ) = _$BackupFileInfoCopyWithImpl<$Res, BackupFileInfo>;
  @useResult
  $Res call({
    String filePath,
    String fileName,
    int fileSizeBytes,
    DateTime createdAt,
    BackupMetadata? metadata,
  });

  $BackupMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$BackupFileInfoCopyWithImpl<$Res, $Val extends BackupFileInfo>
    implements $BackupFileInfoCopyWith<$Res> {
  _$BackupFileInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            filePath:
                null == filePath
                    ? _value.filePath
                    : filePath // ignore: cast_nullable_to_non_nullable
                        as String,
            fileName:
                null == fileName
                    ? _value.fileName
                    : fileName // ignore: cast_nullable_to_non_nullable
                        as String,
            fileSizeBytes:
                null == fileSizeBytes
                    ? _value.fileSizeBytes
                    : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as BackupMetadata?,
          )
          as $Val,
    );
  }

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackupMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $BackupMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BackupFileInfoImplCopyWith<$Res>
    implements $BackupFileInfoCopyWith<$Res> {
  factory _$$BackupFileInfoImplCopyWith(
    _$BackupFileInfoImpl value,
    $Res Function(_$BackupFileInfoImpl) then,
  ) = __$$BackupFileInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String filePath,
    String fileName,
    int fileSizeBytes,
    DateTime createdAt,
    BackupMetadata? metadata,
  });

  @override
  $BackupMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$BackupFileInfoImplCopyWithImpl<$Res>
    extends _$BackupFileInfoCopyWithImpl<$Res, _$BackupFileInfoImpl>
    implements _$$BackupFileInfoImplCopyWith<$Res> {
  __$$BackupFileInfoImplCopyWithImpl(
    _$BackupFileInfoImpl _value,
    $Res Function(_$BackupFileInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filePath = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$BackupFileInfoImpl(
        filePath:
            null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                    as String,
        fileName:
            null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                    as String,
        fileSizeBytes:
            null == fileSizeBytes
                ? _value.fileSizeBytes
                : fileSizeBytes // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        metadata:
            freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as BackupMetadata?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupFileInfoImpl implements _BackupFileInfo {
  const _$BackupFileInfoImpl({
    required this.filePath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.createdAt,
    this.metadata,
  });

  factory _$BackupFileInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupFileInfoImplFromJson(json);

  @override
  final String filePath;
  @override
  final String fileName;
  @override
  final int fileSizeBytes;
  @override
  final DateTime createdAt;
  @override
  final BackupMetadata? metadata;

  @override
  String toString() {
    return 'BackupFileInfo(filePath: $filePath, fileName: $fileName, fileSizeBytes: $fileSizeBytes, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupFileInfoImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    filePath,
    fileName,
    fileSizeBytes,
    createdAt,
    metadata,
  );

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupFileInfoImplCopyWith<_$BackupFileInfoImpl> get copyWith =>
      __$$BackupFileInfoImplCopyWithImpl<_$BackupFileInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupFileInfoImplToJson(this);
  }
}

abstract class _BackupFileInfo implements BackupFileInfo {
  const factory _BackupFileInfo({
    required final String filePath,
    required final String fileName,
    required final int fileSizeBytes,
    required final DateTime createdAt,
    final BackupMetadata? metadata,
  }) = _$BackupFileInfoImpl;

  factory _BackupFileInfo.fromJson(Map<String, dynamic> json) =
      _$BackupFileInfoImpl.fromJson;

  @override
  String get filePath;
  @override
  String get fileName;
  @override
  int get fileSizeBytes;
  @override
  DateTime get createdAt;
  @override
  BackupMetadata? get metadata;

  /// Create a copy of BackupFileInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupFileInfoImplCopyWith<_$BackupFileInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
