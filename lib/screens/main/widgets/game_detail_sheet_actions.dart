import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class GameDetailSheetActions extends StatelessWidget {
  final VoidCallback? onEditPressed;
  final VoidCallback? onSavePressed;
  final VoidCallback? onDeletePressed;
  final bool hasChanges;

  const GameDetailSheetActions({
    super.key,
    this.onEditPressed,
    this.onSavePressed,
    this.onDeletePressed,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDeleteButton(),
        SizedBox(width: InputStyles.actionButtonSpacing),
        _buildEditButton(),
        SizedBox(width: InputStyles.actionButtonSpacing),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildEditButton() {
    return Expanded(
      child: OutlinedButton(
        onPressed: onEditPressed,
        style: InputStyles.secondaryActionButtonStyle,
        child: const Text('Edit'),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Expanded(
      child: InputStyles.primaryActionButton(
        onPressed: hasChanges ? onSavePressed : null,
        enabled: hasChanges,
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: hasChanges ? Colors.white : AppColors.expandIcon,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: OutlinedButton(
        onPressed: onDeletePressed,
        style: InputStyles.secondaryActionButtonStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(Colors.red),
          side: WidgetStateProperty.all(const BorderSide(color: Colors.red)),
        ),
        child: const Text('Delete'),
      ),
    );
  }
}
