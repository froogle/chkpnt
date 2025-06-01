import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_models.freezed.dart';
part 'game_models.g.dart';

enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered }

@freezed
class GameItem with _$GameItem {
  const factory GameItem({
    required String id,
    required String title,
    required String platform,
    required GameStatus status,
    required double progress,
  }) = _GameItem;

  factory GameItem.fromJson(Map<String, dynamic> json) =>
      _$GameItemFromJson(json);
}
