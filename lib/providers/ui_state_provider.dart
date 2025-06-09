import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'dart:io';

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

// Game image Family provider - replaces FutureBuilder pattern
@riverpod
Future<File?> gameImage(Ref ref, String imagePath) async {
  final imageService = ref.read(gameImageServiceProvider);
  return await imageService.getImageFile(imagePath);
}

// Game edit context data class to identify the editing context
class GameEditContext {
  final bool isAddMode;
  final GameItem? game;

  const GameEditContext({required this.isAddMode, this.game});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameEditContext &&
        other.isAddMode == isAddMode &&
        other.game == game;
  }

  @override
  int get hashCode => Object.hash(isAddMode, game);
}

// Game edit form state data class
class GameEditFormState {
  final String title;
  final String platform;
  final GameStatus status;
  final String? imagePath;
  final bool hasUnsavedChanges;

  const GameEditFormState({
    required this.title,
    required this.platform,
    required this.status,
    this.imagePath,
    this.hasUnsavedChanges = false,
  });

  GameEditFormState copyWith({
    String? title,
    String? platform,
    GameStatus? status,
    String? imagePath,
    bool? hasUnsavedChanges,
  }) {
    return GameEditFormState(
      title: title ?? this.title,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
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
        other.hasUnsavedChanges == hasUnsavedChanges;
  }

  @override
  int get hashCode {
    return Object.hash(title, platform, status, imagePath, hasUnsavedChanges);
  }
}

// Game edit state provider using Family - eliminates initialization issues
@riverpod
class GameEditState extends _$GameEditState {
  @override
  GameEditFormState build(GameEditContext context) {
    // Initialize state based on context - no runtime modification needed
    if (context.isAddMode) {
      return const GameEditFormState(
        title: 'New Game',
        platform: '',
        status: GameStatus.backlog,
        imagePath: null,
        hasUnsavedChanges: false,
      );
    } else {
      final game = context.game!;
      return GameEditFormState(
        title: game.title,
        platform: game.platform,
        status: game.status,
        imagePath: game.imagePath,
        hasUnsavedChanges: false,
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
    state = state.copyWith(imagePath: imagePath, hasUnsavedChanges: true);
  }

  bool get hasChanges => state.hasUnsavedChanges;
}
