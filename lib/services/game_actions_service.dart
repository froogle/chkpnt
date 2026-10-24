import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/status_styles.dart';

class GameActionsService {
  final Ref _ref;

  GameActionsService(this._ref);

  /// Handles starting to play a game (moving from backlog to playing)
  Future<void> startPlayingGame(GameItem game, BuildContext context) async {
    final playing = StatusStyles.of(GameStatus.playing);

    // Ensure playing section is expanded for better visual feedback
    _ref
        .read(sectionExpansionProvider.notifier)
        .expandSection(const StatusSection(GameStatus.playing));

    // Small delay before making the actual change for better visual effect
    await Future.delayed(const Duration(milliseconds: 100));

    // Actually move the game
    await _ref.read(gameListProvider.notifier).startPlaying(game.id);

    // Small delay before showing feedback
    await Future.delayed(const Duration(milliseconds: 200));

    // Show feedback
    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${game.title} moved to ${playing.label}!',
        icon: playing.icon,
        color: playing.colour,
      );
    }
  }

  /// Handles updating a game's details (title, platform, status)
  Future<void> updateGame(
    GameItem originalGame,
    GameItem updatedGame,
    BuildContext context,
  ) async {
    // Update the game in the provider
    await _ref.read(gameListProvider.notifier).updateGame(updatedGame);

    // Determine what changed for appropriate feedback
    final titleChanged = originalGame.title != updatedGame.title;
    final platformChanged = originalGame.platform != updatedGame.platform;
    final statusChanged = originalGame.status != updatedGame.status;

    // Build feedback message based on what changed
    String message = '${updatedGame.title} updated!';
    IconData? icon = Icons.check_circle;
    Color color = Colors.green;

    if (statusChanged) {
      // Expand the relevant section if status changed
      final style = StatusStyles.of(updatedGame.status);
      if (updatedGame.status != GameStatus.owned) {
        _ref
            .read(sectionExpansionProvider.notifier)
            .expandSection(StatusSection(updatedGame.status));
      }

      message = '${updatedGame.title} moved to ${style.label}!';
      icon = style.icon;
      color = style.colour;
    } else if (titleChanged || platformChanged) {
      message = '${updatedGame.title} details updated!';
      icon = Icons.edit;
      color = Colors.blue;
    }

    // Show feedback
    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: message,
        icon: icon,
        color: color,
      );
    }
  }

  /// Handles adding a new game with user feedback
  Future<void> addGame(GameItem newGame, BuildContext context) async {
    await _ref.read(gameListProvider.notifier).addGame(newGame);

    // Expand the relevant section for the new game's status
    final style = StatusStyles.of(newGame.status);
    if (newGame.status != GameStatus.owned) {
      _ref
          .read(sectionExpansionProvider.notifier)
          .expandSection(StatusSection(newGame.status));
    }

    // Show feedback
    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${newGame.title} added to ${style.label}!',
        icon: style.icon,
        color: style.colour,
      );
    }
  }

  /// Handles deleting a game
  Future<void> deleteGame(GameItem game, BuildContext context) async {
    await _ref.read(gameListProvider.notifier).removeGame(game.id);

    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${game.title} deleted!',
        icon: Icons.delete_forever,
        color: Colors.red,
      );
    }
  }

  /// Shows consistent feedback for game actions
  void _showGameActionFeedback({
    required BuildContext context,
    required String message,
    required IconData? icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
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
