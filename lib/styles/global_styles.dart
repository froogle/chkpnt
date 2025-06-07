import 'package:flutter/material.dart';

/// Global text styles used across multiple components
TextStyle get onboardingWelcomeTextStyle => TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Color(0xFF1E293B),
  shadows: const [
    Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(2, 2)),
  ],
);

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

  static const List<Shadow> gameCardPortraitText = [
    Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(1, 1)),
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
