import 'package:flutter/material.dart';
import 'global_styles.dart';

class GameCardStyles {
  // Dimensions
  static const double gameImageSize = 80.0;

  // Spacing and padding
  static const EdgeInsets gameCardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets gameCardMargin = EdgeInsets.only(bottom: 16);
  static const EdgeInsets addGameIconButtonPadding = EdgeInsets.all(12);
  static const EdgeInsets smallIconPadding = EdgeInsets.all(8);
  static const EdgeInsets tinyIconPadding = EdgeInsets.all(6);

  // Modern card decorations with shadow
  static BoxDecoration get gameCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
  );

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

  // Compact card gradient overlays - for different image states
  static const BoxDecoration compactGameCardGradientDefault = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Color(0x10000000), // Very light overlay for placeholder
      ],
      stops: [0.0, 1.0],
    ),
  );

  static const BoxDecoration compactGameCardGradientWithImage = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x60000000), // Darker at top for text readability
        Color(0x30000000), // Medium in middle
        Colors.transparent, // No shading at bottom
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  );

  // Compact card text styles - for when no custom image is set (default)
  static const TextStyle compactGameCardTitleStyleDefault = TextStyle(
    fontSize: 10,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );

  // Compact card text styles - for when custom image is set (enhanced readability)
  static const TextStyle compactGameCardTitleStyleWithImage = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    shadows: [
      Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1)),
      Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(0, 0)),
    ],
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

  static const BoxDecoration completedBadgeDecoration = BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(color: Color(0x4010B981), blurRadius: 6, offset: Offset(0, 2)),
    ],
  );
}
