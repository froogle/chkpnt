// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state provider for backup operations

@ProviderFor(BackupState)
final backupStateProvider = BackupStateProvider._();

/// Riverpod state provider for backup operations
final class BackupStateProvider
    extends $NotifierProvider<BackupState, BackupOperationState> {
  /// Riverpod state provider for backup operations
  BackupStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupStateHash();

  @$internal
  @override
  BackupState create() => BackupState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupOperationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupOperationState>(value),
    );
  }
}

String _$backupStateHash() => r'64488b4ec520ab7b5efc849afe327e621d2b14fb';

/// Riverpod state provider for backup operations

abstract class _$BackupState extends $Notifier<BackupOperationState> {
  BackupOperationState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BackupOperationState, BackupOperationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BackupOperationState, BackupOperationState>,
              BackupOperationState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
