import 'package:flutter/material.dart';
import '../../../styles/styles.dart';

class GameDetailSheetImage extends StatelessWidget {
  const GameDetailSheetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GameDetailSheetStyles.gameImageHeight,
      decoration: GameDetailSheetStyles.gameImageDecoration,
      child: _buildGameImageContent(),
    );
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
