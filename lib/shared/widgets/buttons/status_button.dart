import 'package:flutter/material.dart';
import '../../../models/game_models.dart';
import '../../../styles/styles.dart';

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
          decoration: GameDetailSheetStyles.statusButtonDecoration(isSelected),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: GameDetailSheetStyles.statusButtonContentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusIcon(),
            const SizedBox(width: GameDetailSheetStyles.statusButtonSpacing),
            Flexible(
              child: Text(
                _getStatusDisplayText(),
                style: GameDetailSheetStyles.statusButtonTextStyle(isSelected),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (status) {
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

  String _getStatusDisplayText() {
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
