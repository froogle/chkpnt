import 'package:flutter/material.dart';
import 'package:chkpnt/styles/dialog_styles.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String itemName;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.itemName,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String itemName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => ConfirmDeleteDialog(title: title, itemName: itemName),
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppDialogStyles.backgroundColor,
      surfaceTintColor: AppDialogStyles.surfaceTintColor,
      elevation: AppDialogStyles.elevation,
      shape: AppDialogStyles.shape,
      title: Text(title, style: AppDialogStyles.titleTextStyle),
      content: Text(
        'Are you sure you want to delete "$itemName"?\n\nThis action cannot be undone.',
        style: AppDialogStyles.contentTextStyle,
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        style: AppDialogStyles.buttonStyle(AppDialogStyles.cancelButtonColor),
        child: const Text('Cancel', style: AppDialogStyles.buttonTextStyle),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: AppDialogStyles.buttonStyle(
          AppDialogStyles.destructiveButtonColor,
        ),
        child: const Text('Delete', style: AppDialogStyles.buttonTextStyle),
      ),
    ];
  }
}
