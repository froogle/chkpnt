// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameImageHash() => r'fdf973fe399f1ff49676445525ce980114f90df4';

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

/// See also [gameImage].
@ProviderFor(gameImage)
const gameImageProvider = GameImageFamily();

/// See also [gameImage].
class GameImageFamily extends Family<AsyncValue<String?>> {
  /// See also [gameImage].
  const GameImageFamily();

  /// See also [gameImage].
  GameImageProvider call(String imagePath) {
    return GameImageProvider(imagePath);
  }

  @override
  GameImageProvider getProviderOverride(covariant GameImageProvider provider) {
    return call(provider.imagePath);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameImageProvider';
}

/// See also [gameImage].
class GameImageProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [gameImage].
  GameImageProvider(String imagePath)
    : this._internal(
        (ref) => gameImage(ref as GameImageRef, imagePath),
        from: gameImageProvider,
        name: r'gameImageProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gameImageHash,
        dependencies: GameImageFamily._dependencies,
        allTransitiveDependencies: GameImageFamily._allTransitiveDependencies,
        imagePath: imagePath,
      );

  GameImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imagePath,
  }) : super.internal();

  final String imagePath;

  @override
  Override overrideWith(
    FutureOr<String?> Function(GameImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameImageProvider._internal(
        (ref) => create(ref as GameImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imagePath: imagePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _GameImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameImageProvider && other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imagePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GameImageRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `imagePath` of this provider.
  String get imagePath;
}

class _GameImageProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with GameImageRef {
  _GameImageProviderElement(super.provider);

  @override
  String get imagePath => (origin as GameImageProvider).imagePath;
}

String _$searchQueryHash() => r'90108134dff9ce4ac3cd7f9ecc034bf7f9630f95';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider = NotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = Notifier<String>;
String _$selectedPlatformHash() => r'582ffa04f95b8cbb013e77422e36b012106472c3';

/// See also [SelectedPlatform].
@ProviderFor(SelectedPlatform)
final selectedPlatformProvider =
    NotifierProvider<SelectedPlatform, String>.internal(
      SelectedPlatform.new,
      name: r'selectedPlatformProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedPlatformHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPlatform = Notifier<String>;
String _$backlogSortHash() => r'13a4645f9230ba2e2dab019b64630ddc60caea4d';

/// See also [BacklogSort].
@ProviderFor(BacklogSort)
final backlogSortProvider =
    NotifierProvider<BacklogSort, BacklogSortType>.internal(
      BacklogSort.new,
      name: r'backlogSortProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backlogSortHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BacklogSort = Notifier<BacklogSortType>;
String _$backlogSortDirectionStateHash() =>
    r'49fc31166ce8f3d08b6c47ee9adad12f6511b17e';

/// See also [BacklogSortDirectionState].
@ProviderFor(BacklogSortDirectionState)
final backlogSortDirectionStateProvider =
    NotifierProvider<BacklogSortDirectionState, SortDirection>.internal(
      BacklogSortDirectionState.new,
      name: r'backlogSortDirectionStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backlogSortDirectionStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BacklogSortDirectionState = Notifier<SortDirection>;
String _$backlogShowBacklogFilterHash() =>
    r'94aab24c0e69689fe62e0e19c89e5274489e11ad';

/// See also [BacklogShowBacklogFilter].
@ProviderFor(BacklogShowBacklogFilter)
final backlogShowBacklogFilterProvider =
    NotifierProvider<BacklogShowBacklogFilter, bool>.internal(
      BacklogShowBacklogFilter.new,
      name: r'backlogShowBacklogFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backlogShowBacklogFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BacklogShowBacklogFilter = Notifier<bool>;
String _$backlogShowOngoingFilterHash() =>
    r'e2e97a49834c372c176c1b43353ba693268431b8';

/// See also [BacklogShowOngoingFilter].
@ProviderFor(BacklogShowOngoingFilter)
final backlogShowOngoingFilterProvider =
    NotifierProvider<BacklogShowOngoingFilter, bool>.internal(
      BacklogShowOngoingFilter.new,
      name: r'backlogShowOngoingFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backlogShowOngoingFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BacklogShowOngoingFilter = Notifier<bool>;
String _$collectionShowPhysicalFilterHash() =>
    r'6e3aecb06956be6b6f2c4adc7b3708e86dfbe905';

/// See also [CollectionShowPhysicalFilter].
@ProviderFor(CollectionShowPhysicalFilter)
final collectionShowPhysicalFilterProvider =
    NotifierProvider<CollectionShowPhysicalFilter, bool>.internal(
      CollectionShowPhysicalFilter.new,
      name: r'collectionShowPhysicalFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$collectionShowPhysicalFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CollectionShowPhysicalFilter = Notifier<bool>;
String _$collectionShowDigitalFilterHash() =>
    r'85a7d8b921fff4414b4f144f0febc1a9adae536a';

/// See also [CollectionShowDigitalFilter].
@ProviderFor(CollectionShowDigitalFilter)
final collectionShowDigitalFilterProvider =
    NotifierProvider<CollectionShowDigitalFilter, bool>.internal(
      CollectionShowDigitalFilter.new,
      name: r'collectionShowDigitalFilterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$collectionShowDigitalFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CollectionShowDigitalFilter = Notifier<bool>;
String _$sectionExpansionHash() => r'd39dab82a28e9d915afafb05d2fc7208fa8bde5d';

/// See also [SectionExpansion].
@ProviderFor(SectionExpansion)
final sectionExpansionProvider =
    NotifierProvider<SectionExpansion, Map<String, bool>>.internal(
      SectionExpansion.new,
      name: r'sectionExpansionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sectionExpansionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SectionExpansion = Notifier<Map<String, bool>>;
String _$gameEditStateHash() => r'652f80ab03cc9dbcffe16290367937cfab19d3d9';

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
