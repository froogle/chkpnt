import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/styles/dialog_styles.dart';

class AttributionModal extends StatelessWidget {
  final VoidCallback onDismiss;

  const AttributionModal({super.key, required this.onDismiss});

  static Future<void> show(BuildContext context, VoidCallback onDismiss) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AttributionModal(onDismiss: onDismiss),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppDialogStyles.backgroundColor,
      surfaceTintColor: AppDialogStyles.surfaceTintColor,
      elevation: AppDialogStyles.elevation,
      shape: AppDialogStyles.shape,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppGradients.buttonGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Thank the maker!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
      content: const Text(
        'Guides are written by dedicated volunteers who spend countless hours helping fellow gamers.\n\n'
        'If you find a guide helpful, please consider visiting the original page and supporting the author with a donation.\n\n'
        'You can visit any guide\'s original page from the reader toolbar.',
        style: AppDialogStyles.contentTextStyle,
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
          ),
          child: const Text('Got it!'),
        ),
      ],
    );
  }
}
