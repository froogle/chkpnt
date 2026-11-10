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
        Expanded(child: _buildDeleteButton()),
        SizedBox(width: InputStyles.actionButtonSpacing),
        Expanded(child: _buildEditButton()),
        SizedBox(width: InputStyles.actionButtonSpacing),
        Expanded(child: _buildSaveButton()),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return _ActionButton(
      onPressed: onDeletePressed,
      label: 'Delete',
      icon: Icons.delete,
      gradient: InputStyles.deleteActionButtonGradient,
      shadowColour: InputStyles.deleteActionButtonShadowColour,
    );
  }

  Widget _buildEditButton() {
    return _ActionButton(
      onPressed: onEditPressed,
      label: 'Edit',
      icon: Icons.edit,
      gradient: AppGradients.buttonGradient,
      shadowColour: AppColors.primaryPurple.withValues(alpha: 0.3),
    );
  }

  Widget _buildSaveButton() {
    return _ActionButton(
      onPressed: hasChanges ? onSavePressed : null,
      label: 'Save',
      icon: Icons.save,
      gradient: hasChanges
          ? AppGradients.buttonGradient
          : InputStyles.disabledActionButtonGradient,
      shadowColour: hasChanges
          ? AppColors.primaryPurple.withValues(alpha: 0.3)
          : null,
      enabled: hasChanges,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final Color? shadowColour;
  final bool enabled;

  const _ActionButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.gradient,
    this.shadowColour,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InputStyles.actionButtonCompactHeight,
      decoration: _buildButtonDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: InputStyles.actionButtonBorderRadius,
          child: Container(
            padding: InputStyles.actionButtonCompactPadding,
            child: Center(child: _buildButtonContent()),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButtonIcon(),
        SizedBox(width: AppLayout.actionButtonIconSpacing),
        _buildButtonText(),
      ],
    );
  }

  Widget _buildButtonIcon() {
    return Icon(
      icon,
      size: AppLayout.actionButtonIconSize,
      color: _getContentColour(),
    );
  }

  Widget _buildButtonText() {
    return Text(label, style: _getTextStyle());
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: InputStyles.actionButtonBorderRadius,
      boxShadow: _buildButtonShadow(),
    );
  }

  List<BoxShadow> _buildButtonShadow() {
    if (enabled && shadowColour != null) {
      return [
        BoxShadow(
          color: shadowColour!,
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
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 4,
        offset: const Offset(0, 1),
        spreadRadius: 0,
      ),
    ];
  }

  Color _getContentColour() {
    return enabled ? Colors.white : AppColors.expandIcon;
  }

  TextStyle _getTextStyle() {
    return enabled
        ? AppLayout.actionButtonTextStyle
        : AppLayout.actionButtonDisabledTextStyle;
  }
}
