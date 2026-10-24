import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';

class StatusButton extends StatelessWidget {
  final GameStatus status;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;

  const StatusButton({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: InputStyles.statusButtonDecoration(isSelected),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: InputStyles.statusButtonContentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          SizedBox(width: InputStyles.statusButtonVerticalSpacing),
          Flexible(child: _buildLabel()),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      _getStatusIcon(),
      size: InputStyles.statusButtonIconSize,
      color: _getIconColor(),
    );
  }

  Widget _buildLabel() {
    return Text(
      _getStatusLabel(),
      style: InputStyles.statusButtonTextStyle(isSelected),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  IconData _getStatusIcon() {
    switch (status) {
      case GameStatus.playing:
        return Icons.play_circle_filled;
      case GameStatus.completed:
        return Icons.check_circle;
      case GameStatus.backlog:
        return Icons.list;
      case GameStatus.abandoned:
        return Icons.do_not_disturb_on;
      case GameStatus.wishlist:
        return Icons.favorite;
      case GameStatus.ordered:
        return Icons.shopping_cart;
      case GameStatus.ongoing:
        return Icons.replay;
      case GameStatus.owned:
        return Icons.bookmark;
    }
  }

  String _getStatusLabel() {
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
      case GameStatus.owned:
        return 'In Collection';
    }
  }

  Color _getIconColor() {
    return isSelected ? AppColors.primaryPurple : AppColors.expandIcon;
  }
}
