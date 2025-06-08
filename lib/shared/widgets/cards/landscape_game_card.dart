import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class LandscapeGameCard extends ConsumerWidget {
  final GameItem game;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;

  const LandscapeGameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: MainScreenStyles.landscapeGameCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildCardContent(ref),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(WidgetRef ref) {
    return Stack(
      children: [
        _buildBackground(ref),
        _buildGradientOverlay(),
        _buildTextContent(),
        if (game.status == GameStatus.completed) _buildCompletedBadge(),
      ],
    );
  }

  Widget _buildBackground(WidgetRef ref) {
    return Positioned.fill(
      child: Container(
        decoration: MainScreenStyles.gameImageDecoration,
        child: _buildGameImageContent(ref),
      ),
    );
  }

  Widget _buildGameImageContent(WidgetRef ref) {
    if (game.imagePath == null || game.imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    // Use the new Family provider instead of FutureBuilder
    final imageAsync = ref.watch(gameImageProvider(game.imagePath!));

    return imageAsync.when(
      data: (imageFile) {
        if (imageFile != null) {
          return _buildActualImage(imageFile);
        }
        return _buildPlaceholder();
      },
      loading: () => _buildLoadingPlaceholder(),
      error: (error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(Icons.gamepad, size: 64, color: Colors.grey),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
      ),
    );
  }

  Widget _buildActualImage(File imageFile) {
    return Image.file(
      imageFile,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: MainScreenStyles.landscapeGameCardGradientDecoration,
      ),
    );
  }

  Widget _buildTextContent() {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 4),
          _buildPlatform(),
          const SizedBox(height: 8),
          _buildStatusRow(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      game.title,
      style: MainScreenStyles.landscapeGameCardTitleStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPlatform() {
    return Text(
      game.platform,
      style: MainScreenStyles.landscapeGameCardPlatformStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildStatusWithIcon()),
        if (game.status == GameStatus.backlog && onPlayPressed != null)
          _buildPlayButton(),
      ],
    );
  }

  Widget _buildStatusWithIcon() {
    return Row(
      children: [
        _buildStatusIcon(),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _getStatusText(),
            style: MainScreenStyles.landscapeGameCardStatusStyle,
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
          size: 16,
        );
      case GameStatus.playing:
        return const Icon(
          Icons.play_circle_fill,
          color: Colors.orange,
          size: 16,
        );
      case GameStatus.abandoned:
        return const Icon(
          Icons.pause_circle_filled,
          color: Colors.grey,
          size: 16,
        );
      case GameStatus.backlog:
        return const SizedBox.shrink();
      case GameStatus.wishlist:
        return const Icon(Icons.favorite_outline, color: Colors.red, size: 16);
      case GameStatus.ordered:
        return const Icon(Icons.shopping_cart, color: Colors.blue, size: 16);
    }
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: onPlayPressed,
      child: Container(
        padding: MainScreenStyles.smallIconPadding,
        decoration: MainScreenStyles.playActionButtonDecoration,
        child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: MainScreenStyles.tinyIconPadding,
        decoration: MainScreenStyles.completedBadgeDecoration,
        child: const Icon(Icons.check, color: Colors.white, size: 16),
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
