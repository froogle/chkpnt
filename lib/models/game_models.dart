import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'game_models.freezed.dart';
part 'game_models.g.dart';

enum GameStatus {
  playing,
  completed,
  backlog,
  abandoned,
  wishlist,
  ordered,
  ongoing,
  owned,
}

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
    required DateTime lastModified,
    required DateTime lastStatusChange,
    String? imagePath,
    String? remoteImageUrl,
    @Default(false) bool isPhysical,
    String? barcode,
  }) = _GameItem;

  factory GameItem.create({
    required String title,
    required String platform,
    required GameStatus status,
    String? imagePath,
    String? remoteImageUrl,
    bool isPhysical = false,
    String? barcode,
  }) {
    final now = DateTime.now();
    return GameItem(
      id: GameId.generate(),
      title: title,
      platform: platform,
      status: status,
      lastModified: now,
      lastStatusChange: now,
      imagePath: imagePath,
      remoteImageUrl: remoteImageUrl,
      isPhysical: isPhysical,
      barcode: barcode,
    );
  }

  factory GameItem.fromJson(Map<String, dynamic> json) =>
      _$GameItemFromJson(json);
}
