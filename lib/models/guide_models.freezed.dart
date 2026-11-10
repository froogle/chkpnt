// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guide_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GuideId {

 String get value;
/// Create a copy of GuideId
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideIdCopyWith<GuideId> get copyWith => _$GuideIdCopyWithImpl<GuideId>(this as GuideId, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuideId;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideId&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as GuideId;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as GuideId;
  return 'GuideId(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $GuideIdCopyWith<$Res>  {
  factory $GuideIdCopyWith(GuideId value, $Res Function(GuideId) _then) = _$GuideIdCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$GuideIdCopyWithImpl<$Res>
    implements $GuideIdCopyWith<$Res> {
  _$GuideIdCopyWithImpl(this._self, this._then);

  final GuideId _self;
  final $Res Function(GuideId) _then;

/// Create a copy of GuideId
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,}) {
  return _then(GuideId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GuideId].
extension GuideIdPatterns on GuideId {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideId value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideId() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideId value)  $default,){
final _that = this;
switch (_that) {
case _GuideId():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideId value)?  $default,){
final _that = this;
switch (_that) {
case _GuideId() when $default != null:
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
case _GuideId() when $default != null:
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
case _GuideId():
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
case _GuideId() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _GuideId implements GuideId {
  const _GuideId(this.value);
  

@override final  String value;

/// Create a copy of GuideId
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideIdCopyWith<_GuideId> get copyWith => __$GuideIdCopyWithImpl<_GuideId>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideId&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'GuideId(value: $value)';
}


}

/// @nodoc
abstract mixin class _$GuideIdCopyWith<$Res> implements $GuideIdCopyWith<$Res> {
  factory _$GuideIdCopyWith(_GuideId value, $Res Function(_GuideId) _then) = __$GuideIdCopyWithImpl;
@override @useResult
$Res call({
 String value
});




}
/// @nodoc
class __$GuideIdCopyWithImpl<$Res>
    implements _$GuideIdCopyWith<$Res> {
  __$GuideIdCopyWithImpl(this._self, this._then);

  final _GuideId _self;
  final $Res Function(_GuideId) _then;

/// Create a copy of GuideId
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_GuideId(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$GuideItem {

 GuideId get id; GameId get gameId; String get title; String get author; String get fileName; DateTime get createdAt; int get lastReadSection; int get lastReadBlock; String? get sourceUrl; bool get hasSeenAttribution; GuideFormat get format;
/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuideItemCopyWith<GuideItem> get copyWith => _$GuideItemCopyWithImpl<GuideItem>(this as GuideItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GuideItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuideItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.gameId, _this.gameId) || other.gameId == _this.gameId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.lastReadSection, _this.lastReadSection) || other.lastReadSection == _this.lastReadSection)&&(identical(other.lastReadBlock, _this.lastReadBlock) || other.lastReadBlock == _this.lastReadBlock)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.hasSeenAttribution, _this.hasSeenAttribution) || other.hasSeenAttribution == _this.hasSeenAttribution)&&(identical(other.format, _this.format) || other.format == _this.format));
}


@override
int get hashCode {
  final _this = this as GuideItem;
  return Object.hash(runtimeType,_this.id,_this.gameId,_this.title,_this.author,_this.fileName,_this.createdAt,_this.lastReadSection,_this.lastReadBlock,_this.sourceUrl,_this.hasSeenAttribution,_this.format);
}

@override
String toString() {
  final _this = this as GuideItem;
  return 'GuideItem(id: ${_this.id}, gameId: ${_this.gameId}, title: ${_this.title}, author: ${_this.author}, fileName: ${_this.fileName}, createdAt: ${_this.createdAt}, lastReadSection: ${_this.lastReadSection}, lastReadBlock: ${_this.lastReadBlock}, sourceUrl: ${_this.sourceUrl}, hasSeenAttribution: ${_this.hasSeenAttribution}, format: ${_this.format})';
}


}

/// @nodoc
abstract mixin class $GuideItemCopyWith<$Res>  {
  factory $GuideItemCopyWith(GuideItem value, $Res Function(GuideItem) _then) = _$GuideItemCopyWithImpl;
@useResult
$Res call({
 GuideId id, GameId gameId, String title, String author, String fileName, DateTime createdAt, int lastReadSection, int lastReadBlock, String? sourceUrl, bool hasSeenAttribution, GuideFormat format
});


$GuideIdCopyWith<$Res> get id;$GameIdCopyWith<$Res> get gameId;

}
/// @nodoc
class _$GuideItemCopyWithImpl<$Res>
    implements $GuideItemCopyWith<$Res> {
  _$GuideItemCopyWithImpl(this._self, this._then);

  final GuideItem _self;
  final $Res Function(GuideItem) _then;

/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameId = null,Object? title = null,Object? author = null,Object? fileName = null,Object? createdAt = null,Object? lastReadSection = null,Object? lastReadBlock = null,Object? sourceUrl = freezed,Object? hasSeenAttribution = null,Object? format = null,}) {
  return _then(GuideItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GuideId,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as GameId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReadSection: null == lastReadSection ? _self.lastReadSection : lastReadSection // ignore: cast_nullable_to_non_nullable
as int,lastReadBlock: null == lastReadBlock ? _self.lastReadBlock : lastReadBlock // ignore: cast_nullable_to_non_nullable
as int,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,hasSeenAttribution: null == hasSeenAttribution ? _self.hasSeenAttribution : hasSeenAttribution // ignore: cast_nullable_to_non_nullable
as bool,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as GuideFormat,
  ));
}
/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideIdCopyWith<$Res> get id {
  
  return $GuideIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameIdCopyWith<$Res> get gameId {
  
  return $GameIdCopyWith<$Res>(_self.gameId, (value) {
    return _then(_self.copyWith(gameId: value));
  });
}
}


/// Adds pattern-matching-related methods to [GuideItem].
extension GuideItemPatterns on GuideItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuideItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuideItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuideItem value)  $default,){
final _that = this;
switch (_that) {
case _GuideItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuideItem value)?  $default,){
final _that = this;
switch (_that) {
case _GuideItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GuideId id,  GameId gameId,  String title,  String author,  String fileName,  DateTime createdAt,  int lastReadSection,  int lastReadBlock,  String? sourceUrl,  bool hasSeenAttribution,  GuideFormat format)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuideItem() when $default != null:
return $default(_that.id,_that.gameId,_that.title,_that.author,_that.fileName,_that.createdAt,_that.lastReadSection,_that.lastReadBlock,_that.sourceUrl,_that.hasSeenAttribution,_that.format);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GuideId id,  GameId gameId,  String title,  String author,  String fileName,  DateTime createdAt,  int lastReadSection,  int lastReadBlock,  String? sourceUrl,  bool hasSeenAttribution,  GuideFormat format)  $default,) {final _that = this;
switch (_that) {
case _GuideItem():
return $default(_that.id,_that.gameId,_that.title,_that.author,_that.fileName,_that.createdAt,_that.lastReadSection,_that.lastReadBlock,_that.sourceUrl,_that.hasSeenAttribution,_that.format);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GuideId id,  GameId gameId,  String title,  String author,  String fileName,  DateTime createdAt,  int lastReadSection,  int lastReadBlock,  String? sourceUrl,  bool hasSeenAttribution,  GuideFormat format)?  $default,) {final _that = this;
switch (_that) {
case _GuideItem() when $default != null:
return $default(_that.id,_that.gameId,_that.title,_that.author,_that.fileName,_that.createdAt,_that.lastReadSection,_that.lastReadBlock,_that.sourceUrl,_that.hasSeenAttribution,_that.format);case _:
  return null;

}
}

}

/// @nodoc


class _GuideItem implements GuideItem {
  const _GuideItem({required this.id, required this.gameId, required this.title, required this.author, required this.fileName, required this.createdAt, this.lastReadSection = 0, this.lastReadBlock = 0, this.sourceUrl, this.hasSeenAttribution = false, this.format = GuideFormat.text});
  

@override final  GuideId id;
@override final  GameId gameId;
@override final  String title;
@override final  String author;
@override final  String fileName;
@override final  DateTime createdAt;
@override@JsonKey() final  int lastReadSection;
@override@JsonKey() final  int lastReadBlock;
@override final  String? sourceUrl;
@override@JsonKey() final  bool hasSeenAttribution;
@override@JsonKey() final  GuideFormat format;

/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuideItemCopyWith<_GuideItem> get copyWith => __$GuideItemCopyWithImpl<_GuideItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideItem&&(identical(other.id, id) || other.id == id)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastReadSection, lastReadSection) || other.lastReadSection == lastReadSection)&&(identical(other.lastReadBlock, lastReadBlock) || other.lastReadBlock == lastReadBlock)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.hasSeenAttribution, hasSeenAttribution) || other.hasSeenAttribution == hasSeenAttribution)&&(identical(other.format, format) || other.format == format));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,gameId,title,author,fileName,createdAt,lastReadSection,lastReadBlock,sourceUrl,hasSeenAttribution,format);
}

@override
String toString() {
    return 'GuideItem(id: $id, gameId: $gameId, title: $title, author: $author, fileName: $fileName, createdAt: $createdAt, lastReadSection: $lastReadSection, lastReadBlock: $lastReadBlock, sourceUrl: $sourceUrl, hasSeenAttribution: $hasSeenAttribution, format: $format)';
}


}

/// @nodoc
abstract mixin class _$GuideItemCopyWith<$Res> implements $GuideItemCopyWith<$Res> {
  factory _$GuideItemCopyWith(_GuideItem value, $Res Function(_GuideItem) _then) = __$GuideItemCopyWithImpl;
@override @useResult
$Res call({
 GuideId id, GameId gameId, String title, String author, String fileName, DateTime createdAt, int lastReadSection, int lastReadBlock, String? sourceUrl, bool hasSeenAttribution, GuideFormat format
});


@override $GuideIdCopyWith<$Res> get id;@override $GameIdCopyWith<$Res> get gameId;

}
/// @nodoc
class __$GuideItemCopyWithImpl<$Res>
    implements _$GuideItemCopyWith<$Res> {
  __$GuideItemCopyWithImpl(this._self, this._then);

  final _GuideItem _self;
  final $Res Function(_GuideItem) _then;

/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameId = null,Object? title = null,Object? author = null,Object? fileName = null,Object? createdAt = null,Object? lastReadSection = null,Object? lastReadBlock = null,Object? sourceUrl = freezed,Object? hasSeenAttribution = null,Object? format = null,}) {
  return _then(_GuideItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as GuideId,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as GameId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReadSection: null == lastReadSection ? _self.lastReadSection : lastReadSection // ignore: cast_nullable_to_non_nullable
as int,lastReadBlock: null == lastReadBlock ? _self.lastReadBlock : lastReadBlock // ignore: cast_nullable_to_non_nullable
as int,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,hasSeenAttribution: null == hasSeenAttribution ? _self.hasSeenAttribution : hasSeenAttribution // ignore: cast_nullable_to_non_nullable
as bool,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as GuideFormat,
  ));
}

/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GuideIdCopyWith<$Res> get id {
  
  return $GuideIdCopyWith<$Res>(_self.id, (value) {
    return _then(_self.copyWith(id: value));
  });
}/// Create a copy of GuideItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameIdCopyWith<$Res> get gameId {
  
  return $GameIdCopyWith<$Res>(_self.gameId, (value) {
    return _then(_self.copyWith(gameId: value));
  });
}
}

// dart format on
