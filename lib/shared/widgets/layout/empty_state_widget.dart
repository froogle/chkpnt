import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? actionButton;
  final double? height;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.actionButton,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MainScreenStyles.emptyStateHeight,
      width: double.infinity,
      decoration: MainScreenStyles.emptyStateDecoration,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: MainScreenStyles.emptyStateIconSize,
          color: MainScreenStyles.emptyStateIconColor,
        ),
        const SizedBox(height: MainScreenStyles.emptyStateSpacing),
        Text(
          message,
          style: MainScreenStyles.emptyStateTextStyle,
          textAlign: TextAlign.center,
        ),
        if (actionButton != null) ...[
          const SizedBox(height: MainScreenStyles.emptyStateSpacing),
          actionButton!,
        ],
      ],
    );
  }
}
