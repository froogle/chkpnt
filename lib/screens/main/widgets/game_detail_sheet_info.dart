import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/shared/widgets/buttons/platform_badge.dart';

class GameDetailSheetInfo extends StatelessWidget {
  final GameItem game;
  final bool isPortrait;
  final bool showPlatformAndStatus;
  final bool showTitle;
  final VoidCallback? onEditPressed;

  const GameDetailSheetInfo({
    super.key,
    required this.game,
    this.isPortrait = true,
    this.showPlatformAndStatus = true,
    this.showTitle = true,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) _buildTitle(),
        if (showTitle && showPlatformAndStatus) const SizedBox(height: 8),
        if (showPlatformAndStatus) _buildPlatformAndStatus(),
      ],
    );
  }

  Widget _buildTitle() {
    return InkWell(
      onTap: onEditPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Text(game.title, style: GameDetailSheetStyles.gameTitleStyle),
      ),
    );
  }

  Widget _buildPlatformAndStatus() {
    if (isPortrait) {
      return _buildPortraitPlatformAndStatus();
    } else {
      return _buildLandscapePlatformAndStatus();
    }
  }

  Widget _buildPortraitPlatformAndStatus() {
    return Row(
      children: [
        PlatformBadge(platform: game.platform, onTap: onEditPressed),
        const SizedBox(width: 12),
        _buildCurrentStatusIcon(),
        const SizedBox(width: 8),
        Expanded(child: _buildCurrentStatusText()),
      ],
    );
  }

  Widget _buildLandscapePlatformAndStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PlatformBadge(platform: game.platform, onTap: onEditPressed),
            const SizedBox(width: 12),
            _buildCurrentStatusIcon(),
            const SizedBox(width: 8),
            Expanded(child: _buildCurrentStatusText()),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentStatusIcon() {
    switch (game.status) {
      case GameStatus.completed:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
      case GameStatus.playing:
        return const Icon(
          Icons.play_circle_fill,
          color: Colors.orange,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
      case GameStatus.abandoned:
        return const Icon(
          Icons.pause_circle_filled,
          color: Colors.grey,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
      case GameStatus.backlog:
        return const Icon(
          Icons.playlist_add,
          color: Colors.blue,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
      case GameStatus.wishlist:
        return const Icon(
          Icons.favorite_outline,
          color: Colors.red,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
      case GameStatus.ordered:
        return const Icon(
          Icons.shopping_cart,
          color: Colors.purple,
          size: GameDetailSheetStyles.statusButtonIconSize,
        );
    }
  }

  Widget _buildCurrentStatusText() {
    return Text(
      'Current Status: ${_getStatusDisplayText(game.status)}',
      style: GameDetailSheetStyles.currentStatusStyle,
    );
  }

  String _getStatusDisplayText(GameStatus status) {
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
    }
  }
}
