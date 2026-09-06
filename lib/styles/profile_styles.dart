import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Profile screen specific styles and constants
class ProfileStyles {
  ProfileStyles._();

  // Layout constants
  static const double portraitSectionSpacing = 32.0;
  static const double landscapeSectionSpacing = 16.0;
  static const double sectionPadding = 20.0;
  static const double sectionBorderRadius = 16.0;

  // Header styles
  static const double profileAvatarSize = 60.0;
  static const double profileAvatarSpacing = 16.0;
  static const double profileTitleFontSize = 24.0;
  static const double profileSubtitleFontSize = 14.0;

  // Subscription section
  static const double subscriptionPortraitHeight = 160.0;
  static const double subscriptionLandscapeHeight = 100.0;

  // Chart styles
  static const double chartPortraitHeight = 350.0;
  static const double chartLandscapeHeight = 280.0;
  static const double chartPortraitRadius = 60.0;
  static const double chartLandscapeRadius = 50.0;
  static const double chartPortraitCenterSpace = 40.0;
  static const double chartLandscapeCenterSpace = 30.0;
  static const double chartSectionSpace = 2.0;

  // Empty state styles
  static const double emptyStatePortraitHeight = 250.0;
  static const double emptyStateLandscapeHeight = 200.0;
  static const double emptyStateIconSize = 48.0;
  static const double emptyStateLandscapeIconSize = 36.0;

  // Incoming games styles
  static const double gameItemSpacing = 12.0;
  static const double gameItemLandscapeSpacing = 8.0;
  static const double gameItemPadding = 16.0;
  static const double gameItemLandscapePadding = 12.0;
  static const double gameItemBorderRadius = 12.0;
  static const double gameStatusIndicatorSize = 8.0;

  // Segmented control styles
  static const EdgeInsets segmentedControlPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const double segmentedControlBorderRadius = 8.0;
  static const double segmentedControlFontSize = 14.0;

  // Legend styles
  static const double legendSpacing = 16.0;
  static const double legendRunSpacing = 8.0;
  static const double legendIndicatorSize = 12.0;
  static const double legendIndicatorSpacing = 6.0;
  static const double legendFontSize = 12.0;

  // Typography
  static TextStyle get profileTitleStyle => TextStyle(
    fontSize: profileTitleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle get profileSubtitleStyle => TextStyle(
    fontSize: profileSubtitleFontSize,
    color: AppColors.primaryText.withValues(alpha: 0.7),
  );

  static TextStyle get subscriptionTitleStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle get subscriptionLandscapeTitleStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle subscriptionComingSoonStyle(bool isLandscape) => TextStyle(
    fontSize: isLandscape ? 16 : 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText.withValues(alpha: 0.4),
  );

  static TextStyle subscriptionDescriptionStyle(bool isLandscape) => TextStyle(
    fontSize: isLandscape ? 11 : 14,
    color: AppColors.primaryText.withValues(alpha: 0.6),
  );

  static TextStyle get emptyStateTitleStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.emptyStateText,
  );

  static TextStyle get emptyStateSubtitleStyle => TextStyle(
    fontSize: 14,
    color: AppColors.emptyStateText.withValues(alpha: 0.7),
  );

  static TextStyle emptyStateLandscapeTitleStyle(bool isLandscape) => TextStyle(
    fontSize: isLandscape ? 14 : 16,
    fontWeight: FontWeight.w600,
    color: AppColors.emptyStateText,
  );

  static TextStyle emptyStateLandscapeSubtitleStyle(bool isLandscape) =>
      TextStyle(
        fontSize: isLandscape ? 12 : 14,
        color: AppColors.emptyStateText.withValues(alpha: 0.7),
      );

  static TextStyle gameItemTitleStyle(bool isLandscape) => TextStyle(
    fontSize: isLandscape ? 13 : 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle gameItemPlatformStyle(bool isLandscape) => TextStyle(
    fontSize: isLandscape ? 11 : 12,
    color: AppColors.primaryText.withValues(alpha: 0.6),
  );

  static const TextStyle chartTitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle legendItemStyle = TextStyle(
    fontSize: legendFontSize,
    color: AppColors.primaryText,
  );

  static const TextStyle segmentedControlTextStyle = TextStyle(
    fontSize: segmentedControlFontSize,
    fontWeight: FontWeight.w500,
  );

  // Container decorations
  static BoxDecoration get sectionDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.circular(sectionBorderRadius),
    boxShadow: AppShadows.cardElevation,
    border: Border.all(color: AppColors.divider, width: 1),
  );

  static BoxDecoration get gameItemDecoration => BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(gameItemBorderRadius),
    border: Border.all(
      color: AppColors.divider.withValues(alpha: 0.5),
      width: 1,
    ),
  );

  static BoxDecoration get profileAvatarDecoration => BoxDecoration(
    shape: BoxShape.circle,
    gradient: AppGradients.cardBorderGradient,
  );

  static BoxDecoration get segmentedControlDecoration => BoxDecoration(
    color: AppColors.collapsibleSection,
    borderRadius: BorderRadius.circular(segmentedControlBorderRadius),
  );

  static BoxDecoration get gameStatusIndicatorDecoration => const BoxDecoration(
    color: AppColors.primaryPurple,
    shape: BoxShape.circle,
  );

  static BoxDecoration legendIndicatorDecoration(Color color) =>
      BoxDecoration(color: color, shape: BoxShape.circle);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF8B5CF6), // Primary purple
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF06B6D4), // Cyan
    Color(0xFFF97316), // Orange
    Color(0xFF84CC16), // Lime
    Color(0xFFEC4899), // Pink
    Color(0xFF6366F1), // Indigo
  ];

  // Status colors mapping
  static const Map<String, Color> statusColors = {
    'Playing': Color(0xFF10B981),
    'Completed': Color(0xFF8B5CF6),
    'Backlog': Color(0xFFF59E0B),
    'Abandoned': Color(0xFFEF4444),
    'Wishlist': Color(0xFF3B82F6),
    'Ordered': Color(0xFF06B6D4),
    'Ongoing': Color(0xFF06B6D4),
    'In Collection': Color(0xFF64748B),
  };

  // Responsive helpers
  static double getChartHeight(bool isLandscape) =>
      isLandscape ? chartLandscapeHeight : chartPortraitHeight;

  static double getChartRadius(bool isLandscape) =>
      isLandscape ? chartLandscapeRadius : chartPortraitRadius;

  static double getChartCenterSpace(bool isLandscape) =>
      isLandscape ? chartLandscapeCenterSpace : chartPortraitCenterSpace;

  static double getEmptyStateHeight(bool isLandscape) =>
      isLandscape ? emptyStateLandscapeHeight : emptyStatePortraitHeight;

  static double getEmptyStateIconSize(bool isLandscape) =>
      isLandscape ? emptyStateLandscapeIconSize : emptyStateIconSize;

  static double getSubscriptionHeight(bool isLandscape) =>
      isLandscape ? subscriptionLandscapeHeight : subscriptionPortraitHeight;

  static double getSectionSpacing(bool isLandscape) =>
      isLandscape ? landscapeSectionSpacing : portraitSectionSpacing;

  static double getGameItemSpacing(bool isLandscape) =>
      isLandscape ? gameItemLandscapeSpacing : gameItemSpacing;

  static double getGameItemPadding(bool isLandscape) =>
      isLandscape ? gameItemLandscapePadding : gameItemPadding;
}
