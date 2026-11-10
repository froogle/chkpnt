// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupOperationState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupOperationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BackupOperationState()';
}


}

/// @nodoc
class $BackupOperationStateCopyWith<$Res>  {
$BackupOperationStateCopyWith(BackupOperationState _, $Res Function(BackupOperationState) __);
}


/// Adds pattern-matching-related methods to [BackupOperationState].
extension BackupOperationStatePatterns on BackupOperationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( _SelectingDirectory value)?  selectingDirectory,TResult Function( _SelectingFile value)?  selectingFile,TResult Function( _CreatingBackup value)?  creatingBackup,TResult Function( _RestoringBackup value)?  restoringBackup,TResult Function( _ValidatingBackup value)?  validatingBackup,TResult Function( _ConfirmingRestore value)?  confirmingRestore,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _SelectingDirectory() when selectingDirectory != null:
return selectingDirectory(_that);case _SelectingFile() when selectingFile != null:
return selectingFile(_that);case _CreatingBackup() when creatingBackup != null:
return creatingBackup(_that);case _RestoringBackup() when restoringBackup != null:
return restoringBackup(_that);case _ValidatingBackup() when validatingBackup != null:
return validatingBackup(_that);case _ConfirmingRestore() when confirmingRestore != null:
return confirmingRestore(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( _SelectingDirectory value)  selectingDirectory,required TResult Function( _SelectingFile value)  selectingFile,required TResult Function( _CreatingBackup value)  creatingBackup,required TResult Function( _RestoringBackup value)  restoringBackup,required TResult Function( _ValidatingBackup value)  validatingBackup,required TResult Function( _ConfirmingRestore value)  confirmingRestore,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case _SelectingDirectory():
return selectingDirectory(_that);case _SelectingFile():
return selectingFile(_that);case _CreatingBackup():
return creatingBackup(_that);case _RestoringBackup():
return restoringBackup(_that);case _ValidatingBackup():
return validatingBackup(_that);case _ConfirmingRestore():
return confirmingRestore(_that);case _Success():
return success(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( _SelectingDirectory value)?  selectingDirectory,TResult? Function( _SelectingFile value)?  selectingFile,TResult? Function( _CreatingBackup value)?  creatingBackup,TResult? Function( _RestoringBackup value)?  restoringBackup,TResult? Function( _ValidatingBackup value)?  validatingBackup,TResult? Function( _ConfirmingRestore value)?  confirmingRestore,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case _SelectingDirectory() when selectingDirectory != null:
return selectingDirectory(_that);case _SelectingFile() when selectingFile != null:
return selectingFile(_that);case _CreatingBackup() when creatingBackup != null:
return creatingBackup(_that);case _RestoringBackup() when restoringBackup != null:
return restoringBackup(_that);case _ValidatingBackup() when validatingBackup != null:
return validatingBackup(_that);case _ConfirmingRestore() when confirmingRestore != null:
return confirmingRestore(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  selectingDirectory,TResult Function()?  selectingFile,TResult Function( double progress,  String currentStep,  String? statusMessage)?  creatingBackup,TResult Function( double progress,  String currentStep,  String? statusMessage)?  restoringBackup,TResult Function( String filePath)?  validatingBackup,TResult Function( String backupFilePath,  BackupMetadata metadata)?  confirmingRestore,TResult Function( String message,  String? filePath)?  success,TResult Function( String message,  String? code,  dynamic originalError)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _SelectingDirectory() when selectingDirectory != null:
return selectingDirectory();case _SelectingFile() when selectingFile != null:
return selectingFile();case _CreatingBackup() when creatingBackup != null:
return creatingBackup(_that.progress,_that.currentStep,_that.statusMessage);case _RestoringBackup() when restoringBackup != null:
return restoringBackup(_that.progress,_that.currentStep,_that.statusMessage);case _ValidatingBackup() when validatingBackup != null:
return validatingBackup(_that.filePath);case _ConfirmingRestore() when confirmingRestore != null:
return confirmingRestore(_that.backupFilePath,_that.metadata);case _Success() when success != null:
return success(_that.message,_that.filePath);case _Error() when error != null:
return error(_that.message,_that.code,_that.originalError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  selectingDirectory,required TResult Function()  selectingFile,required TResult Function( double progress,  String currentStep,  String? statusMessage)  creatingBackup,required TResult Function( double progress,  String currentStep,  String? statusMessage)  restoringBackup,required TResult Function( String filePath)  validatingBackup,required TResult Function( String backupFilePath,  BackupMetadata metadata)  confirmingRestore,required TResult Function( String message,  String? filePath)  success,required TResult Function( String message,  String? code,  dynamic originalError)  error,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case _SelectingDirectory():
return selectingDirectory();case _SelectingFile():
return selectingFile();case _CreatingBackup():
return creatingBackup(_that.progress,_that.currentStep,_that.statusMessage);case _RestoringBackup():
return restoringBackup(_that.progress,_that.currentStep,_that.statusMessage);case _ValidatingBackup():
return validatingBackup(_that.filePath);case _ConfirmingRestore():
return confirmingRestore(_that.backupFilePath,_that.metadata);case _Success():
return success(_that.message,_that.filePath);case _Error():
return error(_that.message,_that.code,_that.originalError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  selectingDirectory,TResult? Function()?  selectingFile,TResult? Function( double progress,  String currentStep,  String? statusMessage)?  creatingBackup,TResult? Function( double progress,  String currentStep,  String? statusMessage)?  restoringBackup,TResult? Function( String filePath)?  validatingBackup,TResult? Function( String backupFilePath,  BackupMetadata metadata)?  confirmingRestore,TResult? Function( String message,  String? filePath)?  success,TResult? Function( String message,  String? code,  dynamic originalError)?  error,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case _SelectingDirectory() when selectingDirectory != null:
return selectingDirectory();case _SelectingFile() when selectingFile != null:
return selectingFile();case _CreatingBackup() when creatingBackup != null:
return creatingBackup(_that.progress,_that.currentStep,_that.statusMessage);case _RestoringBackup() when restoringBackup != null:
return restoringBackup(_that.progress,_that.currentStep,_that.statusMessage);case _ValidatingBackup() when validatingBackup != null:
return validatingBackup(_that.filePath);case _ConfirmingRestore() when confirmingRestore != null:
return confirmingRestore(_that.backupFilePath,_that.metadata);case _Success() when success != null:
return success(_that.message,_that.filePath);case _Error() when error != null:
return error(_that.message,_that.code,_that.originalError);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements BackupOperationState {
  const _Idle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BackupOperationState.idle()';
}


}




/// @nodoc


class _SelectingDirectory implements BackupOperationState {
  const _SelectingDirectory();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectingDirectory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BackupOperationState.selectingDirectory()';
}


}




/// @nodoc


class _SelectingFile implements BackupOperationState {
  const _SelectingFile();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectingFile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BackupOperationState.selectingFile()';
}


}




/// @nodoc


class _CreatingBackup implements BackupOperationState {
  const _CreatingBackup({required this.progress, required this.currentStep, this.statusMessage});
  

 final  double progress;
 final  String currentStep;
 final  String? statusMessage;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatingBackupCopyWith<_CreatingBackup> get copyWith => __$CreatingBackupCopyWithImpl<_CreatingBackup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatingBackup&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progress,currentStep,statusMessage);
}

@override
String toString() {
    return 'BackupOperationState.creatingBackup(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$CreatingBackupCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$CreatingBackupCopyWith(_CreatingBackup value, $Res Function(_CreatingBackup) _then) = __$CreatingBackupCopyWithImpl;
@useResult
$Res call({
 double progress, String currentStep, String? statusMessage
});




}
/// @nodoc
class __$CreatingBackupCopyWithImpl<$Res>
    implements _$CreatingBackupCopyWith<$Res> {
  __$CreatingBackupCopyWithImpl(this._self, this._then);

  final _CreatingBackup _self;
  final $Res Function(_CreatingBackup) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? currentStep = null,Object? statusMessage = freezed,}) {
  return _then(_CreatingBackup(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _RestoringBackup implements BackupOperationState {
  const _RestoringBackup({required this.progress, required this.currentStep, this.statusMessage});
  

 final  double progress;
 final  String currentStep;
 final  String? statusMessage;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestoringBackupCopyWith<_RestoringBackup> get copyWith => __$RestoringBackupCopyWithImpl<_RestoringBackup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoringBackup&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,progress,currentStep,statusMessage);
}

@override
String toString() {
    return 'BackupOperationState.restoringBackup(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$RestoringBackupCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$RestoringBackupCopyWith(_RestoringBackup value, $Res Function(_RestoringBackup) _then) = __$RestoringBackupCopyWithImpl;
@useResult
$Res call({
 double progress, String currentStep, String? statusMessage
});




}
/// @nodoc
class __$RestoringBackupCopyWithImpl<$Res>
    implements _$RestoringBackupCopyWith<$Res> {
  __$RestoringBackupCopyWithImpl(this._self, this._then);

  final _RestoringBackup _self;
  final $Res Function(_RestoringBackup) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? currentStep = null,Object? statusMessage = freezed,}) {
  return _then(_RestoringBackup(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ValidatingBackup implements BackupOperationState {
  const _ValidatingBackup({required this.filePath});
  

 final  String filePath;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValidatingBackupCopyWith<_ValidatingBackup> get copyWith => __$ValidatingBackupCopyWithImpl<_ValidatingBackup>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValidatingBackup&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,filePath);
}

@override
String toString() {
    return 'BackupOperationState.validatingBackup(filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$ValidatingBackupCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$ValidatingBackupCopyWith(_ValidatingBackup value, $Res Function(_ValidatingBackup) _then) = __$ValidatingBackupCopyWithImpl;
@useResult
$Res call({
 String filePath
});




}
/// @nodoc
class __$ValidatingBackupCopyWithImpl<$Res>
    implements _$ValidatingBackupCopyWith<$Res> {
  __$ValidatingBackupCopyWithImpl(this._self, this._then);

  final _ValidatingBackup _self;
  final $Res Function(_ValidatingBackup) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filePath = null,}) {
  return _then(_ValidatingBackup(
filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ConfirmingRestore implements BackupOperationState {
  const _ConfirmingRestore({required this.backupFilePath, required this.metadata});
  

 final  String backupFilePath;
 final  BackupMetadata metadata;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmingRestoreCopyWith<_ConfirmingRestore> get copyWith => __$ConfirmingRestoreCopyWithImpl<_ConfirmingRestore>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmingRestore&&(identical(other.backupFilePath, backupFilePath) || other.backupFilePath == backupFilePath)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}


@override
int get hashCode {
    return Object.hash(runtimeType,backupFilePath,metadata);
}

@override
String toString() {
    return 'BackupOperationState.confirmingRestore(backupFilePath: $backupFilePath, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ConfirmingRestoreCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$ConfirmingRestoreCopyWith(_ConfirmingRestore value, $Res Function(_ConfirmingRestore) _then) = __$ConfirmingRestoreCopyWithImpl;
@useResult
$Res call({
 String backupFilePath, BackupMetadata metadata
});


$BackupMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ConfirmingRestoreCopyWithImpl<$Res>
    implements _$ConfirmingRestoreCopyWith<$Res> {
  __$ConfirmingRestoreCopyWithImpl(this._self, this._then);

  final _ConfirmingRestore _self;
  final $Res Function(_ConfirmingRestore) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? backupFilePath = null,Object? metadata = null,}) {
  return _then(_ConfirmingRestore(
backupFilePath: null == backupFilePath ? _self.backupFilePath : backupFilePath // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as BackupMetadata,
  ));
}

/// Create a copy of BackupOperationState
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


class _Success implements BackupOperationState {
  const _Success({required this.message, this.filePath});
  

 final  String message;
 final  String? filePath;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.message, message) || other.message == message)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,filePath);
}

@override
String toString() {
    return 'BackupOperationState.success(message: $message, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 String message, String? filePath
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? filePath = freezed,}) {
  return _then(_Success(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements BackupOperationState {
  const _Error({required this.message, this.code, this.originalError});
  

 final  String message;
 final  String? code;
 final  dynamic originalError;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.originalError, originalError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message,code,const DeepCollectionEquality().hash(originalError));
}

@override
String toString() {
    return 'BackupOperationState.error(message: $message, code: $code, originalError: $originalError)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $BackupOperationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? code, dynamic originalError
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of BackupOperationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = freezed,Object? originalError = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,originalError: freezed == originalError ? _self.originalError : originalError // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
