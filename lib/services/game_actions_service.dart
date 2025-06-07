import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_models.dart';
import '../providers/game_provider.dart';
import '../providers/ui_state_provider.dart';

class GameActionsService {
  final Ref _ref;

  GameActionsService(this._ref);

  /// Handles starting to play a game (moving from backlog to playing)
  Future<void> startPlayingGame(GameItem game, BuildContext context) async {
    // Ensure playing section is expanded for better visual feedback
    _ref.read(sectionExpansionProvider.notifier).expandSection('Playing');

    // Small delay before making the actual change for better visual effect
    await Future.delayed(const Duration(milliseconds: 100));

    // Actually move the game
    _ref.read(gameListProvider.notifier).startPlaying(game.id);

    // Small delay before showing feedback
    await Future.delayed(const Duration(milliseconds: 200));

    // Show feedback
    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${game.title} moved to Playing!',
        icon: Icons.play_circle_fill,
        color: Colors.green,
      );
    }
  }

  /// Handles marking a game as completed
  Future<void> markGameCompleted(GameItem game, BuildContext context) async {
    _ref.read(gameListProvider.notifier).markCompleted(game.id);

    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${game.title} completed!',
        icon: Icons.check_circle,
        color: Colors.blue,
      );
    }
  }

  /// Updates section expansion based on current filters
  void updateSectionExpansionForFilters() {
    final platform = _ref.read(selectedPlatformProvider);
    final searchQuery = _ref.read(searchQueryProvider);

    // Only auto-expand/collapse when filters are active
    final hasActiveFilters = platform != 'All' || searchQuery.isNotEmpty;

    if (hasActiveFilters) {
      // Get filtered games for each section
      final playingGames = _ref.read(
        fullyFilteredGamesProvider(GameStatus.playing, platform, searchQuery),
      );
      final backlogGames = _ref.read(
        fullyFilteredGamesProvider(GameStatus.backlog, platform, searchQuery),
      );
      final completedGames = _ref.read(
        fullyFilteredGamesProvider(GameStatus.completed, platform, searchQuery),
      );
      final abandonedGames = _ref.read(
        fullyFilteredGamesProvider(GameStatus.abandoned, platform, searchQuery),
      );

      // Update section expansion based on results
      _ref
          .read(sectionExpansionProvider.notifier)
          .updateExpansionBasedOnResults(
            playingGames: playingGames,
            backlogGames: backlogGames,
            completedGames: completedGames,
            abandonedGames: abandonedGames,
          );
    }
  }

  /// Shows consistent feedback for game actions
  void _showGameActionFeedback({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Provider for the game actions service
final gameActionsServiceProvider = Provider<GameActionsService>((ref) {
  return GameActionsService(ref);
});
