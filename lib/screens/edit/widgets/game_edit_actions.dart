import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class GameEditActions extends StatelessWidget {
  final VoidCallback onSavePressed;
  final bool hasChanges;

  const GameEditActions({
    super.key,
    required this.onSavePressed,
    required this.hasChanges,
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
              Icons.save,
              size: EditScreenStyles.saveButtonIconSize,
              color: EditScreenStyles.saveButtonIconColour(hasChanges),
            ),
            const SizedBox(width: EditScreenStyles.saveButtonIconSpacing),
            Text(
              'Save Changes',
              style: EditScreenStyles.saveButtonTextStyle(hasChanges),
            ),
          ],
        ),
      ),
    );
  }
}
