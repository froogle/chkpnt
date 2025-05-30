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

  // Text styles for layout elements
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: 1.5,
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle landscapeSectionHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: 1.2,
  );

  static const TextStyle sidebarNavTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.primaryText,
  );

  // Category tab text styles
  static const TextStyle selectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle unselectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.divider,
    letterSpacing: 0.5,
  );

  // Bottom navigation decoration
  static const BoxDecoration bottomNavDecoration = BoxDecoration(
    color: AppColors.primaryText,
    border: Border(top: BorderSide(color: AppColors.divider, width: 2)),
    boxShadow: [
      BoxShadow(
        color: AppColors.subtleShadow,
        blurRadius: 8,
        offset: Offset(0, -2),
      ),
    ],
  );

  // Landscape header and tab decorations
  static const BoxDecoration landscapeHeaderDecoration = BoxDecoration(
    color: AppColors.secondaryButton,
    boxShadow: [
      BoxShadow(
        color: AppColors.subtleShadow,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const BoxDecoration landscapeCategoryTabDecoration = BoxDecoration(
    color: AppColors.sidebar,
    border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
  );

  static const BoxDecoration selectedCategoryTabDecoration = BoxDecoration(
    color: AppColors.primaryAccent,
    border: Border(
      bottom: BorderSide(color: AppColors.primaryAccent, width: 3),
    ),
  );

  static const BoxDecoration unselectedCategoryTabDecoration = BoxDecoration(
    color: Colors.transparent,
    border: Border(bottom: BorderSide(color: Colors.transparent, width: 3)),
  );
}

/// Styles for collapsible sections
class CollapsibleSectionStyles {
  // Spacing and padding
  static const EdgeInsets collapsibleSectionMargin = EdgeInsets.only(
    bottom: 16,
  );
  static const EdgeInsets collapsibleSectionHeaderPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets collapsibleSectionContentPadding = EdgeInsets.all(16);

  // Section decorations
  static const BoxDecoration collapsibleSectionDecoration = BoxDecoration(
    color: AppColors.collapsibleSection,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: AppColors.subtleShadow, // More prominent shadow
        blurRadius: 12,
        spreadRadius: 2,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Color(0x0F000000), // Subtle secondary shadow for depth
        blurRadius: 6,
        spreadRadius: 0,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const BoxDecoration collapsibleSectionHeaderDecoration = BoxDecoration(
    color: AppColors.collapsibleSectionHeader,
    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    border: Border(bottom: BorderSide(color: Color(0xFFE0D5C7), width: 1)),
    boxShadow: [
      BoxShadow(
        color: Color(0x08000000), // Subtle shadow for header depth
        blurRadius: 4,
        offset: Offset(0, 1),
      ),
    ],
  );

  // Header text style
  static const TextStyle collapsibleSectionHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
}

/// Styles for empty states
class EmptyStateStyles {
  static const BoxDecoration emptyStateDecoration = BoxDecoration(
    color: AppColors.emptyStateBackground,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE0E0E0), width: 1),
    ),
  );

  static const double emptyStateHeight = 120.0;
  static const double emptyStateIconSize = 32.0;
  static const double emptyStateSpacing = 8.0;

  static const TextStyle emptyStateTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.emptyStateText,
    fontWeight: FontWeight.w500,
  );
}
