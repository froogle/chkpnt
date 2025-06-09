import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styles for input components and interactive elements
class InputStyles {
  // Search bar dimensions
  static const double compactSearchHeight = 48.0; // Slightly taller
  static const double compactFilterHeight = 36.0;
  static const double compactFilterWidth = 70.0; // Slightly wider
  static const double collapsibleFilterHeight = 40.0;

  // Modern search bar decorations with gradients
  static BoxDecoration get searchBarDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1.5,
    ),
    boxShadow: AppShadows.subtleElevation,
  );

  static BoxDecoration get compactSearchBarDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.15),
      width: 1,
    ),
    boxShadow: AppShadows.subtleElevation,
  );

  // Enhanced input decorations
  static InputDecoration get searchInputDecoration => InputDecoration(
    hintText: 'Search games...',
    hintStyle: TextStyle(
      color: AppColors.expandIcon,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Icon(
      Icons.search_rounded,
      color: AppColors.primaryPurple.withValues(alpha: 0.7),
      size: 22,
    ),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  );

  static InputDecoration get compactSearchInputDecoration => InputDecoration(
    hintText: 'Search...',
    hintStyle: TextStyle(
      color: AppColors.expandIcon,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Icon(
      Icons.search_rounded,
      color: AppColors.primaryPurple.withValues(alpha: 0.7),
      size: 20,
    ),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // ========================================
  // Status Button Styles (Standardized)
  // ========================================

  /// Dimensions and spacing for status buttons (used across the app)
  static const double statusButtonHeight = 36.0;
  static const double statusButtonIconSize = 16.0;
  static const double statusButtonSpacing = 10.0;
  static const double statusButtonVerticalSpacing = 4.0;
  static const double statusButtonFontSize = 10.0;
  static const BorderRadius statusButtonBorderRadius = BorderRadius.all(
    Radius.circular(18), // Pill-like appearance
  );
  static const EdgeInsets statusButtonContentPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 6,
  );

  /// Status button decoration - works for both selected and unselected states
  static BoxDecoration statusButtonDecoration(bool isSelected) => BoxDecoration(
    gradient:
        isSelected
            ? LinearGradient(
              colors: [
                AppColors.primaryPurple.withValues(alpha: 0.15),
                AppColors.secondaryPurple.withValues(alpha: 0.1),
              ],
            )
            : AppGradients.cardGradient,
    borderRadius: statusButtonBorderRadius,
    border: Border.all(
      color:
          isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.4)
              : AppColors.primaryPurple.withValues(alpha: 0.2),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: isSelected ? AppShadows.subtleElevation : null,
  );

  /// Status button text style - adapts based on selection state
  static TextStyle statusButtonTextStyle(bool isSelected) => TextStyle(
    fontSize: statusButtonFontSize,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    color: isSelected ? AppColors.primaryPurple : AppColors.expandIcon,
    letterSpacing: 0.2,
  );

  // ========================================
  // Action Button Styles (Standardized)
  // ========================================

  /// Compact action button dimensions (used for Edit/Save buttons)
  static const double actionButtonCompactHeight = 36.0;
  static const EdgeInsets actionButtonCompactPadding = EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  );
  static const BorderRadius actionButtonBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const double actionButtonSpacing = 12.0;

  /// Primary action button style (for Save Changes, etc.)
  static ButtonStyle get primaryActionButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: actionButtonBorderRadius),
    padding: actionButtonCompactPadding,
    minimumSize: Size(0, actionButtonCompactHeight),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  /// Secondary action button style (for Edit Game, etc.)
  static ButtonStyle get secondaryActionButtonStyle => OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primaryPurple,
    elevation: 0,
    side: BorderSide(
      color: AppColors.primaryPurple.withValues(alpha: 0.3),
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(borderRadius: actionButtonBorderRadius),
    padding: actionButtonCompactPadding,
    minimumSize: Size(0, actionButtonCompactHeight),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  );

  /// Helper widget for primary action buttons with gradient background
  static Widget primaryActionButton({
    required Widget child,
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return Container(
      height: actionButtonCompactHeight,
      decoration: BoxDecoration(
        gradient: enabled ? AppGradients.buttonGradient : null,
        color: enabled ? null : AppColors.expandIcon.withValues(alpha: 0.3),
        borderRadius: actionButtonBorderRadius,
        boxShadow:
            enabled
                ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: actionButtonBorderRadius,
          child: Container(
            padding: actionButtonCompactPadding,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  // Filter button padding
  static const EdgeInsets filterButtonPadding = EdgeInsets.symmetric(
    horizontal: 6.0,
  );
  static const EdgeInsets compactFilterButtonPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
  );

  // Modern gradient button styles
  static ButtonStyle get selectedFilterButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  static ButtonStyle get unselectedFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        side: BorderSide(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      );

  static ButtonStyle get selectedCompactFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        minimumSize: const Size(compactFilterWidth, compactFilterHeight),
      ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  static ButtonStyle get unselectedCompactFilterButtonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        side: BorderSide(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        minimumSize: const Size(compactFilterWidth, compactFilterHeight),
      );

  // Enhanced button styles with gradients
  static ButtonStyle get addButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  static ButtonStyle get playButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  static ButtonStyle get startButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ).copyWith(backgroundColor: WidgetStateProperty.all(Colors.transparent));

  // Helper widget for gradient buttons
  static Widget gradientButton({
    required Widget child,
    required VoidCallback? onPressed,
    Gradient? gradient,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.buttonGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Padding(
            padding:
                padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: child,
          ),
        ),
      ),
    );
  }

  // Additional button padding
  static const EdgeInsets addButtonSmallPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
}

/// Styles for dropdown components
class DropdownStyles {
  // Enhanced filter dropdown decorations
  static BoxDecoration get collapsibleFilterDropdownDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [
      ...AppShadows.cardElevation,
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ],
  );

  // Dropdown item padding and styling
  static const EdgeInsets filterDropdownItemPadding = EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 8,
  );
  static const EdgeInsets filterDropdownButtonPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 4,
  );

  // Enhanced dropdown text styles
  static TextStyle get filterDropdownSelectedTextStyle => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryPurple,
    letterSpacing: 0.2,
  );

  static const TextStyle filterDropdownUnselectedTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static const TextStyle filterButtonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // Enhanced filter dropdown item decoration for selected state
  static BoxDecoration get filterDropdownSelectedItemDecoration =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.1),
            AppColors.secondaryPurple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
      );
}
