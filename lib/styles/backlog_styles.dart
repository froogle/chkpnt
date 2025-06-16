import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';

/// Styles specific to the backlog screen components
class BacklogStyles {
  // === SORTING CONTROLS ===

  /// Container padding for sorting controls row
  static const EdgeInsets sortingControlsPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  /// Spacing between sorting chips
  static const double sortingChipSpacing = 8.0;

  /// Padding inside sorting chips
  static const EdgeInsets sortingChipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );

  /// Border radius for sorting chips
  static const double sortingChipBorderRadius = 16.0;

  /// Border width for sorting chips
  static const double sortingChipBorderWidth = 1.0;

  /// Spacing between chip text and icon
  static const double sortingChipIconSpacing = 4.0;

  /// Icon size in sorting chips
  static const double sortingChipIconSize = 12.0;

  // === SORTING CHIP COLORS ===

  /// Active chip background color
  static const Color activeSortingChipColor = AppColors.lightPurple;

  /// Inactive chip background color
  static Color get inactiveSortingChipColor =>
      AppColors.primaryPurple.withValues(alpha: 0.1);

  /// Active chip border color
  static const Color activeSortingChipBorderColor = AppColors.lightPurple;

  /// Inactive chip border color
  static Color get inactiveSortingChipBorderColor =>
      AppColors.primaryPurple.withValues(alpha: 0.2);

  /// Active chip text color
  static const Color activeSortingChipTextColor = Colors.white;

  /// Inactive chip text color
  static Color get inactiveSortingChipTextColor =>
      AppColors.primaryPurple.withValues(alpha: 0.8);

  /// Active chip icon color
  static const Color activeSortingChipIconColor = Colors.white;

  // === TEXT STYLES ===

  /// Text style for active sorting chips
  static const TextStyle activeSortingChipTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: activeSortingChipTextColor,
  );

  /// Text style for inactive sorting chips
  static TextStyle get inactiveSortingChipTextStyle => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: inactiveSortingChipTextColor,
  );

  // === DECORATIONS ===

  /// Decoration for active sorting chips
  static BoxDecoration get activeSortingChipDecoration => BoxDecoration(
    color: activeSortingChipColor,
    borderRadius: BorderRadius.circular(sortingChipBorderRadius),
    border: Border.all(
      color: activeSortingChipBorderColor,
      width: sortingChipBorderWidth,
    ),
  );

  /// Decoration for inactive sorting chips
  static BoxDecoration get inactiveSortingChipDecoration => BoxDecoration(
    color: inactiveSortingChipColor,
    borderRadius: BorderRadius.circular(sortingChipBorderRadius),
    border: Border.all(
      color: inactiveSortingChipBorderColor,
      width: sortingChipBorderWidth,
    ),
  );

  // === PLATFORM SECTION ===

  /// Spacing between platform sections
  static const double platformSectionSpacing = 20.0;

  /// Spacing between section header and content
  static const double platformSectionHeaderSpacing = 16.0;
}
