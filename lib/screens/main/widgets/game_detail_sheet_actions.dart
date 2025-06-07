import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class GameDetailSheetActions extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onSavePressed;
  final bool hasChanges;

  const GameDetailSheetActions({
    super.key,
    this.onEditPressed,
    this.onSavePressed,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildEditButton(),
        const SizedBox(width: GameDetailSheetStyles.actionButtonSpacing),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildEditButton() {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onEditPressed,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Game'),
        style: _buildEditButtonStyle(),
      ),
    );
  }

  ButtonStyle _buildEditButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: GameDetailSheetStyles.actionButtonPadding,
      shape: const RoundedRectangleBorder(
        borderRadius: GameDetailSheetStyles.actionButtonBorderRadius,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: hasChanges ? onSavePressed : null,
        icon: const Icon(Icons.save),
        label: const Text('Save Changes'),
        style: _buildSaveButtonStyle(),
      ),
    );
  }

  ButtonStyle _buildSaveButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: GameDetailSheetStyles.actionButtonPadding,
      shape: const RoundedRectangleBorder(
        borderRadius: GameDetailSheetStyles.actionButtonBorderRadius,
      ),
    );
  }
}
