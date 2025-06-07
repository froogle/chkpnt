import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class StyledCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StyledCloseButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GameDetailSheetStyles.closeButtonDecoration,
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.close),
        iconSize: GameDetailSheetStyles.closeButtonIconSize,
        padding: GameDetailSheetStyles.closeButtonPadding,
        constraints: GameDetailSheetStyles.closeButtonConstraints,
      ),
    );
  }
}
