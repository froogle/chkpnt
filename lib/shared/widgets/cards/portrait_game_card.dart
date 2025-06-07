import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/models/game_models.dart';

class PortraitGameCard extends StatelessWidget {
  final GameItem game;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;

  const PortraitGameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: MainScreenStyles.gameCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildCardContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Stack(
      children: [
        _buildBackground(),
        _buildGradientOverlay(),
        _buildTextContent(),
        if (game.status == GameStatus.backlog && onPlayPressed != null)
          _buildPlayActionButton(),
        if (game.status == GameStatus.completed) _buildCompletedBadge(),
      ],
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: MainScreenStyles.gameImageDecoration,
        child: const Icon(Icons.gamepad, size: 48, color: Colors.grey),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: MainScreenStyles.portraitGameCardGradientDecoration,
      ),
    );
  }

  Widget _buildTextContent() {
    return Positioned(
      left: 16,
      top: 16,
      bottom: 16,
      right: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildGameInfo()),
          const SizedBox(height: 8),
          _buildGameStatus(),
        ],
      ),
    );
  }

  Widget _buildGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [_buildTitle(), const SizedBox(height: 4), _buildPlatform()],
    );
  }

  Widget _buildTitle() {
    return Text(
      game.title,
      style: MainScreenStyles.portraitGameCardTitleStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPlatform() {
    return Text(
      game.platform,
      style: MainScreenStyles.portraitGameCardPlatformStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildGameStatus() {
    return Row(
      children: [
        _buildStatusIcon(),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _getStatusText(),
            style: MainScreenStyles.portraitGameCardStatusStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon() {
    switch (game.status) {
      case GameStatus.completed:
        return const Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 18,
        );
      case GameStatus.playing:
        return const Icon(
          Icons.play_circle_fill,
          color: Colors.orange,
          size: 18,
        );
      case GameStatus.abandoned:
        return const Icon(
          Icons.pause_circle_filled,
          color: Colors.grey,
          size: 18,
        );
      case GameStatus.backlog:
        return const SizedBox.shrink();
      case GameStatus.wishlist:
        return const Icon(Icons.favorite_outline, color: Colors.red, size: 18);
      case GameStatus.ordered:
        return const Icon(Icons.shopping_cart, color: Colors.blue, size: 18);
    }
  }

  Widget _buildPlayActionButton() {
    return Positioned(
      right: 16,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: onPlayPressed,
          child: Container(
            padding: MainScreenStyles.addGameIconButtonPadding,
            decoration: MainScreenStyles.portraitPlayActionButtonDecoration,
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Positioned(
      right: 20,
      top: 20,
      child: Container(
        padding: MainScreenStyles.smallIconPadding,
        decoration: MainScreenStyles.portraitCompletedBadgeDecoration,
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      ),
    );
  }

  String _getStatusText() {
    switch (game.status) {
      case GameStatus.playing:
        return 'In Progress';
      case GameStatus.completed:
        return 'Completed';
      case GameStatus.backlog:
        return 'In Backlog';
      case GameStatus.abandoned:
        return 'Abandoned';
      case GameStatus.wishlist:
        return 'Wishlist';
      case GameStatus.ordered:
        return 'Ordered';
    }
  }
}
