# Styles Directory

This directory contains all centralized styling definitions organised in a modular structure for better maintainability and organisation.

## 📁 File Structure

### `styles.dart` - Barrel Export
Main entry point that exports all style modules for convenient importing:
```dart
import '../styles/styles.dart'; // Imports everything
```

### `themes.dart` - Global Themes
Contains the app-wide light and dark themes:
- `retroBacklogTheme` - Light theme with warm orange palette
- `retroBacklogDarkTheme` - Dark theme variant

### `global_styles.dart` - Shared Styles
Global styles used across multiple components:
- `AppColors` - Central colour palette
- `AppShadows` - Reusable shadow definitions
- `onboardingWelcomeTextStyle` - Global text styles

### `onboarding_styles.dart` - Onboarding Components
Styles for splash screen and onboarding flows:
- `SplashScreenStyles` - Splash screen styling
- `OnboardingOverlayStyles` - Onboarding overlay styling

### `game_card_styles.dart` - Game Card Components
Dedicated styles for game cards in different orientations:
- `GameCardStyles` - Card dimensions, decorations, and text styles
- Separate styling for landscape and portrait orientations
- Action button and badge decorations

### `layout_styles.dart` - Layout & Sections
Main screen layout and structural components:
- `LayoutStyles` - Header, navigation, spacing constants
- `CollapsibleSectionStyles` - Expandable section styling
- `EmptyStateStyles` - Empty state component styling

### `input_styles.dart` - Interactive Components
Input controls and interactive elements:
- `InputStyles` - Search bars, buttons, form controls
- `DropdownStyles` - Dropdown and filter components

### `main_screen_styles.dart` - Legacy Compatibility
Maintains backward compatibility with existing `MainScreenStyles` usage:
- Combines styles from all modular files
- Allows existing code to work without changes
- Will be gradually migrated away from

## 🎨 Usage Patterns

### 🔄 **Gradual Migration Approach**
The modular structure allows for gradual migration:

```dart
// Old way (still works)
import '../styles/styles.dart';
Container(decoration: MainScreenStyles.gameCardDecoration);

// New way (preferred for new code)
import '../styles/styles.dart';
Container(decoration: GameCardStyles.gameCardDecoration);
```

### 🎯 **Specific Imports**
For performance and clarity, import specific modules:

```dart
// Import only what you need
import '../styles/game_card_styles.dart';
import '../styles/global_styles.dart';

Container(
  decoration: GameCardStyles.gameCardDecoration,
  child: Text('Game Title', style: TextStyle(color: AppColors.primaryText)),
);
```

### 🎪 **Component-Specific Styling**
Each widget type has its dedicated style class:

```dart
// Game cards
LandscapeGameCard(decoration: GameCardStyles.landscapeGameCardDecoration);

// Layout elements
CollapsibleSection(headerStyle: CollapsibleSectionStyles.collapsibleSectionHeaderStyle);

// Input elements
CompactSearchBar(decoration: InputStyles.compactSearchBarDecoration);
```

## 📋 Style Classes Overview

### `AppColors`
Central colour palette with semantic names:
```dart
AppColors.primaryAccent      // Main brand colour
AppColors.primaryText        // Primary text colour
AppColors.background         // Main background
AppColors.collapsibleSection // Section backgrounds
```

### `AppShadows`
Reusable shadow definitions:
```dart
AppShadows.cardElevation     // Standard card shadows
AppShadows.gameCardText      // Text shadows for game cards
AppShadows.subtleElevation   // Light elevation effects
```

### Component Style Classes
Each major component has its own style class:
- `GameCardStyles` - All game card related styling
- `LayoutStyles` - Layout and structural styling
- `InputStyles` - Interactive component styling
- `CollapsibleSectionStyles` - Section component styling
- `EmptyStateStyles` - Empty state styling

## 🏗️ Architecture Benefits

### ✅ **Modular Organisation**
- Each file has a single responsibility
- Easy to find and modify specific styles
- Reduces cognitive load when working on components

### ✅ **Better Performance**
- Import only what you need
- Reduced bundle size for specific style imports
- Tree-shaking friendly structure

### ✅ **Maintainability**
- Changes to game card styles only affect game card file
- Clear separation of concerns
- Easier to refactor and extend

### ✅ **Team Collaboration**
- Multiple developers can work on different style files
- Reduced merge conflicts
- Clear ownership of style areas

### ✅ **Backward Compatibility**
- Existing code continues to work
- Gradual migration path
- No breaking changes

## 🔄 Migration Strategy

### Phase 1: ✅ **Modularisation Complete**
- Split monolithic styles.dart into focused modules
- Maintain backward compatibility with MainScreenStyles
- All existing functionality preserved

### Phase 2: 🔄 **Gradual Component Migration**
- New components use modular styles directly
- Existing components gradually migrated during updates
- Remove unused MainScreenStyles properties

### Phase 3: 🔄 **Legacy Cleanup**
- Remove MainScreenStyles compatibility layer
- Direct imports of specific style modules
- Fully modular styling system

## 📚 Style Guidelines

### Naming Conventions
✅ **Semantic Names** - `primaryAccent` vs `orangeColor`
✅ **Component Prefixes** - `gameCard`, `collapsibleSection`
✅ **Size Descriptors** - `small`, `compact`, `landscape`
✅ **State Indicators** - `selected`, `expanded`, `disabled`

### Organisation Principles
✅ **Single Responsibility** - Each file handles one concern
✅ **Logical Grouping** - Related styles in same class
✅ **Consistent Structure** - Same pattern across all files
✅ **Import Efficiency** - Easy to import what you need

### Color Usage
✅ **Central Palette** - All colours in AppColors
✅ **Semantic Names** - Role-based naming
✅ **Theme Support** - Works with light/dark themes
✅ **Accessibility** - Proper contrast ratios

## 🔧 Development Workflow

### Adding New Styles
1. Identify the appropriate style module
2. Add styles to the relevant class
3. Update barrel export if needed
4. Use semantic naming conventions

### Modifying Existing Styles
1. Locate the style in the appropriate module
2. Make changes in one place
3. Verify backward compatibility if needed
4. Test across all usage points

### Creating New Components
1. Use existing style classes where possible
2. Create new style class if component is complex
3. Add to appropriate module or create new one
4. Export through barrel file

This modular structure provides a solid foundation for scalable styling that grows with your application! 🚀