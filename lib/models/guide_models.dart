import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:chkpnt/models/game_models.dart';

part 'guide_models.freezed.dart';
part 'guide_models.g.dart';

@freezed
class GuideId with _$GuideId {
  const factory GuideId(String value) = _GuideId;

  factory GuideId.generate() {
    final uuid = const Uuid();
    return GuideId(uuid.v4());
  }

  factory GuideId.fromJson(Map<String, dynamic> json) => _$GuideIdFromJson(json);
}

@freezed
class GuideItem with _$GuideItem {
  const factory GuideItem({
    required GuideId id,
    required GameId gameId,
    required String title,
    required String author,
    required String fileName,
    required DateTime createdAt,
    @Default(0) int lastReadSection,
    @Default(0) int lastReadBlock,
    String? sourceUrl,
    @Default(false) bool hasSeenAttribution,
  }) = _GuideItem;

  factory GuideItem.create({
    required GameId gameId,
    required String title,
    required String author,
    required String fileName,
    String? sourceUrl,
  }) {
    return GuideItem(
      id: GuideId.generate(),
      gameId: gameId,
      title: title,
      author: author,
      fileName: fileName,
      createdAt: DateTime.now(),
      lastReadSection: 0,
      lastReadBlock: 0,
      sourceUrl: sourceUrl,
    );
  }

  factory GuideItem.fromJson(Map<String, dynamic> json) =>
      _$GuideItemFromJson(json);
}
