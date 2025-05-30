import 'package:flutter/material.dart';
import 'global_styles.dart';

/// Styles for game cards in different orientations
class GameCardStyles {
  // Dimensions
  static const double gameImageSize = 80.0;
  static const double landscapeGameImageSize = 48.0;
  static const double landscapeGameCardAspectRatio = 1.2;
  static const double progressBarWidth = 80.0;
  static const double progressBarHeight = 8.0;

  // Spacing and padding
  static const EdgeInsets gameCardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets gameCardMargin = EdgeInsets.only(bottom: 12);
  static const EdgeInsets landscapeGameCardPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
  );
  static const EdgeInsets landscapeGameCardContentPadding = EdgeInsets.all(
    12.0,
  );
  static const EdgeInsets addGameIconButtonPadding = EdgeInsets.all(12);
  static const EdgeInsets smallIconPadding = EdgeInsets.all(8);
  static const EdgeInsets tinyIconPadding = EdgeInsets.all(6);

  // Card decorations
  static const BoxDecoration gameCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: AppShadows.cardElevation,
  );

  static const BoxDecoration landscapeGameCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: AppShadows.subtleElevation,
  );

  static const BoxDecoration gameImageDecoration = BoxDecoration(
    color: Color(0xFFF0F0F0),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  // Gradient overlays for game cards
  static const BoxDecoration landscapeGameCardGradientDecoration =
      BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0x44000000), // Light overlay in middle
            Color(0xCC000000), // Strong overlay at bottom
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      );

  static const BoxDecoration portraitGameCardGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xCC000000), // More opaque black on left
        Color(0x66000000), // Semi-transparent in middle
        Colors.transparent, // Transparent on right
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  );

  // Text styles for landscape cards
  static const TextStyle landscapeGameCardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: AppShadows.gameCardText,
  );

  static const TextStyle landscapeGameCardPlatformStyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
    shadows: AppShadows.gameCardText,
  );

  static const TextStyle landscapeGameCardStatusStyle = TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    shadows: AppShadows.gameCardText,
  );

  // Text styles for portrait cards
  static const TextStyle portraitGameCardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: AppShadows.gameCardPortraitText,
  );

  static const TextStyle portraitGameCardPlatformStyle = TextStyle(
    fontSize: 14,
    color: Colors.white70,
    shadows: AppShadows.gameCardPortraitText,
  );

  static const TextStyle portraitGameCardStatusStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    shadows: AppShadows.gameCardPortraitText,
  );

  // Action button decorations
  static const BoxDecoration playActionButtonDecoration = BoxDecoration(
    color: AppColors.primaryAccent,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(color: Color(0x66000000), blurRadius: 6, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration portraitPlayActionButtonDecoration = BoxDecoration(
    color: AppColors.primaryAccent,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: [
      BoxShadow(color: Color(0x44000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration completedBadgeDecoration = BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(color: Color(0x66000000), blurRadius: 6, offset: Offset(0, 2)),
    ],
  );

  static const BoxDecoration portraitCompletedBadgeDecoration = BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(color: Color(0x44000000), blurRadius: 8, offset: Offset(0, 2)),
    ],
  );

  // Progress bar decoration
  static const BoxDecoration progressBarDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
}
