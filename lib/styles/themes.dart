import 'package:flutter/material.dart';

final ThemeData retroBacklogTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF8B5CF6), // Purple primary
  scaffoldBackgroundColor: Color(0xFFF8FAFC), // Light neutral background
  canvasColor: Color(0xFFF1F5F9), // Subtle card background

  colorScheme: ColorScheme(
    primary: Color(0xFF8B5CF6), // Purple
    secondary: Color(0xFFA855F7), // Slightly different purple
    surface: Color(0xFFE2E8F0), // Light surface
    error: Color(0xFFEF4444), // Modern red
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF1E293B), // Dark text
    onError: Colors.white,
    brightness: Brightness.light,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF1E293B),
    elevation: 0,
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E293B),
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B),
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF334155),
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF8B5CF6),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 0,
    ),
  ),

  cardColor: Colors.white,
  dividerColor: Color(0xFFE2E8F0),
);

final ThemeData retroBacklogDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF8B5CF6),
  scaffoldBackgroundColor: Color(0xFF0F172A),
  canvasColor: Color(0xFF1E293B),

  colorScheme: ColorScheme(
    primary: Color(0xFF8B5CF6),
    secondary: Color(0xFFA855F7),
    surface: Color(0xFF334155),
    error: Color(0xFFEF4444),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF1F5F9),
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF8B5CF6),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      elevation: 0,
    ),
  ),

  cardColor: Color(0xFF1E293B),
  dividerColor: Color(0xFF334155),
);
