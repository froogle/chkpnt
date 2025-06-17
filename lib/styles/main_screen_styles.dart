import 'package:flutter/material.dart';
import 'global_styles.dart';
import 'game_card_styles.dart';
import 'layout_styles.dart';
import 'input_styles.dart';

/// Legacy compatibility class that combines styles from modular files
/// This maintains backward compatibility with existing MainScreenStyles usage
class MainScreenStyles {
  // Colors and backgrounds (from AppColors)
  static const Color backgroundColor = AppColors.background;
  static const Color sidebarColor = AppColors.sidebar;
  static const Color dividerColor = AppColors.divider;
  static const Color collapsibleSectionColor = AppColors.collapsibleSection;
  static const Color collapsibleSectionHeaderColor =
      AppColors.collapsibleSectionHeader;
  static const Color expandIconColor = AppColors.expandIcon;
  static const Color primaryAccentColor = AppColors.primaryAccent;
  static const Color primaryAccentColorTransparent =
      AppColors.primaryAccentTransparent;
  static const Color primaryTextColor = AppColors.primaryText;
  static const Color secondaryButtonColor = AppColors.secondaryButton;
  static const Color subtleShadowColor = AppColors.subtleShadow;

  // Layout dimensions (from LayoutStyles)
  static const double sidebarWidth = LayoutStyles.sidebarWidth;
  static const double bottomNavHeight = LayoutStyles.bottomNavHeight;
  static const double dividerHeight = LayoutStyles.dividerHeight;

  // Game card dimensions (from GameCardStyles)
  static const double gameImageSize = GameCardStyles.gameImageSize;
  static const double landscapeGameImageSize =
      GameCardStyles.landscapeGameImageSize;
  static const double landscapeGameCardAspectRatio =
      GameCardStyles.landscapeGameCardAspectRatio;

  // Input dimensions (from InputStyles)
  static const double compactSearchHeight = InputStyles.compactSearchHeight;
  static const double compactFilterHeight = InputStyles.compactFilterHeight;
  static const double compactFilterWidth = InputStyles.compactFilterWidth;
  static const double collapsibleFilterHeight =
      InputStyles.collapsibleFilterHeight;

  // Layout spacing (from LayoutStyles)
  static const double landscapeCategoryTabHeight =
      LayoutStyles.landscapeCategoryTabHeight;
  static const double landscapeGridSpacing = LayoutStyles.landscapeGridSpacing;
  static const EdgeInsets headerPadding = LayoutStyles.headerPadding;
  static const EdgeInsets contentPadding = LayoutStyles.contentPadding;
  static const EdgeInsets landscapeHeaderPadding =
      LayoutStyles.landscapeHeaderPadding;
  static const EdgeInsets landscapeGridPadding =
      LayoutStyles.landscapeGridPadding;
  static const double filterSpacing = LayoutStyles.filterSpacing;
  static const double sectionSpacing = LayoutStyles.sectionSpacing;
  static const double sectionTitleSpacing = LayoutStyles.sectionTitleSpacing;
  static const double landscapeSectionSpacing =
      LayoutStyles.landscapeSectionSpacing;
  static const double landscapeGameSpacing = LayoutStyles.landscapeGameSpacing;
  static const double landscapeGameContentSpacing =
      LayoutStyles.landscapeGameContentSpacing;
  static const double dividerSpacing = LayoutStyles.dividerSpacing;

  // Game card spacing (from GameCardStyles)
  static const EdgeInsets gameCardPadding = GameCardStyles.gameCardPadding;
  static const EdgeInsets gameCardMargin = GameCardStyles.gameCardMargin;
  static const EdgeInsets landscapeGameCardPadding =
      GameCardStyles.landscapeGameCardPadding;
  static const EdgeInsets landscapeGameCardContentPadding =
      GameCardStyles.landscapeGameCardContentPadding;
  static const EdgeInsets addGameIconButtonPadding =
      GameCardStyles.addGameIconButtonPadding;
  static const EdgeInsets smallIconPadding = GameCardStyles.smallIconPadding;
  static const EdgeInsets tinyIconPadding = GameCardStyles.tinyIconPadding;

  // Input padding (from InputStyles)
  static const EdgeInsets filterButtonPadding = InputStyles.filterButtonPadding;
  static const EdgeInsets compactFilterButtonPadding =
      InputStyles.compactFilterButtonPadding;
  static const EdgeInsets addButtonSmallPadding =
      InputStyles.addButtonSmallPadding;

  // Collapsible section spacing (from CollapsibleSectionStyles)
  static const EdgeInsets collapsibleSectionMargin =
      CollapsibleSectionStyles.collapsibleSectionMargin;
  static const EdgeInsets collapsibleSectionHeaderPadding =
      CollapsibleSectionStyles.collapsibleSectionHeaderPadding;
  static const EdgeInsets collapsibleSectionContentPadding =
      CollapsibleSectionStyles.collapsibleSectionContentPadding;

  // Dropdown spacing (from DropdownStyles)
  static const EdgeInsets filterDropdownItemPadding =
      DropdownStyles.filterDropdownItemPadding;
  static const EdgeInsets filterDropdownButtonPadding =
      DropdownStyles.filterDropdownButtonPadding;

  // Text styles (from LayoutStyles)
  static const TextStyle headerTextStyle = LayoutStyles.headerTextStyle;
  static const TextStyle sectionHeaderStyle = LayoutStyles.sectionHeaderStyle;
  static const TextStyle landscapeSectionHeaderStyle =
      LayoutStyles.landscapeSectionHeaderStyle;
  static const TextStyle sidebarNavTextStyle = LayoutStyles.sidebarNavTextStyle;
  static const TextStyle selectedCategoryTabTextStyle =
      LayoutStyles.selectedCategoryTabTextStyle;
  static const TextStyle unselectedCategoryTabTextStyle =
      LayoutStyles.unselectedCategoryTabTextStyle;
  static const TextStyle collapsibleSectionHeaderStyle =
      CollapsibleSectionStyles.collapsibleSectionHeaderStyle;

  // Game card text styles (from GameCardStyles)
  static const TextStyle landscapeGameCardTitleStyle =
      GameCardStyles.landscapeGameCardTitleStyle;
  static const TextStyle landscapeGameCardPlatformStyle =
      GameCardStyles.landscapeGameCardPlatformStyle;
  static const TextStyle landscapeGameCardStatusStyle =
      GameCardStyles.landscapeGameCardStatusStyle;
  static const TextStyle portraitGameCardTitleStyle =
      GameCardStyles.portraitGameCardTitleStyle;
  static const TextStyle portraitGameCardPlatformStyle =
      GameCardStyles.portraitGameCardPlatformStyle;
  static const TextStyle portraitGameCardStatusStyle =
      GameCardStyles.portraitGameCardStatusStyle;

  // Dropdown text styles (from DropdownStyles) - Updated to getters where needed
  static TextStyle get filterDropdownSelectedTextStyle =>
      DropdownStyles.filterDropdownSelectedTextStyle;
  static const TextStyle filterDropdownUnselectedTextStyle =
      DropdownStyles.filterDropdownUnselectedTextStyle;
  static const TextStyle filterButtonTextStyle =
      DropdownStyles.filterButtonTextStyle;

  // Empty state styles (from EmptyStateStyles)
  static const TextStyle emptyStateTextStyle =
      EmptyStateStyles.emptyStateTextStyle;

  // Decorations (from various files) - Updated to getters where needed
  static BoxDecoration get searchBarDecoration =>
      InputStyles.searchBarDecoration;
  static BoxDecoration get compactSearchBarDecoration =>
      InputStyles.compactSearchBarDecoration;
  static BoxDecoration get gameCardDecoration =>
      GameCardStyles.gameCardDecoration;
  static BoxDecoration get landscapeGameCardDecoration =>
      GameCardStyles.landscapeGameCardDecoration;
  static const BoxDecoration gameImageDecoration =
      GameCardStyles.gameImageDecoration;

  static BoxDecoration get bottomNavDecoration =>
      LayoutStyles.bottomNavDecoration;
  static BoxDecoration get landscapeHeaderDecoration =>
      LayoutStyles.landscapeHeaderDecoration;
  static BoxDecoration get landscapeCategoryTabDecoration =>
      LayoutStyles.landscapeCategoryTabDecoration;
  static BoxDecoration get selectedCategoryTabDecoration =>
      LayoutStyles.selectedCategoryTabDecoration;
  static const BoxDecoration unselectedCategoryTabDecoration =
      LayoutStyles.unselectedCategoryTabDecoration;
  static BoxDecoration get collapsibleSectionDecoration =>
      CollapsibleSectionStyles.collapsibleSectionDecoration;
  static BoxDecoration get collapsibleSectionHeaderDecoration =>
      CollapsibleSectionStyles.collapsibleSectionHeaderDecoration;
  static BoxDecoration get collapsibleFilterDropdownDecoration =>
      DropdownStyles.collapsibleFilterDropdownDecoration;

  // Game card gradient decorations (from GameCardStyles)
  static const BoxDecoration landscapeGameCardGradientDecoration =
      GameCardStyles.landscapeGameCardGradientDecoration;
  static const BoxDecoration portraitGameCardGradientDecoration =
      GameCardStyles.portraitGameCardGradientDecoration;

  // Action button decorations (from GameCardStyles) - Updated to getters
  static BoxDecoration get playActionButtonDecoration =>
      GameCardStyles.playActionButtonDecoration;
  static BoxDecoration get portraitPlayActionButtonDecoration =>
      GameCardStyles.portraitPlayActionButtonDecoration;
  static const BoxDecoration completedBadgeDecoration =
      GameCardStyles.completedBadgeDecoration;
  static const BoxDecoration portraitCompletedBadgeDecoration =
      GameCardStyles.portraitCompletedBadgeDecoration;

  // Dropdown decorations (from DropdownStyles) - Updated to getters
  static BoxDecoration get filterDropdownSelectedItemDecoration =>
      DropdownStyles.filterDropdownSelectedItemDecoration;

  // Empty state decorations (from EmptyStateStyles) - Updated to getters
  static BoxDecoration get emptyStateDecoration =>
      EmptyStateStyles.emptyStateDecoration;
  static const double emptyStateHeight = EmptyStateStyles.emptyStateHeight;
  static const double emptyStateIconSize = EmptyStateStyles.emptyStateIconSize;
  static const Color emptyStateIconColor = AppColors.emptyStateIcon;
  static const double emptyStateSpacing = EmptyStateStyles.emptyStateSpacing;

  // Input decorations (from InputStyles) - Updated to getters where needed
  static InputDecoration get searchInputDecoration =>
      InputStyles.searchInputDecoration;
  static InputDecoration get compactSearchInputDecoration =>
      InputStyles.compactSearchInputDecoration;

  // Button styles (from InputStyles)
  static ButtonStyle get selectedFilterButtonStyle =>
      InputStyles.selectedFilterButtonStyle;
  static ButtonStyle get unselectedFilterButtonStyle =>
      InputStyles.unselectedFilterButtonStyle;
  static ButtonStyle get selectedCompactFilterButtonStyle =>
      InputStyles.selectedCompactFilterButtonStyle;
  static ButtonStyle get unselectedCompactFilterButtonStyle =>
      InputStyles.unselectedCompactFilterButtonStyle;
  static ButtonStyle get addButtonStyle => InputStyles.addButtonStyle;
  static ButtonStyle get playButtonStyle => InputStyles.playButtonStyle;
  static ButtonStyle get startButtonStyle => InputStyles.startButtonStyle;

  // Legacy text styles for compatibility
  static const TextStyle gameTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle landscapeGameTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle gamePlatformStyle = TextStyle(
    fontSize: 14,
    color: AppColors.divider,
  );

  static const TextStyle landscapeGamePlatformStyle = TextStyle(
    fontSize: 11,
    color: AppColors.divider,
  );

  static const TextStyle gameStatusStyle = TextStyle(
    fontSize: 14,
    color: AppColors.expandIcon,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle landscapeGameStatusStyle = TextStyle(
    fontSize: 11,
    color: AppColors.expandIcon,
    fontStyle: FontStyle.italic,
  );

  // Legacy decoration constants
  static const BoxDecoration addButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration playButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration startButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const BoxDecoration menuButtonDecoration = BoxDecoration(
    color: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // Legacy spacing constants
  static const EdgeInsets gameCardSpacing = EdgeInsets.only(bottom: 12.0);
  static const EdgeInsets sidebarHeaderPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarContentPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets sidebarFilterPadding = EdgeInsets.only(bottom: 6.0);
  static const EdgeInsets sidebarNavPadding = EdgeInsets.all(16.0);
  static const EdgeInsets sidebarNavItemPadding = EdgeInsets.only(bottom: 8.0);
  static const EdgeInsets filterPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const double gameCardContentSpacing = 16.0;
  static const double gameCardVerticalSpacing = 8.0;

  // Legacy text shadow constants
  static const List<Shadow> gameCardTextShadows = AppShadows.gameCardText;
  static const List<Shadow> gameCardSubtextShadows = AppShadows.gameCardText;
  static const List<Shadow> gameCardPortraitTextShadows =
      AppShadows.gameCardPortraitText;

  // Scroll animation styles for scroll-to-section feature
  static const Duration scrollAnimationDuration = Duration(milliseconds: 800);
  static const Curve scrollAnimationCurve = Curves.easeInOutCubic;
  static const double scrollAnimationOffset = 20.0; // Extra offset from top
  static const Duration scrollRequestDelay = Duration(
    milliseconds: 300,
  ); // Delay before scrolling to allow UI to settle
}
