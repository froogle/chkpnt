// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamesByStatusHash() => r'dbd2059c3d530ecb935a0cd8cfeac380b78aac17';

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

/// See also [gamesByStatus].
@ProviderFor(gamesByStatus)
const gamesByStatusProvider = GamesByStatusFamily();

/// See also [gamesByStatus].
class GamesByStatusFamily extends Family<List<GameItem>> {
  /// See also [gamesByStatus].
  const GamesByStatusFamily();

  /// See also [gamesByStatus].
  GamesByStatusProvider call(GameStatus status) {
    return GamesByStatusProvider(status);
  }

  @override
  GamesByStatusProvider getProviderOverride(
    covariant GamesByStatusProvider provider,
  ) {
    return call(provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gamesByStatusProvider';
}

/// See also [gamesByStatus].
class GamesByStatusProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [gamesByStatus].
  GamesByStatusProvider(GameStatus status)
    : this._internal(
        (ref) => gamesByStatus(ref as GamesByStatusRef, status),
        from: gamesByStatusProvider,
        name: r'gamesByStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gamesByStatusHash,
        dependencies: GamesByStatusFamily._dependencies,
        allTransitiveDependencies:
            GamesByStatusFamily._allTransitiveDependencies,
        status: status,
      );

  GamesByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final GameStatus status;

  @override
  Override overrideWith(
    List<GameItem> Function(GamesByStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GamesByStatusProvider._internal(
        (ref) => create(ref as GamesByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameItem>> createElement() {
    return _GamesByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GamesByStatusProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GamesByStatusRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `status` of this provider.
  GameStatus get status;
}

class _GamesByStatusProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with GamesByStatusRef {
  _GamesByStatusProviderElement(super.provider);

  @override
  GameStatus get status => (origin as GamesByStatusProvider).status;
}

String _$gamesByPlatformHash() => r'a550db69946b0b9aac6dc43738305bdb78d374cd';

/// See also [gamesByPlatform].
@ProviderFor(gamesByPlatform)
const gamesByPlatformProvider = GamesByPlatformFamily();

/// See also [gamesByPlatform].
class GamesByPlatformFamily extends Family<List<GameItem>> {
  /// See also [gamesByPlatform].
  const GamesByPlatformFamily();

  /// See also [gamesByPlatform].
  GamesByPlatformProvider call(String platform) {
    return GamesByPlatformProvider(platform);
  }

  @override
  GamesByPlatformProvider getProviderOverride(
    covariant GamesByPlatformProvider provider,
  ) {
    return call(provider.platform);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gamesByPlatformProvider';
}

/// See also [gamesByPlatform].
class GamesByPlatformProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [gamesByPlatform].
  GamesByPlatformProvider(String platform)
    : this._internal(
        (ref) => gamesByPlatform(ref as GamesByPlatformRef, platform),
        from: gamesByPlatformProvider,
        name: r'gamesByPlatformProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gamesByPlatformHash,
        dependencies: GamesByPlatformFamily._dependencies,
        allTransitiveDependencies:
            GamesByPlatformFamily._allTransitiveDependencies,
        platform: platform,
      );

  GamesByPlatformProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.platform,
  }) : super.internal();

  final String platform;

  @override
  Override overrideWith(
    List<GameItem> Function(GamesByPlatformRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GamesByPlatformProvider._internal(
        (ref) => create(ref as GamesByPlatformRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        platform: platform,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameItem>> createElement() {
    return _GamesByPlatformProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GamesByPlatformProvider && other.platform == platform;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, platform.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GamesByPlatformRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `platform` of this provider.
  String get platform;
}

class _GamesByPlatformProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with GamesByPlatformRef {
  _GamesByPlatformProviderElement(super.provider);

  @override
  String get platform => (origin as GamesByPlatformProvider).platform;
}

String _$filteredGamesHash() => r'df4e44265ab0fe2b70cbe710eb39fd113d453ee8';

/// See also [filteredGames].
@ProviderFor(filteredGames)
const filteredGamesProvider = FilteredGamesFamily();

/// See also [filteredGames].
class FilteredGamesFamily extends Family<List<GameItem>> {
  /// See also [filteredGames].
  const FilteredGamesFamily();

  /// See also [filteredGames].
  FilteredGamesProvider call(GameStatus status, String platform) {
    return FilteredGamesProvider(status, platform);
  }

  @override
  FilteredGamesProvider getProviderOverride(
    covariant FilteredGamesProvider provider,
  ) {
    return call(provider.status, provider.platform);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredGamesProvider';
}

/// See also [filteredGames].
class FilteredGamesProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [filteredGames].
  FilteredGamesProvider(GameStatus status, String platform)
    : this._internal(
        (ref) => filteredGames(ref as FilteredGamesRef, status, platform),
        from: filteredGamesProvider,
        name: r'filteredGamesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$filteredGamesHash,
        dependencies: FilteredGamesFamily._dependencies,
        allTransitiveDependencies:
            FilteredGamesFamily._allTransitiveDependencies,
        status: status,
        platform: platform,
      );

  FilteredGamesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.platform,
  }) : super.internal();

  final GameStatus status;
  final String platform;

  @override
  Override overrideWith(
    List<GameItem> Function(FilteredGamesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredGamesProvider._internal(
        (ref) => create(ref as FilteredGamesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        platform: platform,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameItem>> createElement() {
    return _FilteredGamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredGamesProvider &&
        other.status == status &&
        other.platform == platform;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, platform.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredGamesRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `status` of this provider.
  GameStatus get status;

  /// The parameter `platform` of this provider.
  String get platform;
}

class _FilteredGamesProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with FilteredGamesRef {
  _FilteredGamesProviderElement(super.provider);

  @override
  GameStatus get status => (origin as FilteredGamesProvider).status;
  @override
  String get platform => (origin as FilteredGamesProvider).platform;
}

String _$availablePlatformsHash() =>
    r'13bf0d36662b8dcb436b3b37190a1b45f7fc5034';

/// See also [availablePlatforms].
@ProviderFor(availablePlatforms)
final availablePlatformsProvider = AutoDisposeProvider<List<String>>.internal(
  availablePlatforms,
  name: r'availablePlatformsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availablePlatformsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailablePlatformsRef = AutoDisposeProviderRef<List<String>>;
String _$searchFilteredGamesHash() =>
    r'37e66aaa485e65cab9e2c9e294c3085f193e6f1e';

/// See also [searchFilteredGames].
@ProviderFor(searchFilteredGames)
const searchFilteredGamesProvider = SearchFilteredGamesFamily();

/// See also [searchFilteredGames].
class SearchFilteredGamesFamily extends Family<List<GameItem>> {
  /// See also [searchFilteredGames].
  const SearchFilteredGamesFamily();

  /// See also [searchFilteredGames].
  SearchFilteredGamesProvider call(String searchQuery) {
    return SearchFilteredGamesProvider(searchQuery);
  }

  @override
  SearchFilteredGamesProvider getProviderOverride(
    covariant SearchFilteredGamesProvider provider,
  ) {
    return call(provider.searchQuery);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchFilteredGamesProvider';
}

/// See also [searchFilteredGames].
class SearchFilteredGamesProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [searchFilteredGames].
  SearchFilteredGamesProvider(String searchQuery)
    : this._internal(
        (ref) =>
            searchFilteredGames(ref as SearchFilteredGamesRef, searchQuery),
        from: searchFilteredGamesProvider,
        name: r'searchFilteredGamesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchFilteredGamesHash,
        dependencies: SearchFilteredGamesFamily._dependencies,
        allTransitiveDependencies:
            SearchFilteredGamesFamily._allTransitiveDependencies,
        searchQuery: searchQuery,
      );

  SearchFilteredGamesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String searchQuery;

  @override
  Override overrideWith(
    List<GameItem> Function(SearchFilteredGamesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFilteredGamesProvider._internal(
        (ref) => create(ref as SearchFilteredGamesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameItem>> createElement() {
    return _SearchFilteredGamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFilteredGamesProvider &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFilteredGamesRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _SearchFilteredGamesProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with SearchFilteredGamesRef {
  _SearchFilteredGamesProviderElement(super.provider);

  @override
  String get searchQuery => (origin as SearchFilteredGamesProvider).searchQuery;
}

String _$fullyFilteredGamesHash() =>
    r'6abe4c102fd579422ca6a6d4cf6ca1c8364aa0f2';

/// See also [fullyFilteredGames].
@ProviderFor(fullyFilteredGames)
const fullyFilteredGamesProvider = FullyFilteredGamesFamily();

/// See also [fullyFilteredGames].
class FullyFilteredGamesFamily extends Family<List<GameItem>> {
  /// See also [fullyFilteredGames].
  const FullyFilteredGamesFamily();

  /// See also [fullyFilteredGames].
  FullyFilteredGamesProvider call(
    GameStatus status,
    String platform,
    String searchQuery,
  ) {
    return FullyFilteredGamesProvider(status, platform, searchQuery);
  }

  @override
  FullyFilteredGamesProvider getProviderOverride(
    covariant FullyFilteredGamesProvider provider,
  ) {
    return call(provider.status, provider.platform, provider.searchQuery);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fullyFilteredGamesProvider';
}

/// See also [fullyFilteredGames].
class FullyFilteredGamesProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [fullyFilteredGames].
  FullyFilteredGamesProvider(
    GameStatus status,
    String platform,
    String searchQuery,
  ) : this._internal(
        (ref) => fullyFilteredGames(
          ref as FullyFilteredGamesRef,
          status,
          platform,
          searchQuery,
        ),
        from: fullyFilteredGamesProvider,
        name: r'fullyFilteredGamesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fullyFilteredGamesHash,
        dependencies: FullyFilteredGamesFamily._dependencies,
        allTransitiveDependencies:
            FullyFilteredGamesFamily._allTransitiveDependencies,
        status: status,
        platform: platform,
        searchQuery: searchQuery,
      );

  FullyFilteredGamesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.platform,
    required this.searchQuery,
  }) : super.internal();

  final GameStatus status;
  final String platform;
  final String searchQuery;

  @override
  Override overrideWith(
    List<GameItem> Function(FullyFilteredGamesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FullyFilteredGamesProvider._internal(
        (ref) => create(ref as FullyFilteredGamesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        platform: platform,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<GameItem>> createElement() {
    return _FullyFilteredGamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FullyFilteredGamesProvider &&
        other.status == status &&
        other.platform == platform &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, platform.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FullyFilteredGamesRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `status` of this provider.
  GameStatus get status;

  /// The parameter `platform` of this provider.
  String get platform;

  /// The parameter `searchQuery` of this provider.
  String get searchQuery;
}

class _FullyFilteredGamesProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with FullyFilteredGamesRef {
  _FullyFilteredGamesProviderElement(super.provider);

  @override
  GameStatus get status => (origin as FullyFilteredGamesProvider).status;
  @override
  String get platform => (origin as FullyFilteredGamesProvider).platform;
  @override
  String get searchQuery => (origin as FullyFilteredGamesProvider).searchQuery;
}

String _$gameListHash() => r'a240636c8164cf279ef4cae13a49e85b55c2ffc5';

/// See also [GameList].
@ProviderFor(GameList)
final gameListProvider =
    AutoDisposeNotifierProvider<GameList, List<GameItem>>.internal(
      GameList.new,
      name: r'gameListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$gameListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameList = AutoDisposeNotifier<List<GameItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
