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
      child: _buildGradientButton(
        onPressed: onEditPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            const Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        gradient: AppGradients.buttonGradient,
        shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Expanded(
      child: _buildGradientButton(
        onPressed: hasChanges ? onSavePressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.save,
              size: 16,
              color: hasChanges ? Colors.white : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              'Save',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasChanges ? Colors.white : Colors.grey[500],
              ),
            ),
          ],
        ),
        gradient:
            hasChanges
                ? AppGradients.buttonGradient
                : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[100]!, Colors.grey[300]!],
                ),
        shadowColor:
            hasChanges ? AppColors.primaryPurple.withValues(alpha: 0.3) : null,
        enabled: hasChanges,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: _buildGradientButton(
        onPressed: onDeletePressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            const Text(
              'Delete',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        gradient: AppGradients.buttonGradient,
        shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildGradientButton({
    required Widget child,
    required VoidCallback? onPressed,
    required LinearGradient gradient,
    Color? shadowColor,
    bool enabled = true,
  }) {
    return Container(
      height: InputStyles.actionButtonCompactHeight,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: InputStyles.actionButtonBorderRadius,
        boxShadow:
            enabled && shadowColor != null
                ? [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: InputStyles.actionButtonBorderRadius,
          child: Container(
            padding: InputStyles.actionButtonCompactPadding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
