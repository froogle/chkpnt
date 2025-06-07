import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styles for game cards in different orientations
class GameCardStyles {
  // Dimensions
  static const double gameImageSize = 80.0;
  static const double landscapeGameImageSize = 48.0;
  static const double landscapeGameCardAspectRatio = 1.2;

  // Spacing and padding
  static const EdgeInsets gameCardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets gameCardMargin = EdgeInsets.only(bottom: 16);
  static const EdgeInsets landscapeGameCardPadding = EdgeInsets.symmetric(
    horizontal: 12.0,
  );
  static const EdgeInsets landscapeGameCardContentPadding = EdgeInsets.all(
    16.0,
  );
  static const EdgeInsets addGameIconButtonPadding = EdgeInsets.all(12);
  static const EdgeInsets smallIconPadding = EdgeInsets.all(8);
  static const EdgeInsets tinyIconPadding = EdgeInsets.all(6);

  // Modern card decorations with gradient borders
  static BoxDecoration get gameCardDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: _createGradientBorder(width: 3.0),
    boxShadow: AppShadows.cardElevation,
  );

  static BoxDecoration get landscapeGameCardDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: _createGradientBorder(width: 2.5),
    boxShadow: AppShadows.subtleElevation,
  );

  // Helper method to create gradient border effect with enhanced visibility
  static Border _createGradientBorder({double width = 3.0}) {
    return Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.4),
      width: width,
    );
  }

  // Enhanced gradient border decoration for special cards
  static BoxDecoration get gradientBorderCardDecoration => BoxDecoration(
    gradient: AppGradients.cardGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    border: Border.all(
      color: AppColors.primaryPurple.withValues(alpha: 0.6),
      width: 3.5,
    ),
    boxShadow: [
      ...AppShadows.cardElevation,
      ...AppShadows.gradientBorderShadow,
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.3),
        blurRadius: 12,
        offset: Offset(0, 3),
        spreadRadius: 1,
      ),
    ],
  );

  static const BoxDecoration gameImageDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
    ),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  // Enhanced gradient overlays for game cards
  static const BoxDecoration landscapeGameCardGradientDecoration =
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0x33000000), // Lighter overlay in middle
            Color(0xBB000000), // Strong overlay at bottom
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      );

  static const BoxDecoration portraitGameCardGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xBB000000), // More opaque black on left
        Color(0x55000000), // Semi-transparent in middle
        Colors.transparent, // Transparent on right
      ],
      stops: [0.0, 0.5, 1.0],
    ),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  // Enhanced text styles for better readability
  static const TextStyle landscapeGameCardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    shadows: AppShadows.gameCardText,
    letterSpacing: 0.5,
  );

  static const TextStyle landscapeGameCardPlatformStyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
    shadows: AppShadows.gameCardText,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle landscapeGameCardStatusStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    shadows: AppShadows.gameCardText,
    letterSpacing: 0.3,
  );

  // Enhanced text styles for portrait cards
  static const TextStyle portraitGameCardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    shadows: AppShadows.gameCardPortraitText,
    letterSpacing: 0.5,
  );

  static const TextStyle portraitGameCardPlatformStyle = TextStyle(
    fontSize: 14,
    color: Colors.white70,
    shadows: AppShadows.gameCardPortraitText,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle portraitGameCardStatusStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    shadows: AppShadows.gameCardPortraitText,
    letterSpacing: 0.3,
  );

  // Modern gradient action button decorations
  static BoxDecoration get playActionButtonDecoration => BoxDecoration(
    gradient: AppGradients.buttonGradient,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration get portraitPlayActionButtonDecoration => BoxDecoration(
    gradient: AppGradients.buttonGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryPurple.withValues(alpha: 0.25),
        blurRadius: 12,
        offset: Offset(0, 6),
        spreadRadius: 0,
      ),
    ],
  );

  static const BoxDecoration completedBadgeDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(color: Color(0x4010B981), blurRadius: 6, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration portraitCompletedBadgeDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(color: Color(0x4010B981), blurRadius: 8, offset: Offset(0, 4)),
    ],
  );
}
