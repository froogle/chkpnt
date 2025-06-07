import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

/// Reusable game image widget used across detail and edit screens
///
/// Displays game cover image with consistent styling and aspect ratio.
/// Includes Hero animation support for smooth transitions between screens.
class GameImage extends StatelessWidget {
  final String? heroTag;
  final bool enableHero;

  const GameImage({super.key, this.heroTag, this.enableHero = true});

  @override
  Widget build(BuildContext context) {
    final imageWidget = Container(
      height: GameDetailSheetStyles.gameImageHeight,
      decoration: GameDetailSheetStyles.gameImageDecoration,
      child: _buildGameImageContent(),
    );

    if (enableHero && heroTag != null) {
      return Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildGameImageContent() {
    return const Center(
      child: Icon(
        Icons.gamepad,
        size: GameDetailSheetStyles.gameImageIconSize,
        color: Colors.grey,
      ),
    );
  }
}
