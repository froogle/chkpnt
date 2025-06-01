import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'game_models.freezed.dart';
part 'game_models.g.dart';

enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered }

@freezed
class GameId with _$GameId {
  const factory GameId(String value) = _GameId;

  factory GameId.generate() {
    final uuid = const Uuid();
    return GameId(uuid.v4());
  }

  factory GameId.fromJson(Map<String, dynamic> json) => _$GameIdFromJson(json);
}

@freezed
class GameItem with _$GameItem {
  const factory GameItem({
    required GameId id,
    required String title,
    required String platform,
    required GameStatus status,
    required double progress,
  }) = _GameItem;

  factory GameItem.fromJson(Map<String, dynamic> json) =>
      _$GameItemFromJson(json);
}
