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
    if (game.status == GameStatus.owned) {
      return Row(children: [_buildCompactPlatformBadge()]);
    }

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
    return Row(children: [_buildFormatBadge()]);
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

  Widget _buildCompactPlatformBadge() {
    final displayPlatform = PlatformUtils.abbreviatePlatformName(game.platform);
    final hasState = game.status != GameStatus.owned;
    final style = StatusStyles.of(game.status);

    return GestureDetector(
      onTap: onEditPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: style.colour.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasState) ...[
              Icon(style.icon, size: 14, color: Colors.white),
              const SizedBox(width: 6),
            ],
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

  Widget _buildCurrentStatusIcon() {
    return Icon(
      StatusStyles.of(game.status).icon,
      color:
          game.status == GameStatus.abandoned
              ? AppColors.expandIcon
              : AppColors.primaryPurple,
      size: InputStyles.statusButtonIconSize,
    );
  }

  Widget _buildCurrentStatusText() {
    return Text(
      StatusStyles.of(game.status).label,
      style: AppLayout.detailSubtitleStyle,
    );
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
