import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/game_image_service.dart';

part 'ui_state_provider.g.dart';

// Backlog sorting enum
enum BacklogSortType { title, dateAdded }

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
  String build() => 'All';

  void selectPlatform(String platform) {
    state = platform;
  }

  void resetToAll() {
    state = 'All';
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

// Section expansion state - Using Notifier to preserve state across navigation
@Riverpod(keepAlive: true)
class SectionExpansion extends _$SectionExpansion {
  @override
  Map<String, bool> build() => {
    'Playing': true,
    'Ongoing/Frequently Played': false,
    'Backlog': false,
    'Completed': false,
    'Abandoned': false,
    'Ordered': true,
    'Wish List': false,
    'Physical': true,
    'Digital': true,
  };

  // Track which sections have been manually controlled by the user
  final Set<String> _manuallyControlledSections = <String>{};

  void toggleSection(String sectionName) {
    // Mark this section as manually controlled
    _manuallyControlledSections.add(sectionName);
    state = {...state, sectionName: !(state[sectionName] ?? true)};
  }

  void expandSection(String sectionName) {
    // Mark this section as manually controlled
    _manuallyControlledSections.add(sectionName);
    state = {...state, sectionName: true};
  }

  void collapseSection(String sectionName) {
    // Mark this section as manually controlled
    _manuallyControlledSections.add(sectionName);
    state = {...state, sectionName: false};
  }

  void expandAll() {
    // Mark all sections as manually controlled
    _manuallyControlledSections.addAll(state.keys);
    state = {for (final key in state.keys) key: true};
  }

  void collapseAll() {
    // Mark all sections as manually controlled
    _manuallyControlledSections.addAll(state.keys);
    state = {for (final key in state.keys) key: false};
  }

  void updateExpansionBasedOnResults({
    List<GameItem>? playingGames,
    List<GameItem>? backlogGames,
    List<GameItem>? completedGames,
    List<GameItem>? abandonedGames,
    List<GameItem>? orderedGames,
    List<GameItem>? wishlistGames,
  }) {
    // Only update sections that are explicitly provided AND not manually controlled
    final newState = <String, bool>{};

    // Update main screen sections only if provided and not manually controlled
    if (playingGames != null &&
        !_manuallyControlledSections.contains('Playing')) {
      newState['Playing'] = playingGames.isNotEmpty;
    }
    if (backlogGames != null &&
        !_manuallyControlledSections.contains('Backlog')) {
      newState['Backlog'] = backlogGames.isNotEmpty;
    }
    if (completedGames != null &&
        !_manuallyControlledSections.contains('Completed')) {
      newState['Completed'] = completedGames.isNotEmpty;
    }
    if (abandonedGames != null &&
        !_manuallyControlledSections.contains('Abandoned')) {
      newState['Abandoned'] = abandonedGames.isNotEmpty;
    }

    // Update wishlist sections only if provided and not manually controlled
    if (orderedGames != null &&
        !_manuallyControlledSections.contains('Ordered')) {
      newState['Ordered'] = orderedGames.isNotEmpty;
    }
    if (wishlistGames != null &&
        !_manuallyControlledSections.contains('Wish List')) {
      newState['Wish List'] = wishlistGames.isNotEmpty;
    }

    // Merge with existing state, only updating the sections that were provided and not manually controlled
    if (newState.isNotEmpty) {
      state = {...state, ...newState};
    }
  }

  void resetToDefaults() {
    _manuallyControlledSections.clear();
    state = {
      'Playing': true,
      'Ongoing/Frequently Played': false,
      'Backlog': false,
      'Completed': false,
      'Abandoned': false,
      'Ordered': true,
      'Wish List': false,
    };
  }

  // Method to reset manual control (useful for testing or app reset)
  void resetManualControl() {
    _manuallyControlledSections.clear();
  }
}

// Game image Family provider - replaces FutureBuilder pattern
@riverpod
Future<String?> gameImage(Ref ref, String imagePath) async {
  final imageService = ref.read(gameImageServiceProvider);
  return await imageService.getImagePath(imagePath);
}

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

  const GameEditFormState({
    required this.title,
    required this.platform,
    required this.status,
    this.imagePath,
    this.hasUnsavedChanges = false,
    this.isPhysical = false,
    this.barcode,
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
  }) {
    return GameEditFormState(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isPhysical: isPhysical ?? this.isPhysical,
      barcode: barcode ?? this.barcode,
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
        other.barcode == barcode;
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
        title: 'New Game',
        platform: '',
        status: defaultStatus,
        imagePath: null,
        hasUnsavedChanges: false,
        isPhysical: context.defaultIsPhysical,
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
      );
    }
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title, hasUnsavedChanges: true);
  }

  void updatePlatform(String platform) {
    state = state.copyWith(platform: platform, hasUnsavedChanges: true);
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
    );
  }

  bool get hasChanges => state.hasUnsavedChanges;
}
