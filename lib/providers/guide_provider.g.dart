// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$guideRepositoryHash() => r'44cdd094e42d595b0b320d9589c0fa0f9b36caab';

/// See also [guideRepository].
@ProviderFor(guideRepository)
final guideRepositoryProvider = AutoDisposeProvider<GuideRepository>.internal(
  guideRepository,
  name: r'guideRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$guideRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GuideRepositoryRef = AutoDisposeProviderRef<GuideRepository>;
String _$guidesForGameStreamHash() =>
    r'3ed55f171f375475349120138458e9e25b40b34a';

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

/// See also [guidesForGameStream].
@ProviderFor(guidesForGameStream)
const guidesForGameStreamProvider = GuidesForGameStreamFamily();

/// See also [guidesForGameStream].
class GuidesForGameStreamFamily extends Family<AsyncValue<List<GuideItem>>> {
  /// See also [guidesForGameStream].
  const GuidesForGameStreamFamily();

  /// See also [guidesForGameStream].
  GuidesForGameStreamProvider call(GameId gameId) {
    return GuidesForGameStreamProvider(gameId);
  }

  @override
  GuidesForGameStreamProvider getProviderOverride(
    covariant GuidesForGameStreamProvider provider,
  ) {
    return call(provider.gameId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'guidesForGameStreamProvider';
}

/// See also [guidesForGameStream].
class GuidesForGameStreamProvider
    extends AutoDisposeStreamProvider<List<GuideItem>> {
  /// See also [guidesForGameStream].
  GuidesForGameStreamProvider(GameId gameId)
    : this._internal(
        (ref) => guidesForGameStream(ref as GuidesForGameStreamRef, gameId),
        from: guidesForGameStreamProvider,
        name: r'guidesForGameStreamProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$guidesForGameStreamHash,
        dependencies: GuidesForGameStreamFamily._dependencies,
        allTransitiveDependencies:
            GuidesForGameStreamFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GuidesForGameStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameId,
  }) : super.internal();

  final GameId gameId;

  @override
  Override overrideWith(
    Stream<List<GuideItem>> Function(GuidesForGameStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuidesForGameStreamProvider._internal(
        (ref) => create(ref as GuidesForGameStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameId: gameId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<GuideItem>> createElement() {
    return _GuidesForGameStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuidesForGameStreamProvider && other.gameId == gameId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GuidesForGameStreamRef on AutoDisposeStreamProviderRef<List<GuideItem>> {
  /// The parameter `gameId` of this provider.
  GameId get gameId;
}

class _GuidesForGameStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<GuideItem>>
    with GuidesForGameStreamRef {
  _GuidesForGameStreamProviderElement(super.provider);

  @override
  GameId get gameId => (origin as GuidesForGameStreamProvider).gameId;
}

String _$guidesForGameHash() => r'adf71186a72673bbf288edfeb26e3b97d907cca2';

abstract class _$GuidesForGame
    extends BuildlessAutoDisposeNotifier<List<GuideItem>> {
  late final GameId gameId;

  List<GuideItem> build(GameId gameId);
}

/// See also [GuidesForGame].
@ProviderFor(GuidesForGame)
const guidesForGameProvider = GuidesForGameFamily();

/// See also [GuidesForGame].
class GuidesForGameFamily extends Family<List<GuideItem>> {
  /// See also [GuidesForGame].
  const GuidesForGameFamily();

  /// See also [GuidesForGame].
  GuidesForGameProvider call(GameId gameId) {
    return GuidesForGameProvider(gameId);
  }

  @override
  GuidesForGameProvider getProviderOverride(
    covariant GuidesForGameProvider provider,
  ) {
    return call(provider.gameId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'guidesForGameProvider';
}

/// See also [GuidesForGame].
class GuidesForGameProvider
    extends AutoDisposeNotifierProviderImpl<GuidesForGame, List<GuideItem>> {
  /// See also [GuidesForGame].
  GuidesForGameProvider(GameId gameId)
    : this._internal(
        () => GuidesForGame()..gameId = gameId,
        from: guidesForGameProvider,
        name: r'guidesForGameProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$guidesForGameHash,
        dependencies: GuidesForGameFamily._dependencies,
        allTransitiveDependencies:
            GuidesForGameFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GuidesForGameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameId,
  }) : super.internal();

  final GameId gameId;

  @override
  List<GuideItem> runNotifierBuild(covariant GuidesForGame notifier) {
    return notifier.build(gameId);
  }

  @override
  Override overrideWith(GuidesForGame Function() create) {
    return ProviderOverride(
      origin: this,
      override: GuidesForGameProvider._internal(
        () => create()..gameId = gameId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameId: gameId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GuidesForGame, List<GuideItem>>
  createElement() {
    return _GuidesForGameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuidesForGameProvider && other.gameId == gameId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GuidesForGameRef on AutoDisposeNotifierProviderRef<List<GuideItem>> {
  /// The parameter `gameId` of this provider.
  GameId get gameId;
}

class _GuidesForGameProviderElement
    extends AutoDisposeNotifierProviderElement<GuidesForGame, List<GuideItem>>
    with GuidesForGameRef {
  _GuidesForGameProviderElement(super.provider);

  @override
  GameId get gameId => (origin as GuidesForGameProvider).gameId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
