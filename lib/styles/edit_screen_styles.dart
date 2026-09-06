import 'package:flutter/material.dart';
import 'global_styles.dart';

class EditScreenStyles {
  // Save button styles
  static ButtonStyle saveButtonStyle(bool hasChanges) {
    return ElevatedButton.styleFrom(
      backgroundColor: hasChanges ? Colors.blue : Colors.grey[300],
      foregroundColor: hasChanges ? Colors.white : Colors.grey[500],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: hasChanges ? 2 : 0,
    );
  }

  static Color saveButtonIconColour(bool hasChanges) {
    return hasChanges ? Colors.white : Colors.grey[500]!;
  }

  static TextStyle saveButtonTextStyle(bool hasChanges) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: hasChanges ? Colors.white : Colors.grey[500],
    );
  }

  // Save button layout
  static const double saveButtonIconSize = 20.0;
  static const double saveButtonIconSpacing = 8.0;

  // Title field styles - Mobile-optimised for smaller, cleaner appearance
  static InputDecoration get titleFieldDecoration => InputDecoration(
    filled: true,
    fillColor: Colors.grey[50], // Lighter, more subtle background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    ),
    hintText: 'Enter game title',
    hintStyle: titleFieldHintStyle,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ), // Reduced padding for compact appearance
    isDense: true, // Enables more compact field
  );

  // Mobile-appropriate text style for title field
  static const TextStyle titleFieldTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
    letterSpacing: 0.1,
  );

  static TextStyle get titleFieldHintStyle =>
      titleFieldTextStyle.copyWith(color: Colors.grey[500]);

  // Section spacing
  static const double sectionSpacing = 16.0;

  // Platform section layout constants
  static const CrossAxisAlignment platformSectionAlignment =
      CrossAxisAlignment.start;
  static const CrossAxisAlignment centeredPlatformAlignment =
      CrossAxisAlignment.center;

  // Platform dropdown styles
  static const EdgeInsets platformDropdownPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const double platformDropdownIconSize = 20.0;
  static const double platformDropdownSpacing = 12.0;
  static const double platformDropdownArrowSize = 24.0;
  static const double platformDropdownBorderRadius = 12.0;

  static BoxDecoration get platformDropdownDecoration => BoxDecoration(
    color: Colors.grey[50],
    borderRadius: BorderRadius.circular(platformDropdownBorderRadius),
    border: Border.all(color: Colors.grey[300]!, width: 1),
  );

  static const TextStyle platformDropdownTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const Color platformDropdownIconColour = Colors.blue;
  static const Color platformDropdownArrowColour = Colors.grey;

  // Bottom sheet styles
  static const double bottomSheetBorderRadius = 20.0;
  static const EdgeInsets bottomSheetPadding = EdgeInsets.only(
    top: 20,
    left: 20,
    right: 20,
  );
  static const double bottomSheetMaxHeightFactor = 0.8;

  static const BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(bottomSheetBorderRadius),
    ),
  );

  // Bottom sheet header styles
  static const TextStyle bottomSheetHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const Color bottomSheetCloseIconColour = Colors.grey;

  // Custom platform input styles
  static const TextStyle customPlatformLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const double customPlatformSpacing = 8.0;
  static const double customPlatformBorderRadius = 12.0;
  static const EdgeInsets customPlatformInputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets customPlatformButtonPadding = EdgeInsets.symmetric(
    vertical: 12,
  );

  static InputDecoration get customPlatformInputDecoration => InputDecoration(
    hintText: 'Enter platform name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(customPlatformBorderRadius),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(customPlatformBorderRadius),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    contentPadding: customPlatformInputPadding,
  );

  static ButtonStyle get customPlatformButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: customPlatformButtonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(customPlatformBorderRadius),
    ),
  );

  static const String customPlatformButtonText = 'Use Custom Platform';

  // Platform list styles
  static const TextStyle platformListLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const double platformListSpacing = 12.0;
  static const double platformListIconSize = 20.0;
  static const double platformListBorderRadius = 8.0;

  static Color platformListSelectedColour = Colors.blue.withValues(alpha: 0.1);
  static const Color platformListCheckColour = Colors.blue;

  static RoundedRectangleBorder get platformListTileShape =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(platformListBorderRadius),
      );

  // AppBar styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const Color appBarBackgroundColour = Colors.white;
  static const Color appBarIconColour = Colors.black87;

  // Layout spacing constants
  static const double horizontalSpacing = 24.0;
  static const double verticalSpacing = 16.0;
  static const double gameImageWidth = 120.0;

  static const Color scanBarcodeColour = AppColors.primaryPurple;
  static const double scanBarcodeIconSize = 16.0;

  static const TextStyle scanBarcodeTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: scanBarcodeColour,
  );

  static const EdgeInsets scanBarcodePadding = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 4,
  );

  static const Color lookupOverlayColour = Color(0xB3FFFFFF);

  static const Color scanMessageBackgroundColour = AppColors.darkSidebar;

  static const TextStyle scanMessageTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
}
