import 'package:flutter/material.dart';

class UIUtils {
  /// Calculate grid columns based on screen width
  static int calculateGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 5;
    if (screenWidth > 700) return 4;
    return 3;
  }
}
