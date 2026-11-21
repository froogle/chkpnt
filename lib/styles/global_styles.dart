import 'package:flutter/material.dart';

/// Standardized heading style with gradient - used for section titles throughout the app
class AppHeadingStyles {
  /// Creates a gradient heading widget with consistent styling
  static Widget gradientHeading(String text, {double fontSize = 14.0}) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.black, AppColors.primaryPurple, Colors.black],
        stops: [0.2, 0.5, 0.8],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white, // This will be masked by the gradient
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  /// Standard section heading style
  static const TextStyle sectionHeading = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: 0.3,
  );
}

/// Global colour palette - Modern purple gradient scheme
class AppColors {
  // Primary purple colours
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color secondaryPurple = Color(0xFFA855F7);
  static const Color lightPurple = Color(0xFF7C3AED);
  static const Color purpleAccent = Color(0xFF6366F1);

  // Primary colours (keeping compatibility)
  static const Color primaryAccent = primaryPurple;
  static const Color primaryAccentTransparent = Color(0x1A8B5CF6);
  static const Color primaryText = Color(0xFF1E293B);
  static const Color secondaryButton = Color(0xFF7C3AED);

  // Background colours - Light theme
  static const Color background = Color(0xFFF8FAFC);
  static const Color sidebar = Color(0xFFFFFFFF);
  static const Color collapsibleSection = Color(0xFFF1F5F9);
  static const Color collapsibleSectionHeader = Color(0xFFE2E8F0);

  // Dark theme backgrounds
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSidebar = Color(0xFF1E293B);
  static const Color darkCollapsibleSection = Color(0xFF334155);

  // Utility colours
  static const Color divider = Color(0xFFE2E8F0);
  static const Color expandIcon = Color(0xFF64748B);
  static const Color subtleShadow = Color(0x1A000000);

  // Empty state colours
  static const Color emptyStateBackground = Color(0xFFF8FAFC);
  static const Color emptyStateIcon = Color(0xFF94A3B8);
  static const Color emptyStateText = Color(0xFF64748B);

  // Gradient colours
  static const Color gradientStart = Color(0xFF8B5CF6);
  static const Color gradientMiddle = Color(0xFFA855F7);
  static const Color gradientEnd = Color(0xFF6366F1);
}

/// Global gradient definitions matching the target design
class AppGradients {
  // Main background gradient (subtle)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
    stops: [0.0, 0.5, 1.0],
  );

  // Card border gradient
  static const LinearGradient cardBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7), Color(0xFF6366F1)],
    stops: [0.0, 0.5, 1.0],
  );

  // Button gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  );

  // Subtle card background gradient
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFFAFAFA)],
  );

  // Dark theme gradients
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
  );
}

/// Global shadow definitions
class AppShadows {
  static const List<Shadow> gameCardText = [
    Shadow(blurRadius: 6, color: Colors.black87, offset: Offset(1, 1)),
  ];

  // Modern elevated shadows
  static const List<BoxShadow> cardElevation = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> subtleElevation = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // Enhanced gradient border shadow effect for more prominence
  static const List<BoxShadow> gradientBorderShadow = [
    BoxShadow(
      color: Color(0x308B5CF6), // Increased opacity from 0x20 to 0x30
      blurRadius: 12, // Increased blur for more spread
      offset: Offset(0, 3), // Slightly larger offset
      spreadRadius: 1, // Added spread for more prominence
    ),
    // Additional subtle inner glow effect
    BoxShadow(
      color: Color(0x1A8B5CF6),
      blurRadius: 6,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
}

/// Global layout and container styles
class AppLayout {
  // ========================================
  // Sheet/Modal Styles (Standardized)
  // ========================================

  /// Standard content padding for sheets and modals
  static const EdgeInsets sheetContentPadding = EdgeInsets.fromLTRB(
    24,
    20,
    20,
    28,
  );

  /// Standard spacing values for sheets
  static const double sheetSectionSpacing = 24.0;
  static const double sheetHeaderSpacing = 12.0;

  /// Modern sheet decoration with gradient and border
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

  /// Close button decoration for sheets and modals
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
  static const double closeButtonTopMargin = 6.0;
  static const double closeButtonRightMargin = 12.0;

  // ========================================
  // Image Container Styles (Standardized)
  // ========================================

  /// Standard game image dimensions
  static const double gameImageHeight = 120.0;
  static const double gameImageWidth = 140.0;
  static const double gameImageIconSize = 48.0;
  static const BorderRadius gameImageBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );

  /// Game image container decoration
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

  // ========================================
  // Badge Styles (Standardized)
  // ========================================

  /// Platform badge styling
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

  // ========================================
  // Typography Styles (Standardized)
  // ========================================

  /// Standard title styles for detail views
  static const TextStyle detailTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    letterSpacing: 0.4,
  );

  static const TextStyle detailSubtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.expandIcon,
    letterSpacing: 0.2,
  );

  static const TextStyle detailSectionTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
    letterSpacing: 0.3,
  );

  // ========================================
  // Button Text Styles (Standardized)
  // ========================================

  /// Standard action button text styles
  static const TextStyle actionButtonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle actionButtonDisabledTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.expandIcon,
  );

  /// Action button icon size
  static const double actionButtonIconSize = 16.0;
  static const double actionButtonIconSpacing = 6.0;
}
