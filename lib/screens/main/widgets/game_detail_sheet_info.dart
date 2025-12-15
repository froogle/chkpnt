import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/utils/platform_utils.dart';

class GameDetailSheetInfo extends StatelessWidget {
  final GameItem game;
  final bool showPlatformAndStatus;
  final bool showTitle;
  final VoidCallback? onEditPressed;

  const GameDetailSheetInfo({
    super.key,
    required this.game,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusRow(),
        const SizedBox(height: 4),
        _buildFormatRow(),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _buildStatusChangedText(),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        _buildCompactPlatformBadge(),
        const SizedBox(width: 12),
        _buildCurrentStatusIcon(),
        const SizedBox(width: 8),
        Expanded(child: _buildCurrentStatusText()),
      ],
    );
  }

  Widget _buildFormatRow() {
    return Row(
      children: [
        _buildFormatBadge(),
        const SizedBox(width: 12),
        _buildFormatIcon(),
        const SizedBox(width: 8),
        Expanded(child: _buildFormatText()),
      ],
    );
  }

  Widget _buildFormatBadge() {
    final isPhysical = game.isPhysical;

    return GestureDetector(
      onTap: onEditPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isPhysical
                  ? AppColors.primaryPurple.withValues(alpha: 0.9)
                  : AppColors.expandIcon.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPhysical ? Icons.sd_card : Icons.cloud_outlined,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              isPhysical ? 'Physical' : 'Digital',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatIcon() {
    return Icon(
      game.isPhysical ? Icons.inventory_2_outlined : Icons.download_outlined,
      color: AppColors.primaryPurple,
      size: InputStyles.statusButtonIconSize,
    );
  }

  Widget _buildFormatText() {
    return Text(
      game.isPhysical ? 'Boxed Copy' : 'Download',
      style: AppLayout.detailSubtitleStyle,
    );
  }

  Widget _buildCompactPlatformBadge() {
    final displayPlatform = PlatformUtils.abbreviatePlatformName(game.platform);

    return GestureDetector(
      onTap: onEditPressed,
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
    );
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
      case GameStatus.ongoing:
        return const Color(0xFF06B6D4);
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
      case GameStatus.ongoing:
        return Icons.replay;
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
      case GameStatus.ongoing:
        return Icon(
          Icons.replay,
          color: AppColors.primaryPurple,
          size: InputStyles.statusButtonIconSize,
        );
    }
  }

  Widget _buildCurrentStatusText() {
    return Text(
      _getStatusDisplayText(game.status),
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
      case GameStatus.ongoing:
        return 'Ongoing';
    }
  }

  Widget _buildStatusChangedText() {
    return Text(
      'Status changed: ${_getStatusChangedDisplayText(game.lastStatusChange)}',
      style: AppLayout.detailSubtitleStyle.copyWith(
        fontSize: 12,
        color: AppColors.expandIcon.withValues(alpha: 0.8),
      ),
    );
  }

  String _getStatusChangedDisplayText(DateTime statusChanged) {
    final now = DateTime.now();
    final difference = now.difference(statusChanged);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}
