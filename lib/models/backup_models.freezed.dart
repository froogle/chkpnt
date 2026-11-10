// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupMetadata {

 String get version; DateTime get createdAt; int get gameCount; int get imageCount; List<String> get includedImages; int get guideCount; List<String> get includedGuides;
/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<BackupMetadata> get copyWith => _$BackupMetadataCopyWithImpl<BackupMetadata>(this as BackupMetadata, _$identity);

  /// Serializes this BackupMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupMetadata;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupMetadata&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.gameCount, _this.gameCount) || other.gameCount == _this.gameCount)&&(identical(other.imageCount, _this.imageCount) || other.imageCount == _this.imageCount)&&const DeepCollectionEquality().equals(other.includedImages, _this.includedImages)&&(identical(other.guideCount, _this.guideCount) || other.guideCount == _this.guideCount)&&const DeepCollectionEquality().equals(other.includedGuides, _this.includedGuides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupMetadata;
  return Object.hash(runtimeType,_this.version,_this.createdAt,_this.gameCount,_this.imageCount,const DeepCollectionEquality().hash(_this.includedImages),_this.guideCount,const DeepCollectionEquality().hash(_this.includedGuides));
}

@override
String toString() {
  final _this = this as BackupMetadata;
  return 'BackupMetadata(version: ${_this.version}, createdAt: ${_this.createdAt}, gameCount: ${_this.gameCount}, imageCount: ${_this.imageCount}, includedImages: ${_this.includedImages}, guideCount: ${_this.guideCount}, includedGuides: ${_this.includedGuides})';
}


}

/// @nodoc
abstract mixin class $BackupMetadataCopyWith<$Res>  {
  factory $BackupMetadataCopyWith(BackupMetadata value, $Res Function(BackupMetadata) _then) = _$BackupMetadataCopyWithImpl;
@useResult
$Res call({
 String version, DateTime createdAt, int gameCount, int imageCount, List<String> includedImages, int guideCount, List<String> includedGuides
});




}
/// @nodoc
class _$BackupMetadataCopyWithImpl<$Res>
    implements $BackupMetadataCopyWith<$Res> {
  _$BackupMetadataCopyWithImpl(this._self, this._then);

  final BackupMetadata _self;
  final $Res Function(BackupMetadata) _then;

/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? createdAt = null,Object? gameCount = null,Object? imageCount = null,Object? includedImages = null,Object? guideCount = null,Object? includedGuides = null,}) {
  return _then(BackupMetadata(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameCount: null == gameCount ? _self.gameCount : gameCount // ignore: cast_nullable_to_non_nullable
as int,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,includedImages: null == includedImages ? _self.includedImages : includedImages // ignore: cast_nullable_to_non_nullable
as List<String>,guideCount: null == guideCount ? _self.guideCount : guideCount // ignore: cast_nullable_to_non_nullable
as int,includedGuides: null == includedGuides ? _self.includedGuides : includedGuides // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupMetadata].
extension BackupMetadataPatterns on BackupMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupMetadata value)  $default,){
final _that = this;
switch (_that) {
case _BackupMetadata():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  DateTime createdAt,  int gameCount,  int imageCount,  List<String> includedImages,  int guideCount,  List<String> includedGuides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that.version,_that.createdAt,_that.gameCount,_that.imageCount,_that.includedImages,_that.guideCount,_that.includedGuides);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  DateTime createdAt,  int gameCount,  int imageCount,  List<String> includedImages,  int guideCount,  List<String> includedGuides)  $default,) {final _that = this;
switch (_that) {
case _BackupMetadata():
return $default(_that.version,_that.createdAt,_that.gameCount,_that.imageCount,_that.includedImages,_that.guideCount,_that.includedGuides);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  DateTime createdAt,  int gameCount,  int imageCount,  List<String> includedImages,  int guideCount,  List<String> includedGuides)?  $default,) {final _that = this;
switch (_that) {
case _BackupMetadata() when $default != null:
return $default(_that.version,_that.createdAt,_that.gameCount,_that.imageCount,_that.includedImages,_that.guideCount,_that.includedGuides);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupMetadata implements BackupMetadata {
  const _BackupMetadata({required this.version, required this.createdAt, required this.gameCount, required this.imageCount, required  List<String> includedImages, this.guideCount = 0,  List<String> includedGuides = const []}): _includedImages = includedImages,_includedGuides = includedGuides;
  factory _BackupMetadata.fromJson(Map<String, dynamic> json) => _$BackupMetadataFromJson(json);

@override final  String version;
@override final  DateTime createdAt;
@override final  int gameCount;
@override final  int imageCount;
 final  List<String> _includedImages;
@override List<String> get includedImages {
  if (_includedImages is EqualUnmodifiableListView) return _includedImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_includedImages);
}

@override@JsonKey() final  int guideCount;
 final  List<String> _includedGuides;
@override@JsonKey() List<String> get includedGuides {
  if (_includedGuides is EqualUnmodifiableListView) return _includedGuides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_includedGuides);
}


/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupMetadataCopyWith<_BackupMetadata> get copyWith => __$BackupMetadataCopyWithImpl<_BackupMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupMetadata&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.gameCount, gameCount) || other.gameCount == gameCount)&&(identical(other.imageCount, imageCount) || other.imageCount == imageCount)&&const DeepCollectionEquality().equals(other.includedImages, _includedImages)&&(identical(other.guideCount, guideCount) || other.guideCount == guideCount)&&const DeepCollectionEquality().equals(other.includedGuides, _includedGuides));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,createdAt,gameCount,imageCount,const DeepCollectionEquality().hash(_includedImages),guideCount,const DeepCollectionEquality().hash(_includedGuides));
}

@override
String toString() {
    return 'BackupMetadata(version: $version, createdAt: $createdAt, gameCount: $gameCount, imageCount: $imageCount, includedImages: $includedImages, guideCount: $guideCount, includedGuides: $includedGuides)';
}


}

/// @nodoc
abstract mixin class _$BackupMetadataCopyWith<$Res> implements $BackupMetadataCopyWith<$Res> {
  factory _$BackupMetadataCopyWith(_BackupMetadata value, $Res Function(_BackupMetadata) _then) = __$BackupMetadataCopyWithImpl;
@override @useResult
$Res call({
 String version, DateTime createdAt, int gameCount, int imageCount, List<String> includedImages, int guideCount, List<String> includedGuides
});




}
/// @nodoc
class __$BackupMetadataCopyWithImpl<$Res>
    implements _$BackupMetadataCopyWith<$Res> {
  __$BackupMetadataCopyWithImpl(this._self, this._then);

  final _BackupMetadata _self;
  final $Res Function(_BackupMetadata) _then;

/// Create a copy of BackupMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? createdAt = null,Object? gameCount = null,Object? imageCount = null,Object? includedImages = null,Object? guideCount = null,Object? includedGuides = null,}) {
  return _then(_BackupMetadata(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameCount: null == gameCount ? _self.gameCount : gameCount // ignore: cast_nullable_to_non_nullable
as int,imageCount: null == imageCount ? _self.imageCount : imageCount // ignore: cast_nullable_to_non_nullable
as int,includedImages: null == includedImages ? _self._includedImages : includedImages // ignore: cast_nullable_to_non_nullable
as List<String>,guideCount: null == guideCount ? _self.guideCount : guideCount // ignore: cast_nullable_to_non_nullable
as int,includedGuides: null == includedGuides ? _self._includedGuides : includedGuides // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$BackupValidationResult {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupValidationResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BackupValidationResult()';
}


}

/// @nodoc
class $BackupValidationResultCopyWith<$Res>  {
$BackupValidationResultCopyWith(BackupValidationResult _, $Res Function(BackupValidationResult) __);
}


/// Adds pattern-matching-related methods to [BackupValidationResult].
extension BackupValidationResultPatterns on BackupValidationResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Valid value)?  valid,TResult Function( _Invalid value)?  invalid,TResult Function( _Corrupted value)?  corrupted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Valid() when valid != null:
return valid(_that);case _Invalid() when invalid != null:
return invalid(_that);case _Corrupted() when corrupted != null:
return corrupted(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Valid value)  valid,required TResult Function( _Invalid value)  invalid,required TResult Function( _Corrupted value)  corrupted,}){
final _that = this;
switch (_that) {
case _Valid():
return valid(_that);case _Invalid():
return invalid(_that);case _Corrupted():
return corrupted(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Valid value)?  valid,TResult? Function( _Invalid value)?  invalid,TResult? Function( _Corrupted value)?  corrupted,}){
final _that = this;
switch (_that) {
case _Valid() when valid != null:
return valid(_that);case _Invalid() when invalid != null:
return invalid(_that);case _Corrupted() when corrupted != null:
return corrupted(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BackupMetadata metadata)?  valid,TResult Function( String reason)?  invalid,TResult Function( String details)?  corrupted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Valid() when valid != null:
return valid(_that.metadata);case _Invalid() when invalid != null:
return invalid(_that.reason);case _Corrupted() when corrupted != null:
return corrupted(_that.details);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BackupMetadata metadata)  valid,required TResult Function( String reason)  invalid,required TResult Function( String details)  corrupted,}) {final _that = this;
switch (_that) {
case _Valid():
return valid(_that.metadata);case _Invalid():
return invalid(_that.reason);case _Corrupted():
return corrupted(_that.details);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BackupMetadata metadata)?  valid,TResult? Function( String reason)?  invalid,TResult? Function( String details)?  corrupted,}) {final _that = this;
switch (_that) {
case _Valid() when valid != null:
return valid(_that.metadata);case _Invalid() when invalid != null:
return invalid(_that.reason);case _Corrupted() when corrupted != null:
return corrupted(_that.details);case _:
  return null;

}
}

}

/// @nodoc


class _Valid implements BackupValidationResult {
  const _Valid(this.metadata);
  

 final  BackupMetadata metadata;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidCopyWith<_Valid> get copyWith => __$ValidCopyWithImpl<_Valid>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Valid&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode {
    return Object.hash(runtimeType,metadata);
}

@override
String toString() {
    return 'BackupValidationResult.valid(metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ValidCopyWith<$Res> implements $BackupValidationResultCopyWith<$Res> {
  factory _$ValidCopyWith(_Valid value, $Res Function(_Valid) _then) = __$ValidCopyWithImpl;
@useResult
$Res call({
 BackupMetadata metadata
});


$BackupMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ValidCopyWithImpl<$Res>
    implements _$ValidCopyWith<$Res> {
  __$ValidCopyWithImpl(this._self, this._then);

  final _Valid _self;
  final $Res Function(_Valid) _then;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? metadata = null,}) {
  return _then(_Valid(
null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata,
  ));
}

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<$Res> get metadata {
  
  return $BackupMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

/// @nodoc


class _Invalid implements BackupValidationResult {
  const _Invalid(this.reason);
  

 final  String reason;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidCopyWith<_Invalid> get copyWith => __$InvalidCopyWithImpl<_Invalid>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invalid&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString() {
    return 'BackupValidationResult.invalid(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$InvalidCopyWith<$Res> implements $BackupValidationResultCopyWith<$Res> {
  factory _$InvalidCopyWith(_Invalid value, $Res Function(_Invalid) _then) = __$InvalidCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$InvalidCopyWithImpl<$Res>
    implements _$InvalidCopyWith<$Res> {
  __$InvalidCopyWithImpl(this._self, this._then);

  final _Invalid _self;
  final $Res Function(_Invalid) _then;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_Invalid(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Corrupted implements BackupValidationResult {
  const _Corrupted(this.details);
  

 final  String details;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorruptedCopyWith<_Corrupted> get copyWith => __$CorruptedCopyWithImpl<_Corrupted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Corrupted&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode {
    return Object.hash(runtimeType,details);
}

@override
String toString() {
    return 'BackupValidationResult.corrupted(details: $details)';
}


}

/// @nodoc
abstract mixin class _$CorruptedCopyWith<$Res> implements $BackupValidationResultCopyWith<$Res> {
  factory _$CorruptedCopyWith(_Corrupted value, $Res Function(_Corrupted) _then) = __$CorruptedCopyWithImpl;
@useResult
$Res call({
 String details
});




}
/// @nodoc
class __$CorruptedCopyWithImpl<$Res>
    implements _$CorruptedCopyWith<$Res> {
  __$CorruptedCopyWithImpl(this._self, this._then);

  final _Corrupted _self;
  final $Res Function(_Corrupted) _then;

/// Create a copy of BackupValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(_Corrupted(
null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BackupProgress {

 double get progress; String get currentStep; String? get statusMessage;
/// Create a copy of BackupProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupProgressCopyWith<BackupProgress> get copyWith => _$BackupProgressCopyWithImpl<BackupProgress>(this as BackupProgress, _$identity);

  /// Serializes this BackupProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupProgress&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.currentStep, _this.currentStep) || other.currentStep == _this.currentStep)&&(identical(other.statusMessage, _this.statusMessage) || other.statusMessage == _this.statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupProgress;
  return Object.hash(runtimeType,_this.progress,_this.currentStep,_this.statusMessage);
}

@override
String toString() {
  final _this = this as BackupProgress;
  return 'BackupProgress(progress: ${_this.progress}, currentStep: ${_this.currentStep}, statusMessage: ${_this.statusMessage})';
}


}

/// @nodoc
abstract mixin class $BackupProgressCopyWith<$Res>  {
  factory $BackupProgressCopyWith(BackupProgress value, $Res Function(BackupProgress) _then) = _$BackupProgressCopyWithImpl;
@useResult
$Res call({
 double progress, String currentStep, String? statusMessage
});




}
/// @nodoc
class _$BackupProgressCopyWithImpl<$Res>
    implements $BackupProgressCopyWith<$Res> {
  _$BackupProgressCopyWithImpl(this._self, this._then);

  final BackupProgress _self;
  final $Res Function(BackupProgress) _then;

/// Create a copy of BackupProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progress = null,Object? currentStep = null,Object? statusMessage = freezed,}) {
  return _then(BackupProgress(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupProgress].
extension BackupProgressPatterns on BackupProgress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupProgress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupProgress value)  $default,){
final _that = this;
switch (_that) {
case _BackupProgress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupProgress value)?  $default,){
final _that = this;
switch (_that) {
case _BackupProgress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double progress,  String currentStep,  String? statusMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupProgress() when $default != null:
return $default(_that.progress,_that.currentStep,_that.statusMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double progress,  String currentStep,  String? statusMessage)  $default,) {final _that = this;
switch (_that) {
case _BackupProgress():
return $default(_that.progress,_that.currentStep,_that.statusMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double progress,  String currentStep,  String? statusMessage)?  $default,) {final _that = this;
switch (_that) {
case _BackupProgress() when $default != null:
return $default(_that.progress,_that.currentStep,_that.statusMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupProgress implements BackupProgress {
  const _BackupProgress({required this.progress, required this.currentStep, required this.statusMessage});
  factory _BackupProgress.fromJson(Map<String, dynamic> json) => _$BackupProgressFromJson(json);

@override final  double progress;
@override final  String currentStep;
@override final  String? statusMessage;

/// Create a copy of BackupProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupProgressCopyWith<_BackupProgress> get copyWith => __$BackupProgressCopyWithImpl<_BackupProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupProgressToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupProgress&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,progress,currentStep,statusMessage);
}

@override
String toString() {
    return 'BackupProgress(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$BackupProgressCopyWith<$Res> implements $BackupProgressCopyWith<$Res> {
  factory _$BackupProgressCopyWith(_BackupProgress value, $Res Function(_BackupProgress) _then) = __$BackupProgressCopyWithImpl;
@override @useResult
$Res call({
 double progress, String currentStep, String? statusMessage
});




}
/// @nodoc
class __$BackupProgressCopyWithImpl<$Res>
    implements _$BackupProgressCopyWith<$Res> {
  __$BackupProgressCopyWithImpl(this._self, this._then);

  final _BackupProgress _self;
  final $Res Function(_BackupProgress) _then;

/// Create a copy of BackupProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? currentStep = null,Object? statusMessage = freezed,}) {
  return _then(_BackupProgress(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BackupFileInfo {

 String get filePath; String get fileName; int get fileSizeBytes; DateTime get createdAt; BackupMetadata? get metadata;
/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupFileInfoCopyWith<BackupFileInfo> get copyWith => _$BackupFileInfoCopyWithImpl<BackupFileInfo>(this as BackupFileInfo, _$identity);

  /// Serializes this BackupFileInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupFileInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupFileInfo&&(identical(other.filePath, _this.filePath) || other.filePath == _this.filePath)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.fileSizeBytes, _this.fileSizeBytes) || other.fileSizeBytes == _this.fileSizeBytes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.metadata, _this.metadata) || other.metadata == _this.metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupFileInfo;
  return Object.hash(runtimeType,_this.filePath,_this.fileName,_this.fileSizeBytes,_this.createdAt,_this.metadata);
}

@override
String toString() {
  final _this = this as BackupFileInfo;
  return 'BackupFileInfo(filePath: ${_this.filePath}, fileName: ${_this.fileName}, fileSizeBytes: ${_this.fileSizeBytes}, createdAt: ${_this.createdAt}, metadata: ${_this.metadata})';
}


}

/// @nodoc
abstract mixin class $BackupFileInfoCopyWith<$Res>  {
  factory $BackupFileInfoCopyWith(BackupFileInfo value, $Res Function(BackupFileInfo) _then) = _$BackupFileInfoCopyWithImpl;
@useResult
$Res call({
 String filePath, String fileName, int fileSizeBytes, DateTime createdAt, BackupMetadata? metadata
});


$BackupMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$BackupFileInfoCopyWithImpl<$Res>
    implements $BackupFileInfoCopyWith<$Res> {
  _$BackupFileInfoCopyWithImpl(this._self, this._then);

  final BackupFileInfo _self;
  final $Res Function(BackupFileInfo) _then;

/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = null,Object? fileName = null,Object? fileSizeBytes = null,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(BackupFileInfo(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata?,
  ));
}
/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $BackupMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupFileInfo].
extension BackupFileInfoPatterns on BackupFileInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupFileInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupFileInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupFileInfo value)  $default,){
final _that = this;
switch (_that) {
case _BackupFileInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupFileInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BackupFileInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filePath,  String fileName,  int fileSizeBytes,  DateTime createdAt,  BackupMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupFileInfo() when $default != null:
return $default(_that.filePath,_that.fileName,_that.fileSizeBytes,_that.createdAt,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filePath,  String fileName,  int fileSizeBytes,  DateTime createdAt,  BackupMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _BackupFileInfo():
return $default(_that.filePath,_that.fileName,_that.fileSizeBytes,_that.createdAt,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filePath,  String fileName,  int fileSizeBytes,  DateTime createdAt,  BackupMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _BackupFileInfo() when $default != null:
return $default(_that.filePath,_that.fileName,_that.fileSizeBytes,_that.createdAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupFileInfo implements BackupFileInfo {
  const _BackupFileInfo({required this.filePath, required this.fileName, required this.fileSizeBytes, required this.createdAt, this.metadata});
  factory _BackupFileInfo.fromJson(Map<String, dynamic> json) => _$BackupFileInfoFromJson(json);

@override final  String filePath;
@override final  String fileName;
@override final  int fileSizeBytes;
@override final  DateTime createdAt;
@override final  BackupMetadata? metadata;

/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupFileInfoCopyWith<_BackupFileInfo> get copyWith => __$BackupFileInfoCopyWithImpl<_BackupFileInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupFileInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupFileInfo&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,filePath,fileName,fileSizeBytes,createdAt,metadata);
}

@override
String toString() {
    return 'BackupFileInfo(filePath: $filePath, fileName: $fileName, fileSizeBytes: $fileSizeBytes, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$BackupFileInfoCopyWith<$Res> implements $BackupFileInfoCopyWith<$Res> {
  factory _$BackupFileInfoCopyWith(_BackupFileInfo value, $Res Function(_BackupFileInfo) _then) = __$BackupFileInfoCopyWithImpl;
@override @useResult
$Res call({
 String filePath, String fileName, int fileSizeBytes, DateTime createdAt, BackupMetadata? metadata
});


@override $BackupMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$BackupFileInfoCopyWithImpl<$Res>
    implements _$BackupFileInfoCopyWith<$Res> {
  __$BackupFileInfoCopyWithImpl(this._self, this._then);

  final _BackupFileInfo _self;
  final $Res Function(_BackupFileInfo) _then;

/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = null,Object? fileName = null,Object? fileSizeBytes = null,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(_BackupFileInfo(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata?,
  ));
}

/// Create a copy of BackupFileInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $BackupMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
