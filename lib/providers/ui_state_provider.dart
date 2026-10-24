import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/game_image_service.dart';

part 'ui_state_provider.g.dart';

// Backlog sorting enum
enum BacklogSortType { title, statusChange }

enum SortDirection { ascending, descending }

// Search query state
@Riverpod(keepAlive: true)
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
@Riverpod(keepAlive: true)
class SelectedPlatform extends _$SelectedPlatform {
  @override
  String? build() => null;

  void selectPlatform(String? platform) {
    state = platform;
  }
}

// Backlog sorting state
@Riverpod(keepAlive: true)
class BacklogSort extends _$BacklogSort {
  @override
  BacklogSortType build() => BacklogSortType.title;

  void setSortType(BacklogSortType sortType) {
    state = sortType;
  }
}

@Riverpod(keepAlive: true)
class BacklogSortDirectionState extends _$BacklogSortDirectionState {
  @override
  SortDirection build() => SortDirection.ascending;

  void setSortDirection(SortDirection direction) {
    state = direction;
  }

  void toggleDirection() {
    state =
        state == SortDirection.ascending
            ? SortDirection.descending
            : SortDirection.ascending;
  }
}

@Riverpod(keepAlive: true)
class BacklogShowBacklogFilter extends _$BacklogShowBacklogFilter {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class BacklogShowOngoingFilter extends _$BacklogShowOngoingFilter {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CollectionShowPhysicalFilter extends _$CollectionShowPhysicalFilter {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class CollectionShowDigitalFilter extends _$CollectionShowDigitalFilter {
  @override
  bool build() => true;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

sealed class Section {
  const Section();
}

class StatusSection extends Section {
  final GameStatus status;

  const StatusSection(this.status);

  @override
  bool operator ==(Object other) =>
      other is StatusSection && other.status == status;

  @override
  int get hashCode => status.hashCode;
}

enum GameScreen { main, wishlist, backlog, collection }

class PlatformSection extends Section {
  final GameScreen screen;
  final String platform;

  const PlatformSection(this.screen, this.platform);

  @override
  bool operator ==(Object other) =>
      other is PlatformSection &&
      other.screen == screen &&
      other.platform == platform;

  @override
  int get hashCode => Object.hash(screen, platform);
}

bool _isExpandedByDefault(Section section) => switch (section) {
  StatusSection(:final status) => status == GameStatus.playing,
  PlatformSection() => true,
};

// Section expansion state - Using Notifier to preserve state across navigation
@Riverpod(keepAlive: true)
class SectionExpansion extends _$SectionExpansion {
  @override
  Map<Section, bool> build() => {};

  void toggleSection(Section section) {
    final isExpanded = state[section] ?? _isExpandedByDefault(section);
    state = {...state, section: !isExpanded};
  }

  void expandSection(Section section) {
    state = {...state, section: true};
  }
}

@riverpod
bool sectionExpanded(Ref ref, Section section) {
  return ref.watch(sectionExpansionProvider)[section] ??
      _isExpandedByDefault(section);
}

// Game image Family provider - replaces FutureBuilder pattern
@riverpod
Future<String?> gameImage(Ref ref, String imagePath) async {
  final imageService = ref.read(gameImageServiceProvider);
  return await imageService.getImagePath(imagePath);
}
