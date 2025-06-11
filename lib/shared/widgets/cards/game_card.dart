import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

enum GameCardLayout {
  compact, // Text below image (current CompactGameTile)
  overlay, // Text overlaid on image (current PortraitGameCard style)
  detailed, // Text at bottom with gradient (current LandscapeGameCard style)
}

enum GameCardSize {
  small, // Grid tiles
  medium, // Standard cards
  large, // Featured cards
}

class GameCard extends ConsumerWidget {
  final GameItem game;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;
  final GameCardLayout layout;
  final GameCardSize size;
  final double? height;
  final double? aspectRatio;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.onPlayPressed,
    this.layout = GameCardLayout.compact,
    this.size = GameCardSize.small,
    this.height,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildCardContainer();
  }

  Widget _buildCardContainer() {
    final cardHeight = height ?? _getDefaultHeight();
    final borderRadius = _getBorderRadius();

    // All layouts now use the same container structure with text overlaid on image
    return SizedBox(height: cardHeight, child: _buildCard(borderRadius));
  }

  Widget _buildCard(double borderRadius) {
    return Container(
      decoration: _getCardDecoration(borderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
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
        if (layout == GameCardLayout.compact) _buildCompactText(),
        if (layout == GameCardLayout.overlay) _buildOverlayText(),
        if (layout == GameCardLayout.detailed) _buildDetailedText(),
        if (layout != GameCardLayout.compact &&
            game.status == GameStatus.backlog &&
            onPlayPressed != null)
          _buildPlayButton(),
        if (layout != GameCardLayout.compact &&
            game.status == GameStatus.completed)
          _buildCompletedBadge(),
      ],
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
          data: (imageFile) {
            if (imageFile != null) {
              return _buildActualImage(imageFile);
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
    final iconSize = _getPlaceholderIconSize();
    return Center(
      child: Icon(Icons.gamepad, size: iconSize, color: Colors.grey),
    );
  }

  Widget _buildLoadingPlaceholder() {
    final loadingSize = size == GameCardSize.large ? 32.0 : 24.0;
    return Center(
      child: SizedBox(
        width: loadingSize,
        height: loadingSize,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey,
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

  Widget _buildGradientOverlay() {
    switch (layout) {
      case GameCardLayout.compact:
        return Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x40000000), // Light overlay for text readability
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        );
      case GameCardLayout.overlay:
        return Positioned.fill(
          child: Container(
            decoration: MainScreenStyles.portraitGameCardGradientDecoration,
          ),
        );
      case GameCardLayout.detailed:
        return Positioned.fill(
          child: Container(
            decoration: MainScreenStyles.landscapeGameCardGradientDecoration,
          ),
        );
    }
  }

  Widget _buildCompactText() {
    return Stack(
      children: [
        // Game title at top left
        Positioned(
          left: 12,
          top: 12,
          right: 12,
          child: Text(
            game.title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Platform at bottom with orange styling
        Positioned(
          left: 12,
          bottom: 12,
          right:
              game.status == GameStatus.backlog
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
        ),
        // Play button for backlog games
        if (game.status == GameStatus.backlog && onPlayPressed != null)
          Positioned(
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
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOverlayText() {
    final padding = _getTextPadding();

    return Positioned(
      left: padding.left,
      top: padding.top,
      bottom: padding.bottom,
      right: padding.right + 100, // Space for play button
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

  Widget _buildDetailedText() {
    final padding = _getTextPadding();

    return Positioned(
      left: padding.left,
      right: padding.right,
      bottom: padding.bottom,
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

  Widget _buildGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [_buildTitle(), const SizedBox(height: 4), _buildPlatform()],
    );
  }

  Widget _buildTitle() {
    final textStyle =
        layout == GameCardLayout.detailed
            ? MainScreenStyles.landscapeGameCardTitleStyle
            : MainScreenStyles.portraitGameCardTitleStyle;

    return Text(
      game.title,
      style: textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPlatform() {
    final textStyle =
        layout == GameCardLayout.detailed
            ? MainScreenStyles.landscapeGameCardPlatformStyle
            : MainScreenStyles.portraitGameCardPlatformStyle;

    return Text(
      game.platform,
      style: textStyle,
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

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildStatusWithIcon()),
        if (game.status == GameStatus.backlog && onPlayPressed != null)
          _buildDetailedPlayButton(),
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
    final iconSize = layout == GameCardLayout.detailed ? 16.0 : 18.0;

    switch (game.status) {
      case GameStatus.completed:
        return Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: iconSize,
        );
      case GameStatus.playing:
        return Icon(
          Icons.play_circle_fill,
          color: Colors.orange,
          size: iconSize,
        );
      case GameStatus.abandoned:
        return Icon(
          Icons.pause_circle_filled,
          color: Colors.grey,
          size: iconSize,
        );
      case GameStatus.backlog:
        return const SizedBox.shrink();
      case GameStatus.wishlist:
        return Icon(Icons.favorite_outline, color: Colors.red, size: iconSize);
      case GameStatus.ordered:
        return Icon(Icons.shopping_cart, color: Colors.blue, size: iconSize);
    }
  }

  Widget _buildPlayButton() {
    switch (layout) {
      case GameCardLayout.compact:
      case GameCardLayout.overlay:
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
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      case GameCardLayout.detailed:
        return const SizedBox.shrink(); // Handled in status row
    }
  }

  Widget _buildDetailedPlayButton() {
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
    switch (layout) {
      case GameCardLayout.compact:
      case GameCardLayout.overlay:
        return Positioned(
          right: 20,
          top: 20,
          child: Container(
            padding: MainScreenStyles.smallIconPadding,
            decoration: MainScreenStyles.portraitCompletedBadgeDecoration,
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
        );
      case GameCardLayout.detailed:
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
  }

  // Helper methods
  double _getDefaultHeight() {
    switch (size) {
      case GameCardSize.small:
        return layout == GameCardLayout.compact ? 120 : 120;
      case GameCardSize.medium:
        return 140;
      case GameCardSize.large:
        return 180;
    }
  }

  double _getBorderRadius() {
    switch (layout) {
      case GameCardLayout.compact:
      case GameCardLayout.overlay:
        return 16;
      case GameCardLayout.detailed:
        return 12;
    }
  }

  double _getPlaceholderIconSize() {
    switch (size) {
      case GameCardSize.small:
        return layout == GameCardLayout.detailed ? 64 : 32;
      case GameCardSize.medium:
        return 48;
      case GameCardSize.large:
        return 64;
    }
  }

  EdgeInsets _getTextPadding() {
    switch (layout) {
      case GameCardLayout.overlay:
        return const EdgeInsets.fromLTRB(16, 14, 16, 16);
      case GameCardLayout.detailed:
        return const EdgeInsets.fromLTRB(12, 12, 12, 10);
      case GameCardLayout.compact:
        return EdgeInsets.zero;
    }
  }

  BoxDecoration _getCardDecoration(double borderRadius) {
    switch (layout) {
      case GameCardLayout.compact:
      case GameCardLayout.overlay:
        return MainScreenStyles.gameCardDecoration;
      case GameCardLayout.detailed:
        return MainScreenStyles.landscapeGameCardDecoration;
    }
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
