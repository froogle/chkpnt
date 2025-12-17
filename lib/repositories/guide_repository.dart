import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';

abstract class GuideRepository {
  Stream<List<GuideItem>> watchGuidesForGame(GameId gameId);

  Future<List<GuideItem>> getGuidesForGame(GameId gameId);

  Future<List<GuideItem>> getAllGuides();

  Future<GuideItem?> getGuideById(GuideId guideId);

  Future<GuideItem> createGuide(GuideItem guide);

  Future<GuideItem> updateGuideReadPosition(
    GuideId guideId,
    int section,
    int block,
  );

  Future<void> deleteGuide(GuideId guideId);
}

class GuideNotFoundException implements Exception {
  final GuideId guideId;

  GuideNotFoundException(this.guideId);

  @override
  String toString() => 'Guide not found: ${guideId.value}';
}
