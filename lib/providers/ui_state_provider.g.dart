// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameImageHash() => r'c049c5e4d3f4bb0c4144932ccd015b8f17b7e71f';

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
class GameImageFamily extends Family<AsyncValue<File?>> {
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
class GameImageProvider extends AutoDisposeFutureProvider<File?> {
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
    FutureOr<File?> Function(GameImageRef provider) create,
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
  AutoDisposeFutureProviderElement<File?> createElement() {
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
mixin GameImageRef on AutoDisposeFutureProviderRef<File?> {
  /// The parameter `imagePath` of this provider.
  String get imagePath;
}

class _GameImageProviderElement extends AutoDisposeFutureProviderElement<File?>
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
String _$sectionExpansionHash() => r'37f7ddb7448649f53c94d0d90e4dd73e8dda3d71';

/// See also [SectionExpansion].
@ProviderFor(SectionExpansion)
final sectionExpansionProvider =
    AutoDisposeNotifierProvider<SectionExpansion, Map<String, bool>>.internal(
      SectionExpansion.new,
      name: r'sectionExpansionProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sectionExpansionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SectionExpansion = AutoDisposeNotifier<Map<String, bool>>;
String _$gameEditStateHash() => r'22b62fcfa3434f171365c348cb882afc8ad0622d';

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
