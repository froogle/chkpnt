import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chkpnt/models/game_models.dart';

part 'ui_state_provider.g.dart';

// Search query state
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

// Platform filter state
@riverpod
class SelectedPlatform extends _$SelectedPlatform {
  @override
  String build() => 'All';

  void selectPlatform(String platform) {
    state = platform;
  }

  void resetToAll() {
    state = 'All';
  }
}

// Section expansion state
@riverpod
class SectionExpansion extends _$SectionExpansion {
  @override
  Map<String, bool> build() => {
    'Playing': true,
    'Backlog': false,
    'Completed': false,
    'Abandoned': false,
  };

  void toggleSection(String sectionName) {
    state = {...state, sectionName: !(state[sectionName] ?? false)};
  }

  void expandSection(String sectionName) {
    state = {...state, sectionName: true};
  }

  void collapseSection(String sectionName) {
    state = {...state, sectionName: false};
  }

  void expandAll() {
    state = {for (final key in state.keys) key: true};
  }

  void collapseAll() {
    state = {for (final key in state.keys) key: false};
  }

  void updateExpansionBasedOnResults({
    required List<GameItem> playingGames,
    required List<GameItem> backlogGames,
    required List<GameItem> completedGames,
    required List<GameItem> abandonedGames,
  }) {
    state = {
      'Playing': playingGames.isNotEmpty,
      'Backlog': backlogGames.isNotEmpty,
      'Completed': completedGames.isNotEmpty,
      'Abandoned': abandonedGames.isNotEmpty,
    };
  }
}
