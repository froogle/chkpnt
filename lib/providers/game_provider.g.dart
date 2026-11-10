// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameRepository)
final gameRepositoryProvider = GameRepositoryProvider._();

final class GameRepositoryProvider
    extends $FunctionalProvider<GameRepository, GameRepository, GameRepository>
    with $Provider<GameRepository> {
  GameRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRepositoryHash();

  @$internal
  @override
  $ProviderElement<GameRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRepository create(Ref ref) {
    return gameRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRepository>(value),
    );
  }
}

String _$gameRepositoryHash() => r'75c98be34a7d1a2c230588deb610c43a6887f236';

@ProviderFor(gamesStream)
final gamesStreamProvider = GamesStreamProvider._();

final class GamesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameItem>>,
          List<GameItem>,
          Stream<List<GameItem>>
        >
    with $FutureModifier<List<GameItem>>, $StreamProvider<List<GameItem>> {
  GamesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<GameItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GameItem>> create(Ref ref) {
    return gamesStream(ref);
  }
}

String _$gamesStreamHash() => r'73841ba4cc792fb58d831c17d031d5dfeece549d';

@ProviderFor(GameList)
final gameListProvider = GameListProvider._();

final class GameListProvider
    extends $NotifierProvider<GameList, List<GameItem>> {
  GameListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameListHash();

  @$internal
  @override
  GameList create() => GameList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GameItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GameItem>>(value),
    );
  }
}

String _$gameListHash() => r'cfd7a059515931479f934b0db4591c063c117e1e';

abstract class _$GameList extends $Notifier<List<GameItem>> {
  List<GameItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<GameItem>, List<GameItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<GameItem>, List<GameItem>>,
              List<GameItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(gamesByStatus)
final gamesByStatusProvider = GamesByStatusFamily._();

final class GamesByStatusProvider
    extends $FunctionalProvider<List<GameItem>, List<GameItem>, List<GameItem>>
    with $Provider<List<GameItem>> {
  GamesByStatusProvider._({
    required GamesByStatusFamily super.from,
    required GameStatus super.argument,
  }) : super(
         retry: null,
         name: r'gamesByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gamesByStatusHash();

  @override
  String toString() {
    return r'gamesByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<GameItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<GameItem> create(Ref ref) {
    final argument = this.argument as GameStatus;
    return gamesByStatus(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GameItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GameItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GamesByStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gamesByStatusHash() => r'45d6d324604fda49dea09eef5f550adc486e7918';

final class GamesByStatusFamily extends $Family
    with $FunctionalFamilyOverride<List<GameItem>, GameStatus> {
  GamesByStatusFamily._()
    : super(
        retry: null,
        name: r'gamesByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GamesByStatusProvider call(GameStatus status) =>
      GamesByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'gamesByStatusProvider';
}

@ProviderFor(screenPlatforms)
final screenPlatformsProvider = ScreenPlatformsFamily._();

final class ScreenPlatformsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  ScreenPlatformsProvider._({
    required ScreenPlatformsFamily super.from,
    required GameScreen super.argument,
  }) : super(
         retry: null,
         name: r'screenPlatformsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$screenPlatformsHash();

  @override
  String toString() {
    return r'screenPlatformsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as GameScreen;
    return screenPlatforms(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScreenPlatformsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$screenPlatformsHash() => r'6db7491e33777675d4f5b7cf093fbd689fcb6f40';

final class ScreenPlatformsFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, GameScreen> {
  ScreenPlatformsFamily._()
    : super(
        retry: null,
        name: r'screenPlatformsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ScreenPlatformsProvider call(GameScreen screen) =>
      ScreenPlatformsProvider._(argument: screen, from: this);

  @override
  String toString() => r'screenPlatformsProvider';
}

@ProviderFor(everyPlatform)
final everyPlatformProvider = EveryPlatformProvider._();

final class EveryPlatformProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  EveryPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'everyPlatformProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$everyPlatformHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return everyPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$everyPlatformHash() => r'824186fd47dbf56ce08e495c51c8f07bf792ebe0';

@ProviderFor(statusSectionGames)
final statusSectionGamesProvider = StatusSectionGamesFamily._();

final class StatusSectionGamesProvider
    extends $FunctionalProvider<List<GameItem>, List<GameItem>, List<GameItem>>
    with $Provider<List<GameItem>> {
  StatusSectionGamesProvider._({
    required StatusSectionGamesFamily super.from,
    required GameStatus super.argument,
  }) : super(
         retry: null,
         name: r'statusSectionGamesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statusSectionGamesHash();

  @override
  String toString() {
    return r'statusSectionGamesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<GameItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<GameItem> create(Ref ref) {
    final argument = this.argument as GameStatus;
    return statusSectionGames(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GameItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GameItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StatusSectionGamesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statusSectionGamesHash() =>
    r'1106efee6aebc01fc477c150a9f0b3d6b5286b31';

final class StatusSectionGamesFamily extends $Family
    with $FunctionalFamilyOverride<List<GameItem>, GameStatus> {
  StatusSectionGamesFamily._()
    : super(
        retry: null,
        name: r'statusSectionGamesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StatusSectionGamesProvider call(GameStatus status) =>
      StatusSectionGamesProvider._(argument: status, from: this);

  @override
  String toString() => r'statusSectionGamesProvider';
}

@ProviderFor(platformSections)
final platformSectionsProvider = PlatformSectionsFamily._();

final class PlatformSectionsProvider
    extends
        $FunctionalProvider<
          Map<String, List<GameItem>>,
          Map<String, List<GameItem>>,
          Map<String, List<GameItem>>
        >
    with $Provider<Map<String, List<GameItem>>> {
  PlatformSectionsProvider._({
    required PlatformSectionsFamily super.from,
    required GameScreen super.argument,
  }) : super(
         retry: null,
         name: r'platformSectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$platformSectionsHash();

  @override
  String toString() {
    return r'platformSectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, List<GameItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, List<GameItem>> create(Ref ref) {
    final argument = this.argument as GameScreen;
    return platformSections(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<GameItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<GameItem>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PlatformSectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$platformSectionsHash() => r'4cc15b66127bc12cd8246de9ac9e41d7d8ba8cb2';

final class PlatformSectionsFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, List<GameItem>>, GameScreen> {
  PlatformSectionsFamily._()
    : super(
        retry: null,
        name: r'platformSectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlatformSectionsProvider call(GameScreen screen) =>
      PlatformSectionsProvider._(argument: screen, from: this);

  @override
  String toString() => r'platformSectionsProvider';
}
