// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameId {

 String get value;
/// Create a copy of GameId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameIdCopyWith<GameId> get copyWith => _$GameIdCopyWithImpl<GameId>(this as GameId, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameId;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameId&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as GameId;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as GameId;
  return 'GameId(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $GameIdCopyWith<$Res>  {
  factory $GameIdCopyWith(GameId value, $Res Function(GameId) _then) = _$GameIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$GameIdCopyWithImpl<$Res>
    implements $GameIdCopyWith<$Res> {
  _$GameIdCopyWithImpl(this._self, this._then);

  final GameId _self;
  final $Res Function(GameId) _then;

/// Create a copy of GameId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(GameId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GameId].
extension GameIdPatterns on GameId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameId value)  $default,){
final _that = this;
switch (_that) {
case _GameId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameId value)?  $default,){
final _that = this;
switch (_that) {
case _GameId() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameId() when $default != null:
return $default(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value)  $default,) {final _that = this;
switch (_that) {
case _GameId():
return $default(_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value)?  $default,) {final _that = this;
switch (_that) {
case _GameId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _GameId implements GameId {
  const _GameId(this.value);
  

@override final  String value;

/// Create a copy of GameId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameIdCopyWith<_GameId> get copyWith => __$GameIdCopyWithImpl<_GameId>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameId&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'GameId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$GameIdCopyWith<$Res> implements $GameIdCopyWith<$Res> {
  factory _$GameIdCopyWith(_GameId value, $Res Function(_GameId) _then) = __$GameIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$GameIdCopyWithImpl<$Res>
    implements _$GameIdCopyWith<$Res> {
  __$GameIdCopyWithImpl(this._self, this._then);

  final _GameId _self;
  final $Res Function(_GameId) _then;

/// Create a copy of GameId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_GameId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GameItem {

 GameId get id; String get title; String get platform; GameStatus get status; DateTime get lastModified; DateTime get lastStatusChange; String? get imagePath; String? get remoteImageUrl; bool get isPhysical; String? get barcode;
/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameItemCopyWith<GameItem> get copyWith => _$GameItemCopyWithImpl<GameItem>(this as GameItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.lastModified, _this.lastModified) || other.lastModified == _this.lastModified)&&(identical(other.lastStatusChange, _this.lastStatusChange) || other.lastStatusChange == _this.lastStatusChange)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.remoteImageUrl, _this.remoteImageUrl) || other.remoteImageUrl == _this.remoteImageUrl)&&(identical(other.isPhysical, _this.isPhysical) || other.isPhysical == _this.isPhysical)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode));
}


@override
int get hashCode {
  final _this = this as GameItem;
  return Object.hash(runtimeType,_this.id,_this.title,_this.platform,_this.status,_this.lastModified,_this.lastStatusChange,_this.imagePath,_this.remoteImageUrl,_this.isPhysical,_this.barcode);
}

@override
String toString() {
  final _this = this as GameItem;
  return 'GameItem(id: ${_this.id}, title: ${_this.title}, platform: ${_this.platform}, status: ${_this.status}, lastModified: ${_this.lastModified}, lastStatusChange: ${_this.lastStatusChange}, imagePath: ${_this.imagePath}, remoteImageUrl: ${_this.remoteImageUrl}, isPhysical: ${_this.isPhysical}, barcode: ${_this.barcode})';
}


}

/// @nodoc
abstract mixin class $GameItemCopyWith<$Res>  {
  factory $GameItemCopyWith(GameItem value, $Res Function(GameItem) _then) = _$GameItemCopyWithImpl;
@useResult
$Res call({
 GameId id, String title, String platform, GameStatus status, DateTime lastModified, DateTime lastStatusChange, String? imagePath, String? remoteImageUrl, bool isPhysical, String? barcode
});


$GameIdCopyWith<$Res> get id;

}
/// @nodoc
class _$GameItemCopyWithImpl<$Res>
    implements $GameItemCopyWith<$Res> {
  _$GameItemCopyWithImpl(this._self, this._then);

  final GameItem _self;
  final $Res Function(GameItem) _then;

/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? platform = null,Object? status = null,Object? lastModified = null,Object? lastStatusChange = null,Object? imagePath = freezed,Object? remoteImageUrl = freezed,Object? isPhysical = null,Object? barcode = freezed,}) {
  return _then(GameItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GameId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime,lastStatusChange: null == lastStatusChange ? _self.lastStatusChange : lastStatusChange // ignore: cast_nullable_to_non_nullable
as DateTime,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,remoteImageUrl: freezed == remoteImageUrl ? _self.remoteImageUrl : remoteImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isPhysical: null == isPhysical ? _self.isPhysical : isPhysical // ignore: cast_nullable_to_non_nullable
as bool,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameIdCopyWith<$Res> get id {
  
  return $GameIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameItem].
extension GameItemPatterns on GameItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameItem value)  $default,){
final _that = this;
switch (_that) {
case _GameItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameItem value)?  $default,){
final _that = this;
switch (_that) {
case _GameItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameId id,  String title,  String platform,  GameStatus status,  DateTime lastModified,  DateTime lastStatusChange,  String? imagePath,  String? remoteImageUrl,  bool isPhysical,  String? barcode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameItem() when $default != null:
return $default(_that.id,_that.title,_that.platform,_that.status,_that.lastModified,_that.lastStatusChange,_that.imagePath,_that.remoteImageUrl,_that.isPhysical,_that.barcode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameId id,  String title,  String platform,  GameStatus status,  DateTime lastModified,  DateTime lastStatusChange,  String? imagePath,  String? remoteImageUrl,  bool isPhysical,  String? barcode)  $default,) {final _that = this;
switch (_that) {
case _GameItem():
return $default(_that.id,_that.title,_that.platform,_that.status,_that.lastModified,_that.lastStatusChange,_that.imagePath,_that.remoteImageUrl,_that.isPhysical,_that.barcode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameId id,  String title,  String platform,  GameStatus status,  DateTime lastModified,  DateTime lastStatusChange,  String? imagePath,  String? remoteImageUrl,  bool isPhysical,  String? barcode)?  $default,) {final _that = this;
switch (_that) {
case _GameItem() when $default != null:
return $default(_that.id,_that.title,_that.platform,_that.status,_that.lastModified,_that.lastStatusChange,_that.imagePath,_that.remoteImageUrl,_that.isPhysical,_that.barcode);case _:
  return null;

}
}

}

/// @nodoc


class _GameItem implements GameItem {
  const _GameItem({required this.id, required this.title, required this.platform, required this.status, required this.lastModified, required this.lastStatusChange, this.imagePath, this.remoteImageUrl, this.isPhysical = false, this.barcode});
  

@override final  GameId id;
@override final  String title;
@override final  String platform;
@override final  GameStatus status;
@override final  DateTime lastModified;
@override final  DateTime lastStatusChange;
@override final  String? imagePath;
@override final  String? remoteImageUrl;
@override@JsonKey() final  bool isPhysical;
@override final  String? barcode;

/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameItemCopyWith<_GameItem> get copyWith => __$GameItemCopyWithImpl<_GameItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.lastStatusChange, lastStatusChange) || other.lastStatusChange == lastStatusChange)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.remoteImageUrl, remoteImageUrl) || other.remoteImageUrl == remoteImageUrl)&&(identical(other.isPhysical, isPhysical) || other.isPhysical == isPhysical)&&(identical(other.barcode, barcode) || other.barcode == barcode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,platform,status,lastModified,lastStatusChange,imagePath,remoteImageUrl,isPhysical,barcode);
}

@override
String toString() {
    return 'GameItem(id: $id, title: $title, platform: $platform, status: $status, lastModified: $lastModified, lastStatusChange: $lastStatusChange, imagePath: $imagePath, remoteImageUrl: $remoteImageUrl, isPhysical: $isPhysical, barcode: $barcode)';
}


}

/// @nodoc
abstract mixin class _$GameItemCopyWith<$Res> implements $GameItemCopyWith<$Res> {
  factory _$GameItemCopyWith(_GameItem value, $Res Function(_GameItem) _then) = __$GameItemCopyWithImpl;
@override @useResult
$Res call({
 GameId id, String title, String platform, GameStatus status, DateTime lastModified, DateTime lastStatusChange, String? imagePath, String? remoteImageUrl, bool isPhysical, String? barcode
});


@override $GameIdCopyWith<$Res> get id;

}
/// @nodoc
class __$GameItemCopyWithImpl<$Res>
    implements _$GameItemCopyWith<$Res> {
  __$GameItemCopyWithImpl(this._self, this._then);

  final _GameItem _self;
  final $Res Function(_GameItem) _then;

/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? platform = null,Object? status = null,Object? lastModified = null,Object? lastStatusChange = null,Object? imagePath = freezed,Object? remoteImageUrl = freezed,Object? isPhysical = null,Object? barcode = freezed,}) {
  return _then(_GameItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GameId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime,lastStatusChange: null == lastStatusChange ? _self.lastStatusChange : lastStatusChange // ignore: cast_nullable_to_non_nullable
as DateTime,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,remoteImageUrl: freezed == remoteImageUrl ? _self.remoteImageUrl : remoteImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isPhysical: null == isPhysical ? _self.isPhysical : isPhysical // ignore: cast_nullable_to_non_nullable
as bool,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GameItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameIdCopyWith<$Res> get id {
  
  return $GameIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}
}

// dart format on
