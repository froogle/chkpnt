# Shared Widgets Library

This directory contains **truly reusable** UI components that are used by 2+ screens throughout the app. Each widget follows established architecture patterns and uses centralized styling.

## 🏗️ Organization Structure

```
lib/shared/widgets/
├── cards/                    # Display components
│   ├── landscape_game_card.dart
│   └── portrait_game_card.dart
├── inputs/                   # Form inputs and controls
│   ├── compact_search_bar.dart
│   └── platform_filter_dropdown.dart
├── layout/                   # Layout helpers and containers
│   ├── collapsible_section.dart
│   └── empty_state_widget.dart
└── README.md (this file)
```

## 🎮 Cards Components

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

## 🔍 Input Components

### `CompactSearchBar`
A reusable search input component with Riverpod integration.

**Usage:**
```dart
CompactSearchBar(
  hintText: 'Search games...',
  onTap: () => handleSearchTap(),
  readOnly: false,
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
  height: 200, // optional custom height
)
```

## 📋 Widget Promotion Guidelines

### ✅ Criteria for Shared Widgets

A widget should be in `shared/widgets/` if it meets **ALL** of these criteria:

- [ ] **Used by 2+ screens** - Currently used or planned for multiple screens
- [ ] **Generic and configurable** - Has well-defined, reusable props
- [ ] **No screen-specific logic** - Free of business logic tied to specific screens
- [ ] **Stable API** - Props and behavior are unlikely to change frequently
- [ ] **Well-documented** - Has clear usage examples and prop descriptions

### 🔄 Migration from Screen-Specific

When promoting a widget from screen-specific to shared:

1. **Generalize the API** - Remove screen-specific props and logic
2. **Add comprehensive props** - Ensure it's configurable for different use cases
3. **Update documentation** - Add usage examples and prop descriptions
4. **Write tests** - Ensure the widget works in isolation
5. **Update imports** - Move from screen directory to shared directory

## 🎨 Styling Guidelines

All shared widgets should:

- Use centralized styles from `lib/styles/`
- Accept optional style overrides where appropriate
- Follow the app's design system consistently
- Be responsive and work in different orientations

## 🧪 Testing

Each shared widget should have:

- **Unit tests** for logic and state management
- **Widget tests** for UI behavior and rendering
- **Integration tests** for complex interactions

## 📁 Import Paths

```dart
// Shared widgets
import 'package:your_app/shared/widgets/cards/portrait_game_card.dart';
import 'package:your_app/shared/widgets/inputs/compact_search_bar.dart';
import 'package:your_app/shared/widgets/layout/empty_state_widget.dart';
```

## 🔮 Future Additions

Consider creating shared widgets for:

- **Navigation components** - Tab bars, breadcrumbs
- **Modal/dialog components** - Confirmation dialogs, info modals
- **Loading states** - Spinners, skeleton loaders
- **Form inputs** - Custom text fields, switches, sliders
- **Toast/snackbar messages** - Success, error, info notifications
- **Data visualization** - Charts, progress indicators

## 🏛️ Architecture Benefits

✅ **Reusability** - Components can be used across multiple screens
✅ **Consistency** - Centralized styling ensures uniform appearance  
✅ **Maintainability** - Changes in one place affect all usage
✅ **Testability** - Individual components can be tested independently
✅ **Scalability** - Easy to extend and add new shared components
✅ **Team Collaboration** - Clear guidelines for widget organization 