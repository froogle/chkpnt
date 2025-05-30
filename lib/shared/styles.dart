import 'package:flutter/material.dart';

final ThemeData retroBacklogTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFCC7E54), // From Image 2 (pleasant, warm orange)
  scaffoldBackgroundColor: Color(0xFFFFF8F2), // Light neutral for readability
  canvasColor: Color(0xFFF5E8DA), // Soft complementary background

  colorScheme: ColorScheme(
    primary: Color(0xFFCC7E54),
    secondary: Color(0xFFC04F4A),
    surface: Color(0xFFD9B56B),
    error: Color(0xFFB00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF3B2E29),
    onError: Colors.white,
    brightness: Brightness.light,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF674C3C),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3B2E29),
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF4B3E3B)),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFFCC7E54),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF924942),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  cardColor: Color(0xFFF5E8DA),
  dividerColor: Color(0xFF9D8463),
);

final ThemeData retroBacklogDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFCC7E54),
  scaffoldBackgroundColor: Color(0xFF2C1F1A),
  canvasColor: Color(0xFF3B2E29),

  colorScheme: ColorScheme(
    primary: Color(0xFFCC7E54),
    secondary: Color(0xFFC04F4A),
    surface: Color(0xFF4B3E3B),
    error: Color(0xFFEF5350),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF674C3C),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFDFB268)),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFFCC7E54),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF924942),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  cardColor: Color(0xFF46332E),
  dividerColor: Color(0xFF9D8463),
);

TextStyle get onboardingWelcomeTextStyle => TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Color(0xFF3B2E29),
  shadows: const [
    Shadow(blurRadius: 8, color: Colors.black26, offset: Offset(2, 2)),
  ],
);

// Onboarding Subscription Overlay Styles
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

  // Text styles for subscription tiles
  static const TextStyle tileTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const double landscapeSpacing = 4.0;
  static const double landscapeBottomSpacing = 8.0;

  // Subscribe button style
  static ButtonStyle subscribeButtonStyle = ElevatedButton.styleFrom(
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.25),
  );

  // Shared onboarding content styles
  static const double contentSpacing = 18.0;
  static const double startButtonHeight = 56.0;

  // Start button style (shared with subscribe button)
  static ButtonStyle get startButtonStyle => subscribeButtonStyle;
}
