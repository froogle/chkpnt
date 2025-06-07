import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/services/game_image_service.dart';

/// Reusable game image widget used across detail and edit screens
///
/// Displays game cover image with consistent styling and aspect ratio.
/// Includes Hero animation support for smooth transitions between screens.
/// Can display either a placeholder or actual game image from storage.
class GameImage extends ConsumerWidget {
  final String? heroTag;
  final bool enableHero;
  final String? imagePath;
  final VoidCallback? onTap;

  const GameImage({
    super.key,
    this.heroTag,
    this.enableHero = true,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageWidget = GestureDetector(
      onTap: onTap,
      child: Container(
        height: GameDetailSheetStyles.gameImageHeight,
        decoration: GameDetailSheetStyles.gameImageDecoration,
        clipBehavior: Clip.antiAlias,
        child: _buildGameImageContent(ref),
      ),
    );

    if (enableHero && heroTag != null) {
      return Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildGameImageContent(WidgetRef ref) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    return FutureBuilder<File?>(
      future: ref.read(gameImageServiceProvider).getImageFile(imagePath!),
      builder: (context, snapshot) {
        // Show loading placeholder while checking if image exists
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        }

        // Show actual image if it exists
        if (snapshot.hasData && snapshot.data != null) {
          return _buildActualImage(snapshot.data!);
        }

        // Fall back to placeholder if image doesn't exist
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.gamepad,
        size: GameDetailSheetStyles.gameImageIconSize,
        color: Colors.grey,
      ),
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
}
