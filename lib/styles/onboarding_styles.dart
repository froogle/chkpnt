import 'package:flutter/material.dart';

/// Styles for splash screen
class SplashScreenStyles {
  static const Color backgroundColor = Color(0xFFD2691E);
  static const Duration splashDuration = Duration(seconds: 2);
  static const double logoSizeRatio = 0.8;
}

/// Styles for onboarding overlays and subscription screens
class OnboardingOverlayStyles {
  // Container decoration for the overlay
  static const BoxDecoration overlayDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xB3FFFFFF), Colors.white], // Colors.white.withAlpha(0xB3)
    ),
    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    boxShadow: [
      BoxShadow(
        color: Color(
          0x47000000,
        ), // Colors.black.withAlpha((0.28 * 255).toInt())
        blurRadius: 28,
        spreadRadius: 4,
        offset: Offset(0, -4),
      ),
    ],
  );

  // Padding and spacing constants
  static const EdgeInsets overlayPadding = EdgeInsets.symmetric(
    horizontal: 28,
    vertical: 24,
  );

  static const double titleSpacing = 18.0;
  static const double messageSpacing = 18.0;
  static const double buttonTopSpacing = 24.0;
  static const double subscribeButtonHeight = 56.0;
  static const double landscapeTileWidth = 180.0;
  static const EdgeInsets landscapeTileMargin = EdgeInsets.symmetric(
    horizontal: 8,
  );

  // Subscription tile styles
  static const double tileElevationSelected = 8.0;
  static const double tileElevationUnselected = 2.0;
  static const double tileBorderRadius = 16.0;
  static const double tileBorderWidth = 2.0;
  static const EdgeInsets tileMargin = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 12,
  );

  // Text styles for subscription tiles - Android 13 compatible
  static const TextStyle tileTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(
      0xFF1E293B,
    ), // Explicit dark color for Android 13 compatibility
    fontSize: 16,
  );
  static const double landscapeSpacing = 4.0;
  static const double landscapeBottomSpacing = 8.0;

  // Subscribe button style - Enhanced for Android 13 visibility
  static ButtonStyle subscribeButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF8B5CF6), // Explicit purple background
    foregroundColor: Colors.white, // Explicit white text
    disabledBackgroundColor: Color(0xFFE5E7EB), // Light grey when disabled
    disabledForegroundColor: Color(0xFF9CA3AF), // Dark grey text when disabled
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.25),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );

  // Shared onboarding content styles
  static const double contentSpacing = 18.0;
  static const double startButtonHeight = 56.0;

  // Start button style (shared with subscribe button)
  static ButtonStyle get startButtonStyle => subscribeButtonStyle;
}
