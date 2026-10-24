// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_position_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingPositionHash() => r'21bc649d1d56835775ad05624bfac653626e101b';

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

abstract class _$ReadingPosition
    extends BuildlessAutoDisposeAsyncNotifier<TextGuideReading> {
  late final GuideId guideId;

  FutureOr<TextGuideReading> build(GuideId guideId);
}

/// See also [ReadingPosition].
@ProviderFor(ReadingPosition)
const readingPositionProvider = ReadingPositionFamily();

/// See also [ReadingPosition].
class ReadingPositionFamily extends Family<AsyncValue<TextGuideReading>> {
  /// See also [ReadingPosition].
  const ReadingPositionFamily();

  /// See also [ReadingPosition].
  ReadingPositionProvider call(GuideId guideId) {
    return ReadingPositionProvider(guideId);
  }

  @override
  ReadingPositionProvider getProviderOverride(
    covariant ReadingPositionProvider provider,
  ) {
    return call(provider.guideId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'readingPositionProvider';
}

/// See also [ReadingPosition].
class ReadingPositionProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ReadingPosition,
          TextGuideReading
        > {
  /// See also [ReadingPosition].
  ReadingPositionProvider(GuideId guideId)
    : this._internal(
        () => ReadingPosition()..guideId = guideId,
        from: readingPositionProvider,
        name: r'readingPositionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$readingPositionHash,
        dependencies: ReadingPositionFamily._dependencies,
        allTransitiveDependencies:
            ReadingPositionFamily._allTransitiveDependencies,
        guideId: guideId,
      );

  ReadingPositionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guideId,
  }) : super.internal();

  final GuideId guideId;

  @override
  FutureOr<TextGuideReading> runNotifierBuild(
    covariant ReadingPosition notifier,
  ) {
    return notifier.build(guideId);
  }

  @override
  Override overrideWith(ReadingPosition Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReadingPositionProvider._internal(
        () => create()..guideId = guideId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guideId: guideId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ReadingPosition, TextGuideReading>
  createElement() {
    return _ReadingPositionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadingPositionProvider && other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReadingPositionRef
    on AutoDisposeAsyncNotifierProviderRef<TextGuideReading> {
  /// The parameter `guideId` of this provider.
  GuideId get guideId;
}

class _ReadingPositionProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ReadingPosition,
          TextGuideReading
        >
    with ReadingPositionRef {
  _ReadingPositionProviderElement(super.provider);

  @override
  GuideId get guideId => (origin as ReadingPositionProvider).guideId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
