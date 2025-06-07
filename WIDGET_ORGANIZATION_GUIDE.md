# Flutter Widget Organization Best Practices

## Recommended Folder Structure

```
lib/
├── shared/
│   ├── widgets/                    # Truly reusable widgets
│   │   ├── cards/
│   │   │   ├── portrait_game_card.dart
│   │   │   └── landscape_game_card.dart
│   │   ├── inputs/
│   │   │   ├── compact_search_bar.dart
│   │   │   └── platform_filter_dropdown.dart
│   │   ├── layout/
│   │   │   ├── collapsible_section.dart
│   │   │   └── empty_state_widget.dart
│   │   └── README.md
│   └── animations/                 # Reusable animations
│       └── README.md
├── screens/
│   ├── main/
│   │   ├── widgets/               # Main screen specific widgets
│   │   │   ├── main_screen_header.dart
│   │   │   ├── main_screen_bottom_nav.dart
│   │   │   ├── game_section.dart
│   │   │   └── animations/
│   │   │       └── game_transition_animation.dart
│   │   ├── main_screen.dart
│   │   └── README.md
│   ├── onboarding/
│   │   ├── widgets/               # Onboarding specific widgets
│   │   │   ├── onboarding_overlay.dart
│   │   │   └── onboarding_subscription_overlay.dart
│   │   ├── onboarding_screen.dart
│   │   └── README.md
│   └── splash/
│       └── splash_screen.dart
├── models/
├── providers/
├── services/
├── styles/
└── utils/
```

## Organization Principles

### 1. **Shared vs Screen-Specific**

**Shared Widgets (`lib/shared/widgets/`):**
- Used by 2+ screens
- Generic and configurable
- No business logic
- Well-documented with examples

**Screen-Specific Widgets (`lib/screens/[screen_name]/widgets/`):**
- Used only by one screen
- Can contain screen-specific business logic
- Tightly coupled to screen requirements

### 2. **Categorization by Function**

**For Shared Widgets:**
- `cards/` - Display components (game cards, user cards, etc.)
- `inputs/` - Form inputs, search bars, filters
- `layout/` - Layout helpers, sections, containers
- `dialogs/` - Modal dialogs, overlays
- `buttons/` - Custom button variants
- `animations/` - Reusable animation widgets

**For Screen-Specific Widgets:**
- Group by screen: `main/`, `onboarding/`, `profile/`, etc.
- Within each screen: `widgets/` and optionally `animations/`

### 3. **When to Promote from Screen-Specific to Shared**

Move a widget to shared when:
- It's needed by a second screen
- The widget is generic enough to be reusable
- It has clear, well-defined props
- It's stable (not changing frequently)

## Migration Strategy for Your Project

### Phase 1: Reorganize Current Structure

1. **Keep in Shared (already truly reusable):**
   - `portrait_game_card.dart` → `shared/widgets/cards/`
   - `landscape_game_card.dart` → `shared/widgets/cards/`
   - `empty_state_widget.dart` → `shared/widgets/layout/`
   - `collapsible_section.dart` → `shared/widgets/layout/`
   - `compact_search_bar.dart` → `shared/widgets/inputs/`
   - `platform_filter_dropdown.dart` → `shared/widgets/inputs/`

2. **Move to Screen-Specific:**
   - `main_screen_header.dart` → `screens/main/widgets/`
   - `main_screen_bottom_nav.dart` → `screens/main/widgets/`
   - `game_section.dart` → `screens/main/widgets/`
   - `game_transition_animation.dart` → `screens/main/widgets/animations/`
   - `onboarding_overlay.dart` → `screens/onboarding/widgets/`
   - `onboarding_subscription_overlay.dart` → `screens/onboarding/widgets/`

### Phase 2: Create Screen Directories

Create the new directory structure and move screen files:
- `main_screen.dart` → `screens/main/main_screen.dart`
- `onboarding_screen.dart` → `screens/onboarding/onboarding_screen.dart`
- `splash_screen.dart` → `screens/splash/splash_screen.dart`

## Benefits of This Structure

### ✅ **Clarity**
- Clear distinction between reusable and screen-specific components
- Easy to find widgets related to specific screens

### ✅ **Scalability**
- New screens get their own widget folder
- Shared widgets grow organically as needs arise

### ✅ **Maintainability**
- Screen-specific changes don't affect other screens
- Shared widget changes are intentional and well-considered

### ✅ **Team Collaboration**
- Developers know where to look for screen-specific code
- Clear guidelines for when to create shared vs screen widgets

### ✅ **Testing**
- Screen widgets can be tested with screen context
- Shared widgets have comprehensive, reusable tests

## Import Path Examples

```dart
// Shared widgets
import 'package:your_app/shared/widgets/cards/portrait_game_card.dart';
import 'package:your_app/shared/widgets/inputs/compact_search_bar.dart';

// Screen-specific widgets
import 'package:your_app/screens/main/widgets/main_screen_header.dart';
import 'package:your_app/screens/main/widgets/animations/game_transition_animation.dart';

// Screens
import 'package:your_app/screens/main/main_screen.dart';
import 'package:your_app/screens/onboarding/onboarding_screen.dart';
```

## Widget Promotion Checklist

Before moving a widget from screen-specific to shared:

- [ ] Is it used by 2+ screens?
- [ ] Are the props generic and well-defined?
- [ ] Is it free of screen-specific business logic?
- [ ] Does it have comprehensive documentation?
- [ ] Are there unit tests covering its functionality?
- [ ] Is the API stable (not changing frequently)?

## Examples from Your Codebase

### ✅ Good Shared Widgets
- `PortraitGameCard` - Generic, reusable, well-defined props
- `EmptyStateWidget` - Generic empty state, configurable
- `CompactSearchBar` - Reusable input component

### 🔄 Should Be Screen-Specific
- `GameTransitionAnimation` - Very specific to main screen game flow
- `MainScreenHeader` - Tightly coupled to main screen layout
- `OnboardingOverlay` - Specific to onboarding flow

### 🤔 Evaluate for Future
- `GameSection` - Could become shared if other screens need game lists
- `CollapsibleSection` - Already generic, good as shared 