import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Centralised styling for confirmation and information dialogs
class AppDialogStyles {
  static const Color backgroundColor = Colors.white;
  static const Color surfaceTintColor = Colors.transparent;
  static const double elevation = 8;
  static const double borderRadius = 16;

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle contentTextStyle = TextStyle(
    fontSize: 14,
    height: 1.4,
    color: AppColors.primaryText,
  );

  static const Color cancelButtonColor = AppColors.emptyStateText;
  static const Color confirmButtonColor = AppColors.primaryPurple;
  static const Color destructiveButtonColor = Color(0xFFD32F2F);

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static RoundedRectangleBorder get shape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));

  static ButtonStyle buttonStyle(Color foregroundColor) =>
      TextButton.styleFrom(
        foregroundColor: foregroundColor,
        textStyle: buttonTextStyle,
      );
}
