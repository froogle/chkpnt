// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameRepositoryHash() => r'75c98be34a7d1a2c230588deb610c43a6887f236';

/// See also [gameRepository].
@ProviderFor(gameRepository)
final gameRepositoryProvider = AutoDisposeProvider<GameRepository>.internal(
  gameRepository,
  name: r'gameRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameRepositoryRef = AutoDisposeProviderRef<GameRepository>;
String _$gamesStreamHash() => r'73841ba4cc792fb58d831c17d031d5dfeece549d';

/// See also [gamesStream].
@ProviderFor(gamesStream)
final gamesStreamProvider = AutoDisposeStreamProvider<List<GameItem>>.internal(
  gamesStream,
  name: r'gamesStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gamesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GamesStreamRef = AutoDisposeStreamProviderRef<List<GameItem>>;
String _$gamesByStatusHash() => r'45d6d324604fda49dea09eef5f550adc486e7918';

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

String _$gamesByPlatformHash() => r'21dd4122b1604adff6f25f7d4d5d9b96d0e2bc18';

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
String _$wishlistPlatformsHash() => r'7981d1f387461db3e44e19ddf010e221f9f8ebcd';

/// See also [wishlistPlatforms].
@ProviderFor(wishlistPlatforms)
final wishlistPlatformsProvider = AutoDisposeProvider<List<String>>.internal(
  wishlistPlatforms,
  name: r'wishlistPlatformsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wishlistPlatformsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WishlistPlatformsRef = AutoDisposeProviderRef<List<String>>;
String _$fullyFilteredGamesHash() =>
    r'e196b0ff88c81ac171e96af171a9be6fbf83408a';

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

String _$sortedBacklogGamesByPlatformHash() =>
    r'792b09926df014c7e683e13d6821b95073d51189';

/// See also [sortedBacklogGamesByPlatform].
@ProviderFor(sortedBacklogGamesByPlatform)
final sortedBacklogGamesByPlatformProvider =
    AutoDisposeProvider<Map<String, List<GameItem>>>.internal(
      sortedBacklogGamesByPlatform,
      name: r'sortedBacklogGamesByPlatformProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sortedBacklogGamesByPlatformHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedBacklogGamesByPlatformRef =
    AutoDisposeProviderRef<Map<String, List<GameItem>>>;
String _$backlogPlatformsHash() => r'9e1034f9f8130c5ff157269ffba56ac2994a1e89';

/// See also [backlogPlatforms].
@ProviderFor(backlogPlatforms)
final backlogPlatformsProvider = AutoDisposeProvider<List<String>>.internal(
  backlogPlatforms,
  name: r'backlogPlatformsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backlogPlatformsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BacklogPlatformsRef = AutoDisposeProviderRef<List<String>>;
String _$collectionGamesHash() => r'fdeeb63006e845d4f7f4c7551a22b37027803005';

/// See also [collectionGames].
@ProviderFor(collectionGames)
final collectionGamesProvider = AutoDisposeProvider<List<GameItem>>.internal(
  collectionGames,
  name: r'collectionGamesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$collectionGamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CollectionGamesRef = AutoDisposeProviderRef<List<GameItem>>;
String _$collectionGamesByPlatformHash() =>
    r'43234d50a01300ecf655ecbd59984d37450bc087';

/// See also [collectionGamesByPlatform].
@ProviderFor(collectionGamesByPlatform)
final collectionGamesByPlatformProvider =
    AutoDisposeProvider<Map<String, List<GameItem>>>.internal(
      collectionGamesByPlatform,
      name: r'collectionGamesByPlatformProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$collectionGamesByPlatformHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CollectionGamesByPlatformRef =
    AutoDisposeProviderRef<Map<String, List<GameItem>>>;
String _$collectionPlatformsHash() =>
    r'eb9dc99fe4cd3d38bdbcefffcdc8aeb4f6b95cfb';

/// See also [collectionPlatforms].
@ProviderFor(collectionPlatforms)
final collectionPlatformsProvider = AutoDisposeProvider<List<String>>.internal(
  collectionPlatforms,
  name: r'collectionPlatformsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$collectionPlatformsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CollectionPlatformsRef = AutoDisposeProviderRef<List<String>>;
String _$gameListHash() => r'cfd7a059515931479f934b0db4591c063c117e1e';

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
