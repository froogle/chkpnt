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

const String kDefaultAddGameTitle = 'New Game';

// Game edit context data class to identify the editing context
class GameEditContext {
  final bool isAddMode;
  final GameItem? game;
  final List<GameStatus>? availableStatuses;
  final GameStatus? defaultStatus;
  final bool defaultIsPhysical;

  const GameEditContext({
    required this.isAddMode,
    this.game,
    this.availableStatuses,
    this.defaultStatus,
    this.defaultIsPhysical = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEditContext &&
        other.isAddMode == isAddMode &&
        other.game == game &&
        other.availableStatuses == availableStatuses &&
        other.defaultStatus == defaultStatus &&
        other.defaultIsPhysical == defaultIsPhysical;
  }

  @override
  int get hashCode =>
      Object.hash(isAddMode, game, availableStatuses, defaultStatus, defaultIsPhysical);
}

// Game edit form state data class
class GameEditFormState {
  final String title;
  final String platform;
  final GameStatus status;
  final String? imagePath;
  final bool hasUnsavedChanges;
  final bool isPhysical;
  final String? barcode;
  final bool hasStartedEntry;

  const GameEditFormState({
    required this.title,
    required this.platform,
    required this.status,
    this.imagePath,
    this.hasUnsavedChanges = false,
    this.isPhysical = false,
    this.barcode,
    this.hasStartedEntry = false,
  });

  GameEditFormState copyWith({
    String? title,
    String? platform,
    GameStatus? status,
    String? imagePath,
    bool? hasUnsavedChanges,
    bool clearImagePath = false,
    bool? isPhysical,
    String? barcode,
    bool? hasStartedEntry,
  }) {
    return GameEditFormState(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isPhysical: isPhysical ?? this.isPhysical,
      barcode: barcode ?? this.barcode,
      hasStartedEntry: hasStartedEntry ?? this.hasStartedEntry,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEditFormState &&
        other.title == title &&
        other.platform == platform &&
        other.status == status &&
        other.imagePath == imagePath &&
        other.hasUnsavedChanges == hasUnsavedChanges &&
        other.isPhysical == isPhysical &&
        other.barcode == barcode &&
        other.hasStartedEntry == hasStartedEntry;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      platform,
      status,
      imagePath,
      hasUnsavedChanges,
      isPhysical,
      barcode,
      hasStartedEntry,
    );
  }
}

// Game edit state provider using Family - eliminates initialization issues
@riverpod
class GameEditState extends _$GameEditState {
  @override
  GameEditFormState build(GameEditContext context) {
    // Initialize state based on context - no runtime modification needed
    if (context.isAddMode) {
      final defaultStatus = context.defaultStatus ?? GameStatus.backlog;
      return GameEditFormState(
        title: kDefaultAddGameTitle,
        platform: '',
        status: defaultStatus,
        imagePath: null,
        hasUnsavedChanges: false,
        isPhysical: context.defaultIsPhysical,
        hasStartedEntry: false,
      );
    } else {
      final game = context.game!;
      return GameEditFormState(
        title: game.title,
        platform: game.platform,
        status: game.status,
        imagePath: game.imagePath,
        hasUnsavedChanges: false,
        isPhysical: game.isPhysical,
        hasStartedEntry: true,
      );
    }
  }

  void updateTitle(String title) {
    state = state.copyWith(
      title: title,
      hasUnsavedChanges: true,
      hasStartedEntry: _latchStartedEntry(title, state.platform),
    );
  }

  void updatePlatform(String platform) {
    state = state.copyWith(
      platform: platform,
      hasUnsavedChanges: true,
      hasStartedEntry: _latchStartedEntry(state.title, platform),
    );
  }

  void updateStatus(GameStatus status) {
    state = state.copyWith(status: status, hasUnsavedChanges: true);
  }

  void updateImagePath(String? imagePath) {
    if (imagePath == null) {
      state = state.copyWith(clearImagePath: true, hasUnsavedChanges: true);
    } else {
      state = state.copyWith(imagePath: imagePath, hasUnsavedChanges: true);
    }
  }

  void updateIsPhysical(bool isPhysical) {
    state = state.copyWith(isPhysical: isPhysical, hasUnsavedChanges: true);
  }

  void applyBarcodeScan({
    required String barcode,
    required String title,
    required String platform,
  }) {
    state = state.copyWith(
      title: title.isEmpty ? null : title,
      platform: platform.isEmpty ? null : platform,
      status: GameStatus.owned,
      isPhysical: true,
      barcode: barcode,
      hasUnsavedChanges: true,
      hasStartedEntry: state.hasStartedEntry || title.trim().isNotEmpty,
    );
  }

  bool _latchStartedEntry(String title, String platform) {
    if (state.hasStartedEntry) return true;
    final enteredTitle = title.trim();
    return enteredTitle.isNotEmpty &&
        enteredTitle != kDefaultAddGameTitle &&
        platform.isNotEmpty;
  }

  bool get hasChanges => state.hasUnsavedChanges;
}
