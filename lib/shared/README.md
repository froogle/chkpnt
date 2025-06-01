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

## 🎯 Onboarding Components

### `OnboardingOverlay`
Main onboarding overlay component for user introduction.

### `OnboardingSubscriptionOverlay`
Specialized overlay for subscription-related onboarding flow.

## 📊 Data Models

Game models are now located in `lib/models/`:
- `game_models.dart` - Contains GameStatus enum and GameItem class

## 🎨 Styling

All styling is now centralized in `lib/styles/`:
- `styles.dart` - Contains all style classes:
  - `MainScreenStyles` - Main app styling constants
  - `OnboardingOverlayStyles` - Onboarding-specific styles
  - `SplashScreenStyles` - Splash screen styles

## 🏗️ Architecture Benefits

✅ **Reusability** - Components can be used across multiple screens
✅ **Consistency** - Centralized styling ensures uniform appearance
✅ **Maintainability** - Changes in one place affect all usage
✅ **Testability** - Individual components can be tested independently
✅ **Scalability** - Easy to extend and add new shared components
✅ **Organization** - Clear separation of concerns with dedicated folders

## 🔄 Future Additions

Consider creating shared widgets for:
- Navigation components
- Modal/dialog components
- Loading states
- Form inputs
- Toast/snackbar messages

## 📁 Complete Project Structure

```
root/
├── assets/                    # Static assets
│   ├── logo.png
│   ├── onboarding1.png
│   └── onboarding2.png
├── lib/                       # Main application code
│   ├── main.dart             # App entry point
│   ├── main_screen.dart      # Main app screen
│   ├── splash_screen.dart    # Splash screen
│   ├── onboarding_screen.dart # Onboarding screen
│   ├── models/               # Data models and entities
│   │   ├── README.md
│   │   ├── game_models.dart
│   │   ├── game_models.freezed.dart
│   │   └── game_models.g.dart
│   ├── providers/            # State management (Riverpod)
│   │   ├── README.md
│   │   ├── game_provider.dart
│   │   ├── game_provider.g.dart
│   │   ├── ui_state_provider.dart
│   │   └── ui_state_provider.g.dart
│   ├── repositories/         # Data access layer
│   │   └── README.md
│   ├── services/             # Business logic and external services
│   │   └── README.md
│   ├── shared/               # Reusable UI components
│   │   ├── README.md (this file)
│   │   ├── collapsible_section.dart
│   │   ├── compact_search_bar.dart
│   │   ├── empty_state_widget.dart
│   │   ├── landscape_game_card.dart
│   │   ├── onboarding_overlay.dart
│   │   ├── onboarding_subscription_overlay.dart
│   │   ├── platform_filter_dropdown.dart
│   │   └── portrait_game_card.dart
│   └── styles/               # Centralized styling
│       ├── README.md
│       ├── styles.dart       # Main styles export
│       ├── themes.dart       # App themes
│       ├── global_styles.dart
│       ├── game_card_styles.dart
│       ├── input_styles.dart
│       ├── layout_styles.dart
│       ├── main_screen_styles.dart
│       └── onboarding_styles.dart
├── test/                     # Test files
│   ├── README.md
│   ├── widget_test.dart
│   ├── main_screen_auto_expansion_test.dart
│   └── providers/
│       ├── game_provider_test.dart
│       └── ui_state_provider_test.dart
├── android/                  # Android platform files
├── ios/                      # iOS platform files
├── web/                      # Web platform files
├── windows/                  # Windows platform files
├── linux/                    # Linux platform files
├── macos/                    # macOS platform files
├── pubspec.yaml              # Dependencies and project configuration
├── README.md                 # Main project documentation
├── RIVERPOD_INTEGRATION.md   # Riverpod integration guide
└── analysis_options.yaml    # Dart analyzer configuration
```

## 🔧 Key Architecture Features

- **State Management**: Riverpod with providers and generated code
- **Code Generation**: Freezed for immutable models, JSON serialization
- **Testing**: Comprehensive widget and provider tests
- **Multi-Platform**: Support for Android, iOS, Web, Windows, Linux, macOS
- **Documentation**: Each major directory includes detailed README files
- **Type Safety**: Strong typing with null safety and immutable data structures