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
        child: Text(game.title, style: AppLayout.detailTitleStyle),
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
            _buildCompactPlatformBadge(),
            const SizedBox(width: 12),
            _buildCurrentStatusIcon(),
            const SizedBox(width: 8),
            Expanded(child: _buildCurrentStatusText()),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactPlatformBadge() {
    final displayPlatform = _getCompactPlatformName(game.platform);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEditPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStatusIcon(), size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                displayPlatform,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCompactPlatformName(String platform) {
    switch (platform.toLowerCase()) {
      case 'gameboy advance':
      case 'game boy advance':
        return 'GBA';
      case 'nintendo switch':
        return 'Switch';
      case 'nintendo 3ds':
        return '3DS';
      case 'nintendo ds':
        return 'DS';
      case 'playstation 5':
        return 'PS5';
      case 'playstation 4':
        return 'PS4';
      case 'playstation 3':
        return 'PS3';
      case 'playstation 2':
        return 'PS2';
      case 'xbox series x':
      case 'xbox series s':
        return 'Xbox';
      case 'xbox one':
        return 'Xbox One';
      case 'steam deck':
        return 'Steam';
      default:
        return platform.length > 8
            ? '${platform.substring(0, 8)}...'
            : platform;
    }
  }

  Color _getStatusColor() {
    switch (game.status) {
      case GameStatus.playing:
        return Colors.orange;
      case GameStatus.completed:
        return Colors.green;
      case GameStatus.backlog:
        return Colors.blue;
      case GameStatus.abandoned:
        return Colors.grey;
      case GameStatus.wishlist:
        return Colors.red;
      case GameStatus.ordered:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon() {
    switch (game.status) {
      case GameStatus.playing:
        return Icons.play_circle_fill;
      case GameStatus.completed:
        return Icons.check_circle;
      case GameStatus.backlog:
        return Icons.schedule;
      case GameStatus.abandoned:
        return Icons.pause_circle_filled;
      case GameStatus.wishlist:
        return Icons.favorite;
      case GameStatus.ordered:
        return Icons.shopping_cart;
    }
  }

  Widget _buildCurrentStatusIcon() {
    switch (game.status) {
      case GameStatus.completed:
        return Icon(
          Icons.check_circle,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
      case GameStatus.playing:
        return Icon(
          Icons.play_circle_filled,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
      case GameStatus.abandoned:
        return Icon(
          Icons.pause_circle_filled,
          color: AppColors.expandIcon,
          size: InputStyles.statusButtonIconSize,
        );
      case GameStatus.backlog:
        return Icon(
          Icons.list,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
      case GameStatus.wishlist:
        return Icon(
          Icons.favorite,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
      case GameStatus.ordered:
        return Icon(
          Icons.shopping_cart,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
    }
  }

  Widget _buildCurrentStatusText() {
    return Text(
      'Current Status: ${_getStatusDisplayText(game.status)}',
      style: AppLayout.detailSubtitleStyle,
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
