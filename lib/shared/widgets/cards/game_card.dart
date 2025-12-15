import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class GameCard extends ConsumerWidget {
  final GameItem game;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildCardContainer();
  }

  Widget _buildCardContainer() {
    return SizedBox(height: 120, child: _buildCard());
  }

  Widget _buildCard() {
    return Container(
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
        _buildCompactText(),
        if (game.isPhysical) _buildPhysicalIndicator(),
        if (game.status == GameStatus.backlog && onPlayPressed != null)
          _buildCompactPlayButton(),
      ],
    );
  }

  Widget _buildPhysicalIndicator() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.sd_card, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: MainScreenStyles.gameImageDecoration,
        child: _buildGameImageContent(),
      ),
    );
  }

  Widget _buildGameImageContent() {
    if (game.imagePath == null || game.imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    return Consumer(
      builder: (context, ref, child) {
        final imageAsync = ref.watch(gameImageProvider(game.imagePath!));

        return imageAsync.when(
          data: (imagePath) {
            if (imagePath != null) {
              return _buildActualImage(File(imagePath));
            }
            return _buildPlaceholder();
          },
          loading: () => _buildLoadingPlaceholder(),
          error: (error, stackTrace) => _buildPlaceholder(),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(Icons.gamepad, size: 32, color: Colors.grey),
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
    final hasCustomImage = _hasCustomImage();
    final gradientDecoration =
        hasCustomImage
            ? GameCardStyles.compactGameCardGradientWithImage
            : GameCardStyles.compactGameCardGradientDefault;

    return Positioned.fill(child: Container(decoration: gradientDecoration));
  }

  Widget _buildCompactText() {
    return Stack(children: [_buildCompactTitle(), _buildCompactPlatform()]);
  }

  Widget _buildCompactTitle() {
    final hasCustomImage = _hasCustomImage();
    final titleStyle =
        hasCustomImage
            ? GameCardStyles.compactGameCardTitleStyleWithImage
            : GameCardStyles.compactGameCardTitleStyleDefault;

    return Positioned(
      left: 12,
      top: 12,
      right: 12,
      child: Text(
        game.title,
        style: titleStyle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCompactPlatform() {
    return Positioned(
      left: 12,
      bottom: 12,
      right:
          game.status == GameStatus.backlog && onPlayPressed != null
              ? 50
              : 12, // Space for play button if backlog
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          game.platform,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildCompactPlayButton() {
    return Positioned(
      right: 8,
      bottom: 8,
      child: GestureDetector(
        onTap: onPlayPressed,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  /// Determines if the game has a custom image set (not using placeholder)
  bool _hasCustomImage() {
    return game.imagePath != null && game.imagePath!.isNotEmpty;
  }
}
