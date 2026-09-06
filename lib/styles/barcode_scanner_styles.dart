import 'package:flutter/material.dart';

class BarcodeScannerStyles {
  static const Color backgroundColour = Colors.black;
  static const Color appBarBackgroundColour = Colors.black;
  static const Color appBarIconColour = Colors.white;

  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle instructionTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const EdgeInsets instructionPadding = EdgeInsets.all(20);
  static const EdgeInsets instructionMargin = EdgeInsets.all(24);
  static const double instructionBorderRadius = 12;

  static const Color instructionBackgroundColour = Color(0xCC000000);

  static BoxDecoration get instructionDecoration => BoxDecoration(
    color: instructionBackgroundColour,
    borderRadius: BorderRadius.circular(instructionBorderRadius),
  );
}
