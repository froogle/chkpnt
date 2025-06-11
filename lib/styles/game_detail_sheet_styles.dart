import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styling constants for the game detail sheet
class GameDetailSheetStyles {
  // Container and layout
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, 20, 20, 28);
  static const EdgeInsets contentPaddingLandscape = EdgeInsets.fromLTRB(
    24,
    16,
    12,
    24,
  );
  static const EdgeInsets headerPadding = EdgeInsets.only(top: 12, bottom: 12);

  // Spacing
  static const double headerSpacing = 12.0;
  static const double headerSpacingLandscape = 8.0;
  static const double sectionSpacing = 24.0;
  static const double sectionSpacingLandscape = 20.0;

  // Modern sheet decoration with gradient
  static BoxDecoration get sheetDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [
      ...AppShadows.cardElevation,
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        blurRadius: 20,
        spreadRadius: 0,
        offset: Offset(0, -8),
      ),
    ],
  );

  // Enhanced close button
  static BoxDecoration get closeButtonDecoration => BoxDecoration(
    gradient: LinearGradient(colors: [Colors.grey[50]!, Colors.grey[100]!]),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: AppShadows.subtleElevation,
  );

  static const EdgeInsets closeButtonPadding = EdgeInsets.all(10);
  static const BoxConstraints closeButtonConstraints = BoxConstraints(
    minWidth: 44,
    minHeight: 44,
  );
  static const double closeButtonIconSize = 22.0;

  // Game image
  static const double gameImageHeight = 120.0;
  static const double gameImageWidthPortrait = 140.0;
  static const double gameImageIconSize = 48.0;
  static const BorderRadius gameImageBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );

  static BoxDecoration get gameImageDecoration => BoxDecoration(
    borderRadius: gameImageBorderRadius,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.background, AppColors.collapsibleSection],
    ),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: AppShadows.subtleElevation,
  );

  // Enhanced platform badge
  static const EdgeInsets platformBadgePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const BorderRadius platformBadgeBorderRadius = BorderRadius.all(
    Radius.circular(20),
  );

  static BoxDecoration get platformBadgeDecoration => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.primaryPurple.withValues(alpha: 0.1),
        AppColors.secondaryPurple.withValues(alpha: 0.05),
      ],
    ),
    borderRadius: platformBadgeBorderRadius,
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.3),
      width: 1,
    ),
  );

  static TextStyle get platformBadgeTextStyle => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryPurple,
    letterSpacing: 0.3,
  );

  // Enhanced typography
  static const TextStyle gameTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: 0.4,
  );

  static const TextStyle currentStatusStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.expandIcon,
    letterSpacing: 0.2,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: 0.3,
  );

  // Enhanced status buttons
  static const EdgeInsets statusGridPadding = EdgeInsets.all(0);
  static const double statusGridCrossAxisSpacing = 4.0;
  static const double statusGridMainAxisSpacing = 4.0;
  static const double statusButtonHeight =
      36.0; // Slightly taller for horizontal layout
  static const double statusButtonAspectRatio =
      2.5; // More reasonable for GridView fallback
  static const double statusButtonAspectRatioWide = 2.2;
  static const BorderRadius statusButtonBorderRadius = BorderRadius.all(
    Radius.circular(18), // More rounded for pill-like appearance
  );
  static const EdgeInsets statusButtonContentPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  );
  static const double statusButtonIconSize = 16.0;
  static const double statusButtonSpacing = 10.0;
  static const double statusButtonVerticalSpacing =
      4.0; // Space between icon and text
  static const double statusButtonFontSize = 10.0;

  static BoxDecoration statusButtonDecoration(bool isSelected) => BoxDecoration(
    gradient:
        isSelected
            ? LinearGradient(
              colors: [
                AppColors.primaryPurple.withValues(alpha: 0.15),
                AppColors.secondaryPurple.withValues(alpha: 0.1),
              ],
            )
            : AppGradients.cardGradient,
    borderRadius: statusButtonBorderRadius,
    border: Border.all(
      color:
          isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.4)
              : AppColors.primaryPurple.withValues(alpha: 0.2),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: isSelected ? AppShadows.subtleElevation : null,
  );

  static TextStyle statusButtonTextStyle(bool isSelected) => TextStyle(
    fontSize: statusButtonFontSize,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    color: isSelected ? AppColors.primaryPurple : AppColors.expandIcon,
    letterSpacing: 0.2,
  );

  // Enhanced action buttons
  static const EdgeInsets actionButtonPadding = EdgeInsets.symmetric(
    vertical: 16,
  );
  static const EdgeInsets actionButtonCompactPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );
  static const double actionButtonCompactHeight = 36.0;
  static const BorderRadius actionButtonBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const double actionButtonSpacing = 12.0;

  // Close button integration
  static const double closeButtonTopMargin = 6.0;
  static const double closeButtonRightMargin = 12.0;
}
