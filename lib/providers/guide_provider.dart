import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/repositories/guide_repository.dart';
import 'package:chkpnt/repositories/drift_game_repository.dart';
import 'package:chkpnt/providers/game_provider.dart';

part 'guide_provider.g.dart';

@riverpod
GuideRepository guideRepository(Ref ref) {
  final gameRepository =
      ref.watch(gameRepositoryProvider) as DriftGameRepository;
  return DriftGuideRepository(gameRepository.database);
}

@riverpod
Stream<List<GuideItem>> guidesForGameStream(Ref ref, GameId gameId) {
  final repository = ref.watch(guideRepositoryProvider);
  return repository.watchGuidesForGame(gameId);
}

@riverpod
class GuidesForGame extends _$GuidesForGame {
  @override
  List<GuideItem> build(GameId gameId) {
    final guidesAsync = ref.watch(guidesForGameStreamProvider(gameId));
    return guidesAsync.when(
      data: (guides) => guides,
      loading: () => [],
      error: (error, stack) => [],
    );
  }

  Future<void> addGuide(GuideItem guide) async {
    final repository = ref.read(guideRepositoryProvider);
    await repository.createGuide(guide);
  }

  Future<void> markAttributionSeen(GuideId guideId) async {
    final repository = ref.read(guideRepositoryProvider);
    await repository.markAttributionSeen(guideId);
  }

  Future<void> deleteGuide(GuideId guideId) async {
    final repository = ref.read(guideRepositoryProvider);
    await repository.deleteGuide(guideId);
  }
}
