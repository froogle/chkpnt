import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

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
    await _ref.read(gameListProvider.notifier).startPlaying(game.id);

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
    await _ref.read(gameListProvider.notifier).markCompleted(game.id);

    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${game.title} completed!',
        icon: Icons.check_circle,
        color: Colors.blue,
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
    IconData icon = Icons.check_circle;
    Color color = Colors.green;

    if (statusChanged) {
      // Expand the relevant section if status changed
      final statusName = _getStatusDisplayName(updatedGame.status);
      _ref.read(sectionExpansionProvider.notifier).expandSection(statusName);

      message = '${updatedGame.title} moved to $statusName!';
      icon = _getStatusIcon(updatedGame.status);
      color = _getStatusColor(updatedGame.status);
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
    await _ref
        .read(gameListProvider.notifier)
        .addGame(
          GameItem.create(
            title: newGame.title,
            platform: newGame.platform,
            status: newGame.status,
            imagePath: newGame.imagePath,
            remoteImageUrl: newGame.remoteImageUrl,
          ),
        );

    // Expand the relevant section for the new game's status
    final statusName = _getStatusDisplayName(newGame.status);
    _ref.read(sectionExpansionProvider.notifier).expandSection(statusName);

    // Show feedback
    if (context.mounted) {
      _showGameActionFeedback(
        context: context,
        message: '${newGame.title} added to $statusName!',
        icon: _getStatusIcon(newGame.status),
        color: _getStatusColor(newGame.status),
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

  /// Gets the display name for a game status
  String _getStatusDisplayName(GameStatus status) {
    switch (status) {
      case GameStatus.playing:
        return 'Playing';
      case GameStatus.completed:
        return 'Completed';
      case GameStatus.backlog:
        return 'Backlog';
      case GameStatus.abandoned:
        return 'Abandoned';
      case GameStatus.wishlist:
        return 'Wishlist';
      case GameStatus.ordered:
        return 'Ordered';
      case GameStatus.ongoing:
        return 'Ongoing/Frequently Played';
    }
  }

  /// Gets the appropriate icon for a game status
  IconData _getStatusIcon(GameStatus status) {
    switch (status) {
      case GameStatus.playing:
        return Icons.play_circle_fill;
      case GameStatus.completed:
        return Icons.check_circle;
      case GameStatus.backlog:
        return Icons.list;
      case GameStatus.abandoned:
        return Icons.pause_circle_filled;
      case GameStatus.wishlist:
        return Icons.favorite;
      case GameStatus.ordered:
        return Icons.shopping_cart;
      case GameStatus.ongoing:
        return Icons.replay;
    }
  }

  /// Gets the appropriate color for a game status
  Color _getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.playing:
        return Colors.orange;
      case GameStatus.completed:
        return Colors.green;
      case GameStatus.backlog:
        return Colors.blue;
      case GameStatus.abandoned:
        return Colors.grey;
      case GameStatus.wishlist:
        return Colors.green;
      case GameStatus.ordered:
        return Colors.purple;
      case GameStatus.ongoing:
        return const Color(0xFF06B6D4);
    }
  }
}

/// Provider for the game actions service
final gameActionsServiceProvider = Provider<GameActionsService>((ref) {
  return GameActionsService(ref);
});
