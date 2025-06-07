import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styles for main screen layout and sections
class LayoutStyles {
  // Layout dimensions
  static const double sidebarWidth = 160.0;
  static const double bottomNavHeight = 48.0;
  static const double dividerHeight = 1.0;

  // Header and content padding
  static const EdgeInsets headerPadding = EdgeInsets.all(20.0);
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets sidebarHeaderPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarContentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets sidebarNavPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarNavItemPadding = EdgeInsets.only(bottom: 8.0);

  // Landscape layout dimensions
  static const double landscapeCategoryTabHeight = 56.0;
  static const double landscapeGridSpacing = 12.0;
  static const EdgeInsets landscapeHeaderPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 12.0,
  );
  static const EdgeInsets landscapeGridPadding = EdgeInsets.all(16.0);

  // Spacing constants
  static const double filterSpacing = 12.0;
  static const double sectionSpacing = 24.0;
  static const double sectionTitleSpacing = 12.0;
  static const double landscapeSectionSpacing = 24.0;
  static const double landscapeGameSpacing = 12.0;
  static const double landscapeGameContentSpacing = 12.0;
  static const double dividerSpacing = 8.0;

  // Enhanced text styles for layout elements
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: 1.5,
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: 0.5,
  );

  static const TextStyle landscapeSectionHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: 0.8,
  );

  static const TextStyle sidebarNavTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  // Enhanced category tab text styles
  static const TextStyle selectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle unselectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.expandIcon,
    letterSpacing: 0.5,
  );

  // Modern bottom navigation decoration
  static BoxDecoration get bottomNavDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    border: Border(
      top: BorderSide(
        color: AppColors.primaryPurple.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        blurRadius: 12,
        offset: Offset(0, -4),
        spreadRadius: 0,
      ),
    ],
  );

  // Enhanced landscape header and tab decorations
  static BoxDecoration get landscapeHeaderDecoration => BoxDecoration(
    gradient: AppGradients.buttonGradient,
    boxShadow: AppShadows.subtleElevation,
  );

  static BoxDecoration get landscapeCategoryTabDecoration => BoxDecoration(
    color: AppColors.sidebar,
    border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
  );

  static BoxDecoration get selectedCategoryTabDecoration => BoxDecoration(
    gradient: AppGradients.buttonGradient,
    border: Border(
      bottom: BorderSide(color: AppColors.primaryPurple, width: 3),
    ),
  );

  static const BoxDecoration unselectedCategoryTabDecoration = BoxDecoration(
    color: Colors.transparent,
    border: Border(bottom: BorderSide(color: Colors.transparent, width: 3)),
  );
}

/// Enhanced styles for collapsible sections
class CollapsibleSectionStyles {
  // Spacing and padding
  static const EdgeInsets collapsibleSectionMargin = EdgeInsets.only(
    bottom: 20,
  );
  static const EdgeInsets collapsibleSectionHeaderPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets collapsibleSectionContentPadding = EdgeInsets.all(20);

  // Modern section decorations with dramatic shadows for prominence
  static BoxDecoration get collapsibleSectionDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [
      // Primary dramatic shadow for depth
      BoxShadow(
        color: Color(0x25000000), // Much stronger shadow
        blurRadius: 24, // Significantly increased blur
        offset: Offset(0, 8), // Larger offset for more separation
        spreadRadius: 2, // Added spread for more prominence
      ),
      // Secondary shadow for enhanced depth
      BoxShadow(
        color: Color(0x15000000),
        blurRadius: 16,
        offset: Offset(0, 4),
        spreadRadius: 0,
      ),
      // Purple accent shadow for brand consistency
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: Offset(0, 6),
        spreadRadius: 1,
      ),
      // Subtle inner definition
      BoxShadow(
        color: Color(0x08000000),
        blurRadius: 4,
        offset: Offset(0, 1),
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration get collapsibleSectionHeaderDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.collapsibleSectionHeader,
        AppColors.collapsibleSectionHeader.withValues(alpha: 0.8),
      ],
    ),
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    border: Border(
      bottom: BorderSide(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    boxShadow: [
      // Enhanced header shadow for definition
      BoxShadow(
        color: Color(0x12000000),
        blurRadius: 8,
        offset: Offset(0, 2),
        spreadRadius: 0,
      ),
      // Subtle purple accent for consistency
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        blurRadius: 6,
        offset: Offset(0, 1),
        spreadRadius: 0,
      ),
    ],
  );

  // Enhanced header text style
  static const TextStyle collapsibleSectionHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
    letterSpacing: 0.5,
  );
}

/// Enhanced styles for empty states
class EmptyStateStyles {
  static BoxDecoration get emptyStateDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.1),
      width: 1,
    ),
    boxShadow: AppShadows.subtleElevation,
  );

  static const double emptyStateHeight = 140.0;
  static const double emptyStateIconSize = 36.0;
  static const double emptyStateSpacing = 12.0;

  static const TextStyle emptyStateTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.emptyStateText,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}
