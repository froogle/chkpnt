# Shared Widgets Library

This directory contains reusable UI components that can be used throughout the app. Each widget follows the established architecture patterns and uses centralized styling.

## 🎮 Game Components

### `LandscapeGameCard`
A game card optimized for grid layouts (landscape orientation).

**Usage:**
```dart
LandscapeGameCard(
  game: gameItem,
  onTap: () => showGameDetails(game),
  onPlayPressed: game.status == GameStatus.backlog
      ? () => startPlaying(game)
      : null,
)
```

### `PortraitGameCard`
A game card optimized for list layouts (portrait orientation).

**Usage:**
```dart
PortraitGameCard(
  game: gameItem,
  onTap: () => showGameDetails(game),
  onPlayPressed: game.status == GameStatus.backlog
      ? () => startPlaying(game)
      : null,
)
```

## 🗂️ Layout Components

### `CollapsibleSection`
A generic expandable section with customizable content.

**Usage:**
```dart
CollapsibleSection(
  title: 'Section Title',
  isExpanded: isExpanded,
  onToggle: () => toggleSection(),
  isEmpty: items.isEmpty,
  emptyStateWidget: EmptyStateWidget(...),
  content: YourContentWidget(),
)
```

### `EmptyStateWidget`
A consistent empty state display with optional action button.

**Usage:**
```dart
EmptyStateWidget(
  icon: Icons.inbox_outlined,
  message: 'No items found',
  actionButton: ElevatedButton(...),
)
```

## 🔍 Input Components

### `CompactSearchBar`
A reusable search input component.

**Usage:**
```dart
CompactSearchBar(
  hintText: 'Search games...',
  onChanged: (query) => handleSearch(query),
  controller: searchController,
)
```

### `PlatformFilterDropdown`
A platform selection dropdown with custom styling.

**Usage:**
```dart
PlatformFilterDropdown(
  selectedPlatform: selectedPlatform,
  platforms: platformsList,
  onPlatformChanged: (platform) => updateFilter(platform),
)
```

## 📊 Data Models

### `game_models.dart`
Contains shared data models:
- `GameStatus` enum: playing, completed, backlog, abandoned
- `GameItem` class: Represents a game with title, platform, status, and progress

## 🎨 Styling

All widgets use centralized styling from `styles.dart`:
- `MainScreenStyles` - Main app styling constants
- `OnboardingOverlayStyles` - Onboarding-specific styles
- `SplashScreenStyles` - Splash screen styles

## 🏗️ Architecture Benefits

✅ **Reusability** - Components can be used across multiple screens
✅ **Consistency** - Centralized styling ensures uniform appearance
✅ **Maintainability** - Changes in one place affect all usage
✅ **Testability** - Individual components can be tested independently
✅ **Scalability** - Easy to extend and add new shared components

## 🔄 Future Additions

Consider creating shared widgets for:
- Navigation components
- Modal/dialog components
- Loading states
- Form inputs
- Toast/snackbar messages