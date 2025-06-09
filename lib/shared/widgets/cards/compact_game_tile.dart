import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class CompactGameTile extends ConsumerWidget {
  final GameItem game;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;

  const CompactGameTile({
    super.key,
    required this.game,
    required this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: _buildTileDecoration(),
              child: _buildImageSection(ref),
            ),
          ),
        ),
        const SizedBox(height: 6),
        _buildTitleSection(),
      ],
    );
  }

  BoxDecoration _buildTileDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildImageSection(WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey.shade300,
        child: Stack(
          children: [
            _buildGameImage(ref),
            _buildImageOverlay(),
            _buildStatusOverlay(),
            if (game.status == GameStatus.backlog && onPlayPressed != null)
              _buildPlayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameImage(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _buildGameImageContent(ref),
    );
  }

  Widget _buildGameImageContent(WidgetRef ref) {
    if (game.imagePath == null || game.imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

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
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.gamepad, size: 32, color: Colors.grey),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
        ),
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

  Widget _buildImageOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
            stops: const [0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOverlay() {
    return Positioned(
      left: 8,
      bottom: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _getStatusColor().withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getStatusIcon(), size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                game.platform,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      right: 8,
      top: 8,
      child: GestureDetector(
        onTap: onPlayPressed,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        game.title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
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
}
