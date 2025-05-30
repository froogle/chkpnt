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
