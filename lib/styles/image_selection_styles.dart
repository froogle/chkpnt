import 'package:flutter/material.dart';
import 'global_styles.dart';

class ImageSelectionStyles {
  // Sheet decoration
  static BoxDecoration get sheetDecoration => const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  );

  // Header styles
  static const EdgeInsets headerPadding = EdgeInsets.all(16);
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;
  static const double dragHandleSpacing = 16.0;

  static BoxDecoration get dragHandleDecoration => BoxDecoration(
    color: AppColors.divider,
    borderRadius: BorderRadius.circular(2),
  );

  static const TextStyle headerTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  // Option tile styles
  static const EdgeInsets optionsPadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets optionTilePadding = EdgeInsets.all(16);
  static const double optionTileSpacing = 8.0;
  static const double optionTileBorderRadius = 12.0;
  static const double bottomSpacing = 16.0;

  static BoxDecoration get optionTileDecoration => BoxDecoration(
    border: Border.all(color: AppColors.divider),
    borderRadius: BorderRadius.circular(optionTileBorderRadius),
  );

  // Icon container styles
  static const double iconContainerSize = 48.0;
  static const double iconContainerBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double iconSpacing = 16.0;

  // Destructive (red) and normal (blue) color variants
  static const Color destructiveIconBackground = Color(0xFFFFEBEE);
  static const Color destructiveIconColor = Color(0xFFD32F2F);
  static const Color destructiveTextColor = Color(0xFFD32F2F);

  static const Color normalIconBackground = Color(0xFFE3F2FD);
  static const Color normalIconColor = Color(0xFF1976D2);

  static BoxDecoration getIconContainerDecoration({
    required bool isDestructive,
  }) {
    return BoxDecoration(
      color: isDestructive ? destructiveIconBackground : normalIconBackground,
      borderRadius: BorderRadius.circular(iconContainerBorderRadius),
    );
  }

  static Color getIconColor({required bool isDestructive}) {
    return isDestructive ? destructiveIconColor : normalIconColor;
  }

  // Text styles
  static TextStyle getOptionTitleStyle({required bool isDestructive}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: isDestructive ? destructiveTextColor : AppColors.primaryText,
    );
  }

  static const TextStyle optionSubtitleStyle = TextStyle(
    fontSize: 14,
    color: AppColors.expandIcon,
  );

  // Arrow icon
  static const double arrowIconSize = 16.0;
  static const Color arrowIconColor = AppColors.expandIcon;

  // Text spacing
  static const double titleSubtitleSpacing = 2.0;
}
