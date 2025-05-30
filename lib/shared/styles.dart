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

// Splash Screen Styles
class SplashScreenStyles {
  static const Color backgroundColor = Color(0xFFD2691E);
  static const Duration splashDuration = Duration(seconds: 2);
  static const double logoSizeRatio = 0.8;
}

// Main Screen Styles
class MainScreenStyles {
  // Colors and backgrounds
  static const Color backgroundColor = Color(0xFFFFF8F2);
  static const Color sidebarColor = Color(0xFFF5E8DA);
  static const Color dividerColor = Color(0xFF9D8463);
  static const Color collapsibleSectionColor = Color(
    0xFFF8F1E8,
  ); // Slightly darker than main background
  static const Color collapsibleSectionHeaderColor = Color(
    0xFFEFE6D9,
  ); // Even slightly darker for header

  // Layout dimensions
  static const double sidebarWidth = 160.0;
  static const double bottomNavHeight = 48.0;
  static const double gameImageSize = 80.0;
  static const double landscapeGameImageSize = 48.0;
  static const double progressBarWidth = 80.0;
  static const double progressBarHeight = 8.0;
  static const double dividerHeight = 1.0;

  // New compact dimensions for portrait
  static const double compactSearchHeight = 44.0;
  static const double compactFilterHeight = 32.0;
  static const double compactFilterWidth = 60.0;
  static const double collapsibleFilterHeight = 36.0;

  // New landscape layout dimensions
  static const double landscapeCategoryTabHeight = 56.0;
  static const double landscapeGameCardAspectRatio = 1.2;
  static const double landscapeGridSpacing = 12.0;

  // Spacing constants
  static const EdgeInsets headerPadding = EdgeInsets.all(20.0);
  static const EdgeInsets filterPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets gameCardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets gameCardSpacing = EdgeInsets.only(bottom: 12.0);
  static const EdgeInsets filterButtonPadding = EdgeInsets.symmetric(
    horizontal: 4.0,
  );
  // New compact filter button padding
  static const EdgeInsets compactFilterButtonPadding = EdgeInsets.symmetric(
    horizontal: 6.0,
  );
  static const EdgeInsets landscapeGameCardPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
  );
  static const EdgeInsets landscapeGameCardContentPadding = EdgeInsets.all(
    12.0,
  );

  // New landscape layout padding
  static const EdgeInsets landscapeHeaderPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 12.0,
  );
  static const EdgeInsets landscapeGridPadding = EdgeInsets.all(16.0);

  static const EdgeInsets sidebarHeaderPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarContentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets sidebarFilterPadding = EdgeInsets.only(bottom: 6.0);
  static const EdgeInsets sidebarNavPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarNavItemPadding = EdgeInsets.only(bottom: 8.0);

  static const double filterSpacing = 12.0;
  static const double sectionSpacing = 24.0;
  static const double sectionTitleSpacing = 12.0;
  static const double gameCardContentSpacing = 16.0;
  static const double gameCardVerticalSpacing = 8.0;
  static const double landscapeSectionSpacing = 24.0;
  static const double landscapeGameSpacing = 12.0;
  static const double landscapeGameContentSpacing = 12.0;
  static const double dividerSpacing = 8.0;

  // Text styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
    letterSpacing: 1.5,
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
  );

  static const TextStyle landscapeSectionHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
    letterSpacing: 1.2,
  );

  static const TextStyle gameTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
  );

  static const TextStyle landscapeGameTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
  );

  static const TextStyle gamePlatformStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF9D8463),
  );

  static const TextStyle landscapeGamePlatformStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF9D8463),
  );

  static const TextStyle gameStatusStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF674C3C),
    fontStyle: FontStyle.italic,
  );

  static const TextStyle sidebarNavTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF3B2E29),
  );

  // New landscape text styles
  static const TextStyle selectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle unselectedCategoryTabTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF9D8463),
    letterSpacing: 0.5,
  );

  static const TextStyle landscapeGameProgressStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF674C3C),
    fontWeight: FontWeight.w500,
  );

  static const TextStyle landscapeGameStatusStyle = TextStyle(
    fontSize: 11,
    color: Color(0xFF674C3C),
    fontStyle: FontStyle.italic,
  );

  static const TextStyle emptyStateTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF9D8463),
    fontWeight: FontWeight.w500,
  );

  // Decorations
  static const BoxDecoration searchBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(32)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE0E0E0), width: 2),
    ),
  );

  // Compact search bar decoration
  static const BoxDecoration compactSearchBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(22)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE0E0E0), width: 1),
    ),
  );

  static const BoxDecoration gameCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration landscapeGameCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 1)),
    ],
  );

  static const BoxDecoration gameImageDecoration = BoxDecoration(
    color: Color(0xFFF0F0F0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration progressBarDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  static const BoxDecoration addButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration playButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration startButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration menuButtonDecoration = BoxDecoration(
    color: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  static const BoxDecoration bottomNavDecoration = BoxDecoration(
    color: Color(0xFF3B2E29),
    border: Border(top: BorderSide(color: Color(0xFF9D8463), width: 2)),
    boxShadow: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2)),
    ],
  );

  // New landscape decorations
  static const BoxDecoration landscapeHeaderDecoration = BoxDecoration(
    color: Color(0xFF924942),
    boxShadow: [
      BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration landscapeCategoryTabDecoration = BoxDecoration(
    color: Color(0xFFF5E8DA),
    border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
  );

  static const BoxDecoration selectedCategoryTabDecoration = BoxDecoration(
    color: Color(0xFFCC7E54),
    border: Border(bottom: BorderSide(color: Color(0xFFCC7E54), width: 3)),
  );

  static const BoxDecoration unselectedCategoryTabDecoration = BoxDecoration(
    color: Colors.transparent,
    border: Border(bottom: BorderSide(color: Colors.transparent, width: 3)),
  );

  // Collapsible section decorations
  static const BoxDecoration collapsibleSectionDecoration = BoxDecoration(
    color: collapsibleSectionColor,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000), // More prominent shadow
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
    color: collapsibleSectionHeaderColor,
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

  static const BoxDecoration collapsibleFilterDropdownDecoration =
      BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  // Input decoration
  static const InputDecoration searchInputDecoration = InputDecoration(
    hintText: 'Search',
    prefixIcon: Icon(Icons.search, color: Color(0xFF9D8463)),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Compact search input decoration
  static const InputDecoration compactSearchInputDecoration = InputDecoration(
    hintText: 'Search',
    prefixIcon: Icon(Icons.search, color: Color(0xFF9D8463), size: 20),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  );

  // Button styles
  static ButtonStyle get selectedFilterButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFCC7E54),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
  );

  static ButtonStyle get unselectedFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3B2E29),
        elevation: 1,
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      );

  // Compact filter button styles
  static ButtonStyle get selectedCompactFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCC7E54),
        foregroundColor: Colors.white,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        minimumSize: const Size(compactFilterWidth, compactFilterHeight),
      );

  static ButtonStyle get unselectedCompactFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3B2E29),
        elevation: 0,
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        minimumSize: const Size(compactFilterWidth, compactFilterHeight),
      );

  static ButtonStyle get addButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF924942),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static ButtonStyle get playButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFCC7E54),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  static ButtonStyle get startButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFCC7E54),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  // Collapsible section header styles
  static const TextStyle collapsibleSectionHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3B2E29),
  );
}
