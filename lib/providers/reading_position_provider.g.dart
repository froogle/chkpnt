// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_position_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReadingPosition)
final readingPositionProvider = ReadingPositionFamily._();

final class ReadingPositionProvider
    extends $AsyncNotifierProvider<ReadingPosition, TextGuideReading> {
  ReadingPositionProvider._({
    required ReadingPositionFamily super.from,
    required GuideId super.argument,
  }) : super(
         retry: null,
         name: r'readingPositionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readingPositionHash();

  @override
  String toString() {
    return r'readingPositionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReadingPosition create() => ReadingPosition();

  @override
  bool operator ==(Object other) {
    return other is ReadingPositionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readingPositionHash() => r'21bc649d1d56835775ad05624bfac653626e101b';

final class ReadingPositionFamily extends $Family
    with
        $ClassFamilyOverride<
          ReadingPosition,
          AsyncValue<TextGuideReading>,
          TextGuideReading,
          FutureOr<TextGuideReading>,
          GuideId
        > {
  ReadingPositionFamily._()
    : super(
        retry: null,
        name: r'readingPositionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReadingPositionProvider call(GuideId guideId) =>
      ReadingPositionProvider._(argument: guideId, from: this);

  @override
  String toString() => r'readingPositionProvider';
}

abstract class _$ReadingPosition extends $AsyncNotifier<TextGuideReading> {
  late final _$args = ref.$arg as GuideId;
  GuideId get guideId => _$args;

  FutureOr<TextGuideReading> build(GuideId guideId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TextGuideReading>, TextGuideReading>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TextGuideReading>, TextGuideReading>,
              AsyncValue<TextGuideReading>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
