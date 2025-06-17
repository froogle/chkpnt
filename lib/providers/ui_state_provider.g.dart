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

String _$searchQueryHash() => r'5cfb8bc058f64b12d9a61421526a8ea7b414d4fa';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$selectedPlatformHash() => r'7f111f05af0609bc66521fd79225b2116a3788c3';

/// See also [SelectedPlatform].
@ProviderFor(SelectedPlatform)
final selectedPlatformProvider =
    AutoDisposeNotifierProvider<SelectedPlatform, String>.internal(
      SelectedPlatform.new,
      name: r'selectedPlatformProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedPlatformHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPlatform = AutoDisposeNotifier<String>;
String _$backlogSortHash() => r'54af127d0200d61743356b7ea674516dfe069da4';

/// See also [BacklogSort].
@ProviderFor(BacklogSort)
final backlogSortProvider =
    AutoDisposeNotifierProvider<BacklogSort, BacklogSortType>.internal(
      BacklogSort.new,
      name: r'backlogSortProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$backlogSortHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BacklogSort = AutoDisposeNotifier<BacklogSortType>;
String _$backlogSortDirectionStateHash() =>
    r'3d6b312cde1edd6aaec3430729c7a7e4a7d22fb6';

/// See also [BacklogSortDirectionState].
@ProviderFor(BacklogSortDirectionState)
final backlogSortDirectionStateProvider = AutoDisposeNotifierProvider<
  BacklogSortDirectionState,
  SortDirection
>.internal(
  BacklogSortDirectionState.new,
  name: r'backlogSortDirectionStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backlogSortDirectionStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BacklogSortDirectionState = AutoDisposeNotifier<SortDirection>;
String _$currentScreenHash() => r'aaff6e1b0d0540586b2b99f6de3ca7140af288c1';

/// See also [CurrentScreen].
@ProviderFor(CurrentScreen)
final currentScreenProvider =
    AutoDisposeNotifierProvider<CurrentScreen, int>.internal(
      CurrentScreen.new,
      name: r'currentScreenProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentScreenHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentScreen = AutoDisposeNotifier<int>;
String _$sectionExpansionHash() => r'79ca889a67f8cbe9c5a620b8418adebea60cd433';

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
String _$gameEditStateHash() => r'e5f3554569dba357c2b2181af6a375a2a9d31ec7';

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

String _$scrollToSectionHash() => r'b80bdb2173953660f9dd72743f6fd7747b412218';

/// See also [ScrollToSection].
@ProviderFor(ScrollToSection)
final scrollToSectionProvider =
    AutoDisposeNotifierProvider<ScrollToSection, ScrollRequest?>.internal(
      ScrollToSection.new,
      name: r'scrollToSectionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$scrollToSectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScrollToSection = AutoDisposeNotifier<ScrollRequest?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
