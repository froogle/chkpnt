// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BackupOperationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupOperationStateCopyWith<$Res> {
  factory $BackupOperationStateCopyWith(
    BackupOperationState value,
    $Res Function(BackupOperationState) then,
  ) = _$BackupOperationStateCopyWithImpl<$Res, BackupOperationState>;
}

/// @nodoc
class _$BackupOperationStateCopyWithImpl<
  $Res,
  $Val extends BackupOperationState
>
    implements $BackupOperationStateCopyWith<$Res> {
  _$BackupOperationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
    _$IdleImpl value,
    $Res Function(_$IdleImpl) then,
  ) = __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
    : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$IdleImpl implements _Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'BackupOperationState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class _Idle implements BackupOperationState {
  const factory _Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$SelectingDirectoryImplCopyWith<$Res> {
  factory _$$SelectingDirectoryImplCopyWith(
    _$SelectingDirectoryImpl value,
    $Res Function(_$SelectingDirectoryImpl) then,
  ) = __$$SelectingDirectoryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SelectingDirectoryImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$SelectingDirectoryImpl>
    implements _$$SelectingDirectoryImplCopyWith<$Res> {
  __$$SelectingDirectoryImplCopyWithImpl(
    _$SelectingDirectoryImpl _value,
    $Res Function(_$SelectingDirectoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SelectingDirectoryImpl implements _SelectingDirectory {
  const _$SelectingDirectoryImpl();

  @override
  String toString() {
    return 'BackupOperationState.selectingDirectory()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SelectingDirectoryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return selectingDirectory();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return selectingDirectory?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (selectingDirectory != null) {
      return selectingDirectory();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return selectingDirectory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return selectingDirectory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (selectingDirectory != null) {
      return selectingDirectory(this);
    }
    return orElse();
  }
}

abstract class _SelectingDirectory implements BackupOperationState {
  const factory _SelectingDirectory() = _$SelectingDirectoryImpl;
}

/// @nodoc
abstract class _$$SelectingFileImplCopyWith<$Res> {
  factory _$$SelectingFileImplCopyWith(
    _$SelectingFileImpl value,
    $Res Function(_$SelectingFileImpl) then,
  ) = __$$SelectingFileImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SelectingFileImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$SelectingFileImpl>
    implements _$$SelectingFileImplCopyWith<$Res> {
  __$$SelectingFileImplCopyWithImpl(
    _$SelectingFileImpl _value,
    $Res Function(_$SelectingFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SelectingFileImpl implements _SelectingFile {
  const _$SelectingFileImpl();

  @override
  String toString() {
    return 'BackupOperationState.selectingFile()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SelectingFileImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return selectingFile();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return selectingFile?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (selectingFile != null) {
      return selectingFile();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return selectingFile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return selectingFile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (selectingFile != null) {
      return selectingFile(this);
    }
    return orElse();
  }
}

abstract class _SelectingFile implements BackupOperationState {
  const factory _SelectingFile() = _$SelectingFileImpl;
}

/// @nodoc
abstract class _$$CreatingBackupImplCopyWith<$Res> {
  factory _$$CreatingBackupImplCopyWith(
    _$CreatingBackupImpl value,
    $Res Function(_$CreatingBackupImpl) then,
  ) = __$$CreatingBackupImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress, String currentStep, String? statusMessage});
}

/// @nodoc
class __$$CreatingBackupImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$CreatingBackupImpl>
    implements _$$CreatingBackupImplCopyWith<$Res> {
  __$$CreatingBackupImplCopyWithImpl(
    _$CreatingBackupImpl _value,
    $Res Function(_$CreatingBackupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? currentStep = null,
    Object? statusMessage = freezed,
  }) {
    return _then(
      _$CreatingBackupImpl(
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

class _$CreatingBackupImpl implements _CreatingBackup {
  const _$CreatingBackupImpl({
    required this.progress,
    required this.currentStep,
    this.statusMessage,
  });

  @override
  final double progress;
  @override
  final String currentStep;
  @override
  final String? statusMessage;

  @override
  String toString() {
    return 'BackupOperationState.creatingBackup(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatingBackupImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, progress, currentStep, statusMessage);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatingBackupImplCopyWith<_$CreatingBackupImpl> get copyWith =>
      __$$CreatingBackupImplCopyWithImpl<_$CreatingBackupImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return creatingBackup(progress, currentStep, statusMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return creatingBackup?.call(progress, currentStep, statusMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (creatingBackup != null) {
      return creatingBackup(progress, currentStep, statusMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return creatingBackup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return creatingBackup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (creatingBackup != null) {
      return creatingBackup(this);
    }
    return orElse();
  }
}

abstract class _CreatingBackup implements BackupOperationState {
  const factory _CreatingBackup({
    required final double progress,
    required final String currentStep,
    final String? statusMessage,
  }) = _$CreatingBackupImpl;

  double get progress;
  String get currentStep;
  String? get statusMessage;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatingBackupImplCopyWith<_$CreatingBackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RestoringBackupImplCopyWith<$Res> {
  factory _$$RestoringBackupImplCopyWith(
    _$RestoringBackupImpl value,
    $Res Function(_$RestoringBackupImpl) then,
  ) = __$$RestoringBackupImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress, String currentStep, String? statusMessage});
}

/// @nodoc
class __$$RestoringBackupImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$RestoringBackupImpl>
    implements _$$RestoringBackupImplCopyWith<$Res> {
  __$$RestoringBackupImplCopyWithImpl(
    _$RestoringBackupImpl _value,
    $Res Function(_$RestoringBackupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? currentStep = null,
    Object? statusMessage = freezed,
  }) {
    return _then(
      _$RestoringBackupImpl(
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

class _$RestoringBackupImpl implements _RestoringBackup {
  const _$RestoringBackupImpl({
    required this.progress,
    required this.currentStep,
    this.statusMessage,
  });

  @override
  final double progress;
  @override
  final String currentStep;
  @override
  final String? statusMessage;

  @override
  String toString() {
    return 'BackupOperationState.restoringBackup(progress: $progress, currentStep: $currentStep, statusMessage: $statusMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestoringBackupImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, progress, currentStep, statusMessage);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestoringBackupImplCopyWith<_$RestoringBackupImpl> get copyWith =>
      __$$RestoringBackupImplCopyWithImpl<_$RestoringBackupImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return restoringBackup(progress, currentStep, statusMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return restoringBackup?.call(progress, currentStep, statusMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (restoringBackup != null) {
      return restoringBackup(progress, currentStep, statusMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return restoringBackup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return restoringBackup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (restoringBackup != null) {
      return restoringBackup(this);
    }
    return orElse();
  }
}

abstract class _RestoringBackup implements BackupOperationState {
  const factory _RestoringBackup({
    required final double progress,
    required final String currentStep,
    final String? statusMessage,
  }) = _$RestoringBackupImpl;

  double get progress;
  String get currentStep;
  String? get statusMessage;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestoringBackupImplCopyWith<_$RestoringBackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidatingBackupImplCopyWith<$Res> {
  factory _$$ValidatingBackupImplCopyWith(
    _$ValidatingBackupImpl value,
    $Res Function(_$ValidatingBackupImpl) then,
  ) = __$$ValidatingBackupImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filePath});
}

/// @nodoc
class __$$ValidatingBackupImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$ValidatingBackupImpl>
    implements _$$ValidatingBackupImplCopyWith<$Res> {
  __$$ValidatingBackupImplCopyWithImpl(
    _$ValidatingBackupImpl _value,
    $Res Function(_$ValidatingBackupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filePath = null}) {
    return _then(
      _$ValidatingBackupImpl(
        filePath:
            null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$ValidatingBackupImpl implements _ValidatingBackup {
  const _$ValidatingBackupImpl({required this.filePath});

  @override
  final String filePath;

  @override
  String toString() {
    return 'BackupOperationState.validatingBackup(filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidatingBackupImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filePath);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidatingBackupImplCopyWith<_$ValidatingBackupImpl> get copyWith =>
      __$$ValidatingBackupImplCopyWithImpl<_$ValidatingBackupImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return validatingBackup(filePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return validatingBackup?.call(filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (validatingBackup != null) {
      return validatingBackup(filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return validatingBackup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return validatingBackup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (validatingBackup != null) {
      return validatingBackup(this);
    }
    return orElse();
  }
}

abstract class _ValidatingBackup implements BackupOperationState {
  const factory _ValidatingBackup({required final String filePath}) =
      _$ValidatingBackupImpl;

  String get filePath;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidatingBackupImplCopyWith<_$ValidatingBackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConfirmingRestoreImplCopyWith<$Res> {
  factory _$$ConfirmingRestoreImplCopyWith(
    _$ConfirmingRestoreImpl value,
    $Res Function(_$ConfirmingRestoreImpl) then,
  ) = __$$ConfirmingRestoreImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String backupFilePath, BackupMetadata metadata});

  $BackupMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$ConfirmingRestoreImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$ConfirmingRestoreImpl>
    implements _$$ConfirmingRestoreImplCopyWith<$Res> {
  __$$ConfirmingRestoreImplCopyWithImpl(
    _$ConfirmingRestoreImpl _value,
    $Res Function(_$ConfirmingRestoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? backupFilePath = null, Object? metadata = null}) {
    return _then(
      _$ConfirmingRestoreImpl(
        backupFilePath:
            null == backupFilePath
                ? _value.backupFilePath
                : backupFilePath // ignore: cast_nullable_to_non_nullable
                    as String,
        metadata:
            null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as BackupMetadata,
      ),
    );
  }

  /// Create a copy of BackupOperationState
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

class _$ConfirmingRestoreImpl implements _ConfirmingRestore {
  const _$ConfirmingRestoreImpl({
    required this.backupFilePath,
    required this.metadata,
  });

  @override
  final String backupFilePath;
  @override
  final BackupMetadata metadata;

  @override
  String toString() {
    return 'BackupOperationState.confirmingRestore(backupFilePath: $backupFilePath, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmingRestoreImpl &&
            (identical(other.backupFilePath, backupFilePath) ||
                other.backupFilePath == backupFilePath) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @override
  int get hashCode => Object.hash(runtimeType, backupFilePath, metadata);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmingRestoreImplCopyWith<_$ConfirmingRestoreImpl> get copyWith =>
      __$$ConfirmingRestoreImplCopyWithImpl<_$ConfirmingRestoreImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return confirmingRestore(backupFilePath, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return confirmingRestore?.call(backupFilePath, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (confirmingRestore != null) {
      return confirmingRestore(backupFilePath, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return confirmingRestore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return confirmingRestore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (confirmingRestore != null) {
      return confirmingRestore(this);
    }
    return orElse();
  }
}

abstract class _ConfirmingRestore implements BackupOperationState {
  const factory _ConfirmingRestore({
    required final String backupFilePath,
    required final BackupMetadata metadata,
  }) = _$ConfirmingRestoreImpl;

  String get backupFilePath;
  BackupMetadata get metadata;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmingRestoreImplCopyWith<_$ConfirmingRestoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
    _$SuccessImpl value,
    $Res Function(_$SuccessImpl) then,
  ) = __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? filePath});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
    _$SuccessImpl _value,
    $Res Function(_$SuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? filePath = freezed}) {
    return _then(
      _$SuccessImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        filePath:
            freezed == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl({required this.message, this.filePath});

  @override
  final String message;
  @override
  final String? filePath;

  @override
  String toString() {
    return 'BackupOperationState.success(message: $message, filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, filePath);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return success(message, filePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return success?.call(message, filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message, filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements BackupOperationState {
  const factory _Success({
    required final String message,
    final String? filePath,
  }) = _$SuccessImpl;

  String get message;
  String? get filePath;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? code, dynamic originalError});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BackupOperationStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
    Object? originalError = freezed,
  }) {
    return _then(
      _$ErrorImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        code:
            freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String?,
        originalError:
            freezed == originalError
                ? _value.originalError
                : originalError // ignore: cast_nullable_to_non_nullable
                    as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message, this.code, this.originalError});

  @override
  final String message;
  @override
  final String? code;
  @override
  final dynamic originalError;

  @override
  String toString() {
    return 'BackupOperationState.error(message: $message, code: $code, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(
              other.originalError,
              originalError,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    code,
    const DeepCollectionEquality().hash(originalError),
  );

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() selectingDirectory,
    required TResult Function() selectingFile,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    creatingBackup,
    required TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )
    restoringBackup,
    required TResult Function(String filePath) validatingBackup,
    required TResult Function(String backupFilePath, BackupMetadata metadata)
    confirmingRestore,
    required TResult Function(String message, String? filePath) success,
    required TResult Function(
      String message,
      String? code,
      dynamic originalError,
    )
    error,
  }) {
    return error(message, code, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? selectingDirectory,
    TResult? Function()? selectingFile,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult? Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult? Function(String filePath)? validatingBackup,
    TResult? Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult? Function(String message, String? filePath)? success,
    TResult? Function(String message, String? code, dynamic originalError)?
    error,
  }) {
    return error?.call(message, code, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? selectingDirectory,
    TResult Function()? selectingFile,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    creatingBackup,
    TResult Function(
      double progress,
      String currentStep,
      String? statusMessage,
    )?
    restoringBackup,
    TResult Function(String filePath)? validatingBackup,
    TResult Function(String backupFilePath, BackupMetadata metadata)?
    confirmingRestore,
    TResult Function(String message, String? filePath)? success,
    TResult Function(String message, String? code, dynamic originalError)?
    error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, code, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Idle value) idle,
    required TResult Function(_SelectingDirectory value) selectingDirectory,
    required TResult Function(_SelectingFile value) selectingFile,
    required TResult Function(_CreatingBackup value) creatingBackup,
    required TResult Function(_RestoringBackup value) restoringBackup,
    required TResult Function(_ValidatingBackup value) validatingBackup,
    required TResult Function(_ConfirmingRestore value) confirmingRestore,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Idle value)? idle,
    TResult? Function(_SelectingDirectory value)? selectingDirectory,
    TResult? Function(_SelectingFile value)? selectingFile,
    TResult? Function(_CreatingBackup value)? creatingBackup,
    TResult? Function(_RestoringBackup value)? restoringBackup,
    TResult? Function(_ValidatingBackup value)? validatingBackup,
    TResult? Function(_ConfirmingRestore value)? confirmingRestore,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Idle value)? idle,
    TResult Function(_SelectingDirectory value)? selectingDirectory,
    TResult Function(_SelectingFile value)? selectingFile,
    TResult Function(_CreatingBackup value)? creatingBackup,
    TResult Function(_RestoringBackup value)? restoringBackup,
    TResult Function(_ValidatingBackup value)? validatingBackup,
    TResult Function(_ConfirmingRestore value)? confirmingRestore,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements BackupOperationState {
  const factory _Error({
    required final String message,
    final String? code,
    final dynamic originalError,
  }) = _$ErrorImpl;

  String get message;
  String? get code;
  dynamic get originalError;

  /// Create a copy of BackupOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
