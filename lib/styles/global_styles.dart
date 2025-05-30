import 'package:flutter/material.dart';

/// Global text styles used across multiple components
TextStyle get onboardingWelcomeTextStyle => TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Color(0xFF3B2E29),
  shadows: const [
    Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(2, 2)),
  ],
);

/// Global colour palette
class AppColors {
  // Primary colours
  static const Color primaryAccent = Color(0xFFCC7E54);
  static const Color primaryAccentTransparent = Color(0x1ACC7E54);
  static const Color primaryText = Color(0xFF3B2E29);
  static const Color secondaryButton = Color(0xFF924942);

  // Background colours
  static const Color background = Color(0xFFFFF8F2);
  static const Color sidebar = Color(0xFFF5E8DA);
  static const Color collapsibleSection = Color(0xFFF8F1E8);
  static const Color collapsibleSectionHeader = Color(0xFFEFE6D9);

  // Utility colours
  static const Color divider = Color(0xFF9D8463);
  static const Color expandIcon = Color(0xFF674C3C);
  static const Color subtleShadow = Color(0x1A000000);

  // Empty state colours
  static const Color emptyStateBackground = Color(0xFFF5F5F5);
  static const Color emptyStateIcon = Color(0xFFBDBDBD);
  static const Color emptyStateText = Color(0xFF9D8463);
}

/// Global shadow definitions
class AppShadows {
  static const List<Shadow> gameCardText = [
    Shadow(blurRadius: 6, color: Colors.black87, offset: Offset(1, 1)),
  ];

  static const List<Shadow> gameCardPortraitText = [
    Shadow(blurRadius: 4, color: Colors.black87, offset: Offset(1, 1)),
  ];

  static const List<BoxShadow> cardElevation = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> subtleElevation = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
}
