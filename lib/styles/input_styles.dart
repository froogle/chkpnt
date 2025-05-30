import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styles for input components and interactive elements
class InputStyles {
  // Search bar dimensions
  static const double compactSearchHeight = 44.0;
  static const double compactFilterHeight = 32.0;
  static const double compactFilterWidth = 60.0;
  static const double collapsibleFilterHeight = 36.0;

  // Search bar decorations
  static const BoxDecoration searchBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(32)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE0E0E0), width: 2),
    ),
  );

  static const BoxDecoration compactSearchBarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(22)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE0E0E0), width: 1),
    ),
  );

  // Input decorations
  static const InputDecoration searchInputDecoration = InputDecoration(
    hintText: 'Search',
    prefixIcon: Icon(Icons.search, color: AppColors.divider),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static const InputDecoration compactSearchInputDecoration = InputDecoration(
    hintText: 'Search',
    prefixIcon: Icon(Icons.search, color: AppColors.divider, size: 20),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  );

  // Filter button padding
  static const EdgeInsets filterButtonPadding = EdgeInsets.symmetric(
    horizontal: 4.0,
  );
  static const EdgeInsets compactFilterButtonPadding = EdgeInsets.symmetric(
    horizontal: 6.0,
  );

  // Button styles
  static ButtonStyle get selectedFilterButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryAccent,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
  );

  static ButtonStyle get unselectedFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 1,
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      );

  static ButtonStyle get selectedCompactFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
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
        foregroundColor: AppColors.primaryText,
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
    backgroundColor: AppColors.secondaryButton,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static ButtonStyle get playButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryAccent,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  static ButtonStyle get startButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryAccent,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  // Additional button padding
  static const EdgeInsets addButtonSmallPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
}

/// Styles for dropdown components
class DropdownStyles {
  // Filter dropdown decorations
  static const BoxDecoration collapsibleFilterDropdownDecoration =
      BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(22)),
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.subtleShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  // Dropdown item padding and styling
  static const EdgeInsets filterDropdownItemPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 4,
  );
  static const EdgeInsets filterDropdownButtonPadding = EdgeInsets.symmetric(
    horizontal: 16,
  );

  // Dropdown text styles
  static const TextStyle filterDropdownSelectedTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryAccent,
  );

  static const TextStyle filterDropdownUnselectedTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
  );

  static const TextStyle filterButtonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Filter dropdown item decoration for selected state
  static const BoxDecoration filterDropdownSelectedItemDecoration =
      BoxDecoration(
        color: AppColors.primaryAccentTransparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      );
}
