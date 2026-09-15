import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class GameEditActions extends StatelessWidget {
  final VoidCallback onSavePressed;
  final bool hasChanges;
  final String buttonText;
  final IconData icon;

  const GameEditActions({
    super.key,
    required this.onSavePressed,
    required this.hasChanges,
    this.buttonText = 'Save Changes',
    this.icon = Icons.save,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildSaveButton()]);
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasChanges ? onSavePressed : null,
        style: EditScreenStyles.saveButtonStyle(hasChanges),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: EditScreenStyles.saveButtonIconSize,
              color: EditScreenStyles.saveButtonIconColour(hasChanges),
            ),
            const SizedBox(width: EditScreenStyles.saveButtonIconSpacing),
            Text(
              buttonText,
              style: EditScreenStyles.saveButtonTextStyle(hasChanges),
            ),
          ],
        ),
      ),
    );
  }
}
