// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(guideRepository)
final guideRepositoryProvider = GuideRepositoryProvider._();

final class GuideRepositoryProvider
    extends
        $FunctionalProvider<GuideRepository, GuideRepository, GuideRepository>
    with $Provider<GuideRepository> {
  GuideRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guideRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guideRepositoryHash();

  @$internal
  @override
  $ProviderElement<GuideRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GuideRepository create(Ref ref) {
    return guideRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GuideRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GuideRepository>(value),
    );
  }
}

String _$guideRepositoryHash() => r'44cdd094e42d595b0b320d9589c0fa0f9b36caab';

@ProviderFor(guidesForGameStream)
final guidesForGameStreamProvider = GuidesForGameStreamFamily._();

final class GuidesForGameStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GuideItem>>,
          List<GuideItem>,
          Stream<List<GuideItem>>
        >
    with $FutureModifier<List<GuideItem>>, $StreamProvider<List<GuideItem>> {
  GuidesForGameStreamProvider._({
    required GuidesForGameStreamFamily super.from,
    required GameId super.argument,
  }) : super(
         retry: null,
         name: r'guidesForGameStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$guidesForGameStreamHash();

  @override
  String toString() {
    return r'guidesForGameStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<GuideItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GuideItem>> create(Ref ref) {
    final argument = this.argument as GameId;
    return guidesForGameStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GuidesForGameStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guidesForGameStreamHash() =>
    r'3ed55f171f375475349120138458e9e25b40b34a';

final class GuidesForGameStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<GuideItem>>, GameId> {
  GuidesForGameStreamFamily._()
    : super(
        retry: null,
        name: r'guidesForGameStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GuidesForGameStreamProvider call(GameId gameId) =>
      GuidesForGameStreamProvider._(argument: gameId, from: this);

  @override
  String toString() => r'guidesForGameStreamProvider';
}

@ProviderFor(GuidesForGame)
final guidesForGameProvider = GuidesForGameFamily._();

final class GuidesForGameProvider
    extends $NotifierProvider<GuidesForGame, List<GuideItem>> {
  GuidesForGameProvider._({
    required GuidesForGameFamily super.from,
    required GameId super.argument,
  }) : super(
         retry: null,
         name: r'guidesForGameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$guidesForGameHash();

  @override
  String toString() {
    return r'guidesForGameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GuidesForGame create() => GuidesForGame();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GuideItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GuideItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GuidesForGameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$guidesForGameHash() => r'adf71186a72673bbf288edfeb26e3b97d907cca2';

final class GuidesForGameFamily extends $Family
    with
        $ClassFamilyOverride<
          GuidesForGame,
          List<GuideItem>,
          List<GuideItem>,
          List<GuideItem>,
          GameId
        > {
  GuidesForGameFamily._()
    : super(
        retry: null,
        name: r'guidesForGameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GuidesForGameProvider call(GameId gameId) =>
      GuidesForGameProvider._(argument: gameId, from: this);

  @override
  String toString() => r'guidesForGameProvider';
}

abstract class _$GuidesForGame extends $Notifier<List<GuideItem>> {
  late final _$args = ref.$arg as GameId;
  GameId get gameId => _$args;

  List<GuideItem> build(GameId gameId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<GuideItem>, List<GuideItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<GuideItem>, List<GuideItem>>,
              List<GuideItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
