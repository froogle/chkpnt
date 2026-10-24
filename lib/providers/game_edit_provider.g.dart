// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameEditStateHash() => r'87f199201f854accad57d7c5b75833b52f59c7ca';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GameEditState
    extends BuildlessAutoDisposeNotifier<GameEditFormState> {
  late final GameEditContext context;

  GameEditFormState build(GameEditContext context);
}

/// See also [GameEditState].
@ProviderFor(GameEditState)
const gameEditStateProvider = GameEditStateFamily();

/// See also [GameEditState].
class GameEditStateFamily extends Family<GameEditFormState> {
  /// See also [GameEditState].
  const GameEditStateFamily();

  /// See also [GameEditState].
  GameEditStateProvider call(GameEditContext context) {
    return GameEditStateProvider(context);
  }

  @override
  GameEditStateProvider getProviderOverride(
    covariant GameEditStateProvider provider,
  ) {
    return call(provider.context);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameEditStateProvider';
}

/// See also [GameEditState].
class GameEditStateProvider
    extends AutoDisposeNotifierProviderImpl<GameEditState, GameEditFormState> {
  /// See also [GameEditState].
  GameEditStateProvider(GameEditContext context)
    : this._internal(
        () => GameEditState()..context = context,
        from: gameEditStateProvider,
        name: r'gameEditStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gameEditStateHash,
        dependencies: GameEditStateFamily._dependencies,
        allTransitiveDependencies:
            GameEditStateFamily._allTransitiveDependencies,
        context: context,
      );

  GameEditStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final GameEditContext context;

  @override
  GameEditFormState runNotifierBuild(covariant GameEditState notifier) {
    return notifier.build(context);
  }

  @override
  Override overrideWith(GameEditState Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameEditStateProvider._internal(
        () => create()..context = context,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GameEditState, GameEditFormState>
  createElement() {
    return _GameEditStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameEditStateProvider && other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GameEditStateRef on AutoDisposeNotifierProviderRef<GameEditFormState> {
  /// The parameter `context` of this provider.
  GameEditContext get context;
}

class _GameEditStateProviderElement
    extends AutoDisposeNotifierProviderElement<GameEditState, GameEditFormState>
    with GameEditStateRef {
  _GameEditStateProviderElement(super.provider);

  @override
  GameEditContext get context => (origin as GameEditStateProvider).context;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
