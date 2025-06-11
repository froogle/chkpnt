import 'package:flutter/material.dart';

class UIUtils {
  /// Calculate grid columns based on screen width and orientation
  static int calculateGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // In landscape, prioritize showing more games
      if (screenWidth > 1000) return 7; // Large tablets/desktops
      if (screenWidth > 800) return 6; // Medium tablets
      if (screenWidth > 600) return 5; // Small tablets/large phones
      return 4; // Minimum for landscape
    } else {
      // Portrait mode - keep it simple and readable
      if (screenWidth > 500) return 3; // Large phones/tablets
      return 2; // Smaller phones
    }
  }
}
