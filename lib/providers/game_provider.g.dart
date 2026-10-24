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

String _$screenPlatformsHash() => r'6db7491e33777675d4f5b7cf093fbd689fcb6f40';

/// See also [screenPlatforms].
@ProviderFor(screenPlatforms)
const screenPlatformsProvider = ScreenPlatformsFamily();

/// See also [screenPlatforms].
class ScreenPlatformsFamily extends Family<List<String>> {
  /// See also [screenPlatforms].
  const ScreenPlatformsFamily();

  /// See also [screenPlatforms].
  ScreenPlatformsProvider call(GameScreen screen) {
    return ScreenPlatformsProvider(screen);
  }

  @override
  ScreenPlatformsProvider getProviderOverride(
    covariant ScreenPlatformsProvider provider,
  ) {
    return call(provider.screen);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'screenPlatformsProvider';
}

/// See also [screenPlatforms].
class ScreenPlatformsProvider extends AutoDisposeProvider<List<String>> {
  /// See also [screenPlatforms].
  ScreenPlatformsProvider(GameScreen screen)
    : this._internal(
        (ref) => screenPlatforms(ref as ScreenPlatformsRef, screen),
        from: screenPlatformsProvider,
        name: r'screenPlatformsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$screenPlatformsHash,
        dependencies: ScreenPlatformsFamily._dependencies,
        allTransitiveDependencies:
            ScreenPlatformsFamily._allTransitiveDependencies,
        screen: screen,
      );

  ScreenPlatformsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.screen,
  }) : super.internal();

  final GameScreen screen;

  @override
  Override overrideWith(
    List<String> Function(ScreenPlatformsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScreenPlatformsProvider._internal(
        (ref) => create(ref as ScreenPlatformsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        screen: screen,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<String>> createElement() {
    return _ScreenPlatformsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScreenPlatformsProvider && other.screen == screen;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, screen.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScreenPlatformsRef on AutoDisposeProviderRef<List<String>> {
  /// The parameter `screen` of this provider.
  GameScreen get screen;
}

class _ScreenPlatformsProviderElement
    extends AutoDisposeProviderElement<List<String>>
    with ScreenPlatformsRef {
  _ScreenPlatformsProviderElement(super.provider);

  @override
  GameScreen get screen => (origin as ScreenPlatformsProvider).screen;
}

String _$everyPlatformHash() => r'824186fd47dbf56ce08e495c51c8f07bf792ebe0';

/// See also [everyPlatform].
@ProviderFor(everyPlatform)
final everyPlatformProvider = AutoDisposeProvider<List<String>>.internal(
  everyPlatform,
  name: r'everyPlatformProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$everyPlatformHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EveryPlatformRef = AutoDisposeProviderRef<List<String>>;
String _$statusSectionGamesHash() =>
    r'2b3ad7460b35a1c7fb34faddf477c2a9e43c0434';

/// See also [statusSectionGames].
@ProviderFor(statusSectionGames)
const statusSectionGamesProvider = StatusSectionGamesFamily();

/// See also [statusSectionGames].
class StatusSectionGamesFamily extends Family<List<GameItem>> {
  /// See also [statusSectionGames].
  const StatusSectionGamesFamily();

  /// See also [statusSectionGames].
  StatusSectionGamesProvider call(GameStatus status) {
    return StatusSectionGamesProvider(status);
  }

  @override
  StatusSectionGamesProvider getProviderOverride(
    covariant StatusSectionGamesProvider provider,
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
  String? get name => r'statusSectionGamesProvider';
}

/// See also [statusSectionGames].
class StatusSectionGamesProvider extends AutoDisposeProvider<List<GameItem>> {
  /// See also [statusSectionGames].
  StatusSectionGamesProvider(GameStatus status)
    : this._internal(
        (ref) => statusSectionGames(ref as StatusSectionGamesRef, status),
        from: statusSectionGamesProvider,
        name: r'statusSectionGamesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$statusSectionGamesHash,
        dependencies: StatusSectionGamesFamily._dependencies,
        allTransitiveDependencies:
            StatusSectionGamesFamily._allTransitiveDependencies,
        status: status,
      );

  StatusSectionGamesProvider._internal(
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
    List<GameItem> Function(StatusSectionGamesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StatusSectionGamesProvider._internal(
        (ref) => create(ref as StatusSectionGamesRef),
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
    return _StatusSectionGamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatusSectionGamesProvider && other.status == status;
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
mixin StatusSectionGamesRef on AutoDisposeProviderRef<List<GameItem>> {
  /// The parameter `status` of this provider.
  GameStatus get status;
}

class _StatusSectionGamesProviderElement
    extends AutoDisposeProviderElement<List<GameItem>>
    with StatusSectionGamesRef {
  _StatusSectionGamesProviderElement(super.provider);

  @override
  GameStatus get status => (origin as StatusSectionGamesProvider).status;
}

String _$platformSectionsHash() => r'd9f99a86bbb55e0d9e3137135e1c269fc1066b85';

/// See also [platformSections].
@ProviderFor(platformSections)
const platformSectionsProvider = PlatformSectionsFamily();

/// See also [platformSections].
class PlatformSectionsFamily extends Family<Map<String, List<GameItem>>> {
  /// See also [platformSections].
  const PlatformSectionsFamily();

  /// See also [platformSections].
  PlatformSectionsProvider call(GameScreen screen) {
    return PlatformSectionsProvider(screen);
  }

  @override
  PlatformSectionsProvider getProviderOverride(
    covariant PlatformSectionsProvider provider,
  ) {
    return call(provider.screen);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'platformSectionsProvider';
}

/// See also [platformSections].
class PlatformSectionsProvider
    extends AutoDisposeProvider<Map<String, List<GameItem>>> {
  /// See also [platformSections].
  PlatformSectionsProvider(GameScreen screen)
    : this._internal(
        (ref) => platformSections(ref as PlatformSectionsRef, screen),
        from: platformSectionsProvider,
        name: r'platformSectionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$platformSectionsHash,
        dependencies: PlatformSectionsFamily._dependencies,
        allTransitiveDependencies:
            PlatformSectionsFamily._allTransitiveDependencies,
        screen: screen,
      );

  PlatformSectionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.screen,
  }) : super.internal();

  final GameScreen screen;

  @override
  Override overrideWith(
    Map<String, List<GameItem>> Function(PlatformSectionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlatformSectionsProvider._internal(
        (ref) => create(ref as PlatformSectionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        screen: screen,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, List<GameItem>>> createElement() {
    return _PlatformSectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlatformSectionsProvider && other.screen == screen;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, screen.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlatformSectionsRef
    on AutoDisposeProviderRef<Map<String, List<GameItem>>> {
  /// The parameter `screen` of this provider.
  GameScreen get screen;
}

class _PlatformSectionsProviderElement
    extends AutoDisposeProviderElement<Map<String, List<GameItem>>>
    with PlatformSectionsRef {
  _PlatformSectionsProviderElement(super.provider);

  @override
  GameScreen get screen => (origin as PlatformSectionsProvider).screen;
}

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
