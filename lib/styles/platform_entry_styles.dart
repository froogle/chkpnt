import 'package:flutter/material.dart';

/// Centralised styling for platform entry screen components
///
/// This module provides consistent styling for:
/// - Screen layout and structure
/// - Form inputs and controls
/// - Action buttons and navigation
/// - Typography and spacing
class PlatformEntryStyles {
  // Screen Layout
  static const Color backgroundColor = Colors.white;
  static const EdgeInsets screenPadding = EdgeInsets.all(20);

  // App Bar Styling
  static const Color appBarBackgroundColor = Colors.white;
  static const double appBarElevation = 0;
  static const Color appBarSurfaceTintColor = Colors.transparent;

  // App Bar Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // App Bar Button Styles
  static const Color appBarIconColor = Colors.black87;
  static const Color saveButtonActiveColor = Colors.blue;
  static const Color saveButtonInactiveColor = Colors.grey;
  static const TextStyle saveButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Form Field Styling
  static const TextStyle fieldLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const double fieldLabelSpacing = 12;

  // Text Input Styling
  static const TextStyle textInputStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const String inputHintText = 'e.g., Nintendo Switch, PS5, PC';
  static const Color inputFillColor = Color(0xFFF9F9F9); // Colors.grey[50]
  static const Color inputBorderColor = Color(0xFFE0E0E0); // Colors.grey[300]
  static const Color inputFocusedBorderColor = Colors.blue;
  static const double inputBorderRadius = 12;
  static const double inputBorderWidth = 1;
  static const double inputFocusedBorderWidth = 2;

  static const EdgeInsets inputContentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  // Input Decoration
  static InputDecoration get textInputDecoration => InputDecoration(
    hintText: inputHintText,
    filled: true,
    fillColor: inputFillColor,
    border: _inputBorder,
    enabledBorder: _inputBorder,
    focusedBorder: _inputFocusedBorder,
    contentPadding: inputContentPadding,
  );

  static OutlineInputBorder get _inputBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(inputBorderRadius),
    borderSide: const BorderSide(
      color: inputBorderColor,
      width: inputBorderWidth,
    ),
  );

  static OutlineInputBorder get _inputFocusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(inputBorderRadius),
    borderSide: const BorderSide(
      color: inputFocusedBorderColor,
      width: inputFocusedBorderWidth,
    ),
  );

  // Help Text Styling
  static const double helpTextSpacing = 16;
  static const TextStyle helpTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF757575), // Colors.grey[600]
  );

  static const String helpText =
      'The platform name will be automatically abbreviated if it matches a common platform.';

  // Primary Action Button Styling
  static const EdgeInsets primaryButtonPadding = EdgeInsets.symmetric(
    vertical: 16,
  );
  static const double primaryButtonBorderRadius = 12;
  static const double primaryButtonElevation = 2;
  static const double primaryButtonDisabledElevation = 0;

  static const Color primaryButtonActiveBackgroundColor = Colors.blue;
  static const Color primaryButtonActiveTextColor = Colors.white;
  static const Color primaryButtonInactiveBackgroundColor = Color(
    0xFFE0E0E0,
  ); // Colors.grey[300]
  static const Color primaryButtonInactiveTextColor = Color(
    0xFF9E9E9E,
  ); // Colors.grey[500]

  static const TextStyle primaryButtonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const String primaryButtonText = 'Add Platform';

  // Button Style Methods
  static ButtonStyle primaryButtonStyle(bool isActive) =>
      ElevatedButton.styleFrom(
        backgroundColor:
            isActive
                ? primaryButtonActiveBackgroundColor
                : primaryButtonInactiveBackgroundColor,
        foregroundColor:
            isActive
                ? primaryButtonActiveTextColor
                : primaryButtonInactiveTextColor,
        padding: primaryButtonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(primaryButtonBorderRadius),
        ),
        elevation:
            isActive ? primaryButtonElevation : primaryButtonDisabledElevation,
      );

  static TextStyle saveButtonTextStyleWithColor(bool isActive) =>
      saveButtonTextStyle.copyWith(
        color: isActive ? saveButtonActiveColor : saveButtonInactiveColor,
      );
}
