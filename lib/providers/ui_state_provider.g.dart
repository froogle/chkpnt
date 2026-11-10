// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'90108134dff9ce4ac3cd7f9ecc034bf7f9630f95';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedPlatform)
final selectedPlatformProvider = SelectedPlatformProvider._();

final class SelectedPlatformProvider
    extends $NotifierProvider<SelectedPlatform, String?> {
  SelectedPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPlatformProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPlatformHash();

  @$internal
  @override
  SelectedPlatform create() => SelectedPlatform();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedPlatformHash() => r'330289ec5724270058bc4848f789f603208da88d';

abstract class _$SelectedPlatform extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BacklogSort)
final backlogSortProvider = BacklogSortProvider._();

final class BacklogSortProvider
    extends $NotifierProvider<BacklogSort, BacklogSortType> {
  BacklogSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backlogSortProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backlogSortHash();

  @$internal
  @override
  BacklogSort create() => BacklogSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BacklogSortType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BacklogSortType>(value),
    );
  }
}

String _$backlogSortHash() => r'13a4645f9230ba2e2dab019b64630ddc60caea4d';

abstract class _$BacklogSort extends $Notifier<BacklogSortType> {
  BacklogSortType build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<BacklogSortType, BacklogSortType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BacklogSortType, BacklogSortType>,
              BacklogSortType,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BacklogSortDirectionState)
final backlogSortDirectionStateProvider = BacklogSortDirectionStateProvider._();

final class BacklogSortDirectionStateProvider
    extends $NotifierProvider<BacklogSortDirectionState, SortDirection> {
  BacklogSortDirectionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backlogSortDirectionStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backlogSortDirectionStateHash();

  @$internal
  @override
  BacklogSortDirectionState create() => BacklogSortDirectionState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortDirection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortDirection>(value),
    );
  }
}

String _$backlogSortDirectionStateHash() =>
    r'49fc31166ce8f3d08b6c47ee9adad12f6511b17e';

abstract class _$BacklogSortDirectionState extends $Notifier<SortDirection> {
  SortDirection build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SortDirection, SortDirection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortDirection, SortDirection>,
              SortDirection,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BacklogShowBacklogFilter)
final backlogShowBacklogFilterProvider = BacklogShowBacklogFilterProvider._();

final class BacklogShowBacklogFilterProvider
    extends $NotifierProvider<BacklogShowBacklogFilter, bool> {
  BacklogShowBacklogFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backlogShowBacklogFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backlogShowBacklogFilterHash();

  @$internal
  @override
  BacklogShowBacklogFilter create() => BacklogShowBacklogFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$backlogShowBacklogFilterHash() =>
    r'94aab24c0e69689fe62e0e19c89e5274489e11ad';

abstract class _$BacklogShowBacklogFilter extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BacklogShowOngoingFilter)
final backlogShowOngoingFilterProvider = BacklogShowOngoingFilterProvider._();

final class BacklogShowOngoingFilterProvider
    extends $NotifierProvider<BacklogShowOngoingFilter, bool> {
  BacklogShowOngoingFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backlogShowOngoingFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backlogShowOngoingFilterHash();

  @$internal
  @override
  BacklogShowOngoingFilter create() => BacklogShowOngoingFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$backlogShowOngoingFilterHash() =>
    r'e2e97a49834c372c176c1b43353ba693268431b8';

abstract class _$BacklogShowOngoingFilter extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CollectionShowPhysicalFilter)
final collectionShowPhysicalFilterProvider =
    CollectionShowPhysicalFilterProvider._();

final class CollectionShowPhysicalFilterProvider
    extends $NotifierProvider<CollectionShowPhysicalFilter, bool> {
  CollectionShowPhysicalFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionShowPhysicalFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionShowPhysicalFilterHash();

  @$internal
  @override
  CollectionShowPhysicalFilter create() => CollectionShowPhysicalFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$collectionShowPhysicalFilterHash() =>
    r'6e3aecb06956be6b6f2c4adc7b3708e86dfbe905';

abstract class _$CollectionShowPhysicalFilter extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CollectionShowDigitalFilter)
final collectionShowDigitalFilterProvider =
    CollectionShowDigitalFilterProvider._();

final class CollectionShowDigitalFilterProvider
    extends $NotifierProvider<CollectionShowDigitalFilter, bool> {
  CollectionShowDigitalFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionShowDigitalFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionShowDigitalFilterHash();

  @$internal
  @override
  CollectionShowDigitalFilter create() => CollectionShowDigitalFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$collectionShowDigitalFilterHash() =>
    r'85a7d8b921fff4414b4f144f0febc1a9adae536a';

abstract class _$CollectionShowDigitalFilter extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SectionExpansion)
final sectionExpansionProvider = SectionExpansionProvider._();

final class SectionExpansionProvider
    extends $NotifierProvider<SectionExpansion, Map<Section, bool>> {
  SectionExpansionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sectionExpansionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sectionExpansionHash();

  @$internal
  @override
  SectionExpansion create() => SectionExpansion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<Section, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<Section, bool>>(value),
    );
  }
}

String _$sectionExpansionHash() => r'1098edc5f41d29be7f00fb7d0ca347970569c7bf';

abstract class _$SectionExpansion extends $Notifier<Map<Section, bool>> {
  Map<Section, bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<Section, bool>, Map<Section, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<Section, bool>, Map<Section, bool>>,
              Map<Section, bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(sectionExpanded)
final sectionExpandedProvider = SectionExpandedFamily._();

final class SectionExpandedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SectionExpandedProvider._({
    required SectionExpandedFamily super.from,
    required Section super.argument,
  }) : super(
         retry: null,
         name: r'sectionExpandedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sectionExpandedHash();

  @override
  String toString() {
    return r'sectionExpandedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as Section;
    return sectionExpanded(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SectionExpandedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sectionExpandedHash() => r'56978dd650a0cdbe95774d91a79b182060d32441';

final class SectionExpandedFamily extends $Family
    with $FunctionalFamilyOverride<bool, Section> {
  SectionExpandedFamily._()
    : super(
        retry: null,
        name: r'sectionExpandedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SectionExpandedProvider call(Section section) =>
      SectionExpandedProvider._(argument: section, from: this);

  @override
  String toString() => r'sectionExpandedProvider';
}

@ProviderFor(gameImage)
final gameImageProvider = GameImageFamily._();

final class GameImageProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  GameImageProvider._({
    required GameImageFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gameImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameImageHash();

  @override
  String toString() {
    return r'gameImageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return gameImage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GameImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameImageHash() => r'fdf973fe399f1ff49676445525ce980114f90df4';

final class GameImageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  GameImageFamily._()
    : super(
        retry: null,
        name: r'gameImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GameImageProvider call(String imagePath) =>
      GameImageProvider._(argument: imagePath, from: this);

  @override
  String toString() => r'gameImageProvider';
}
