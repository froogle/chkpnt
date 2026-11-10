// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameEditState)
final gameEditStateProvider = GameEditStateFamily._();

final class GameEditStateProvider
    extends $NotifierProvider<GameEditState, GameEditFormState> {
  GameEditStateProvider._({
    required GameEditStateFamily super.from,
    required GameEditContext super.argument,
  }) : super(
         retry: null,
         name: r'gameEditStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameEditStateHash();

  @override
  String toString() {
    return r'gameEditStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GameEditState create() => GameEditState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameEditFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameEditFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GameEditStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameEditStateHash() => r'87f199201f854accad57d7c5b75833b52f59c7ca';

final class GameEditStateFamily extends $Family
    with
        $ClassFamilyOverride<
          GameEditState,
          GameEditFormState,
          GameEditFormState,
          GameEditFormState,
          GameEditContext
        > {
  GameEditStateFamily._()
    : super(
        retry: null,
        name: r'gameEditStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameEditStateProvider call(GameEditContext context) =>
      GameEditStateProvider._(argument: context, from: this);

  @override
  String toString() => r'gameEditStateProvider';
}

abstract class _$GameEditState extends $Notifier<GameEditFormState> {
  late final _$args = ref.$arg as GameEditContext;
  GameEditContext get context => _$args;

  GameEditFormState build(GameEditContext context);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GameEditFormState, GameEditFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameEditFormState, GameEditFormState>,
              GameEditFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
