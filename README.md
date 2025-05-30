# ChkPnt - Gaming Backlog Manager

A Flutter application for managing your gaming backlog with progress tracking, platform organisation, and wishlist management.

## 🏗️ Project Architecture

This project follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── models/           # Data models and entities
│   ├── game_models.dart
│   └── README.md
├── styles/           # Centralized styling and themes
│   ├── styles.dart
│   └── README.md
├── shared/           # Reusable UI components
│   ├── landscape_game_card.dart
│   ├── portrait_game_card.dart
│   ├── collapsible_section.dart
│   ├── platform_filter_dropdown.dart
│   ├── compact_search_bar.dart
│   ├── empty_state_widget.dart
│   ├── onboarding_overlay.dart
│   ├── onboarding_subscription_overlay.dart
│   └── README.md
├── providers/        # State management (Riverpod)
│   └── README.md
├── services/         # Business logic and domain services
│   └── README.md
├── repositories/     # Data access layer
│   └── README.md
├── screens/          # Screen-level widgets
│   ├── main_screen.dart
│   ├── splash_screen.dart
│   └── onboarding_screen.dart
└── main.dart
```

## 📋 Architecture Layers

### 🎨 **Presentation Layer**
- **`screens/`** - Full-screen widgets and navigation
- **`shared/`** - Reusable UI components
- **`styles/`** - Centralized styling and themes

### 🔄 **State Management Layer**
- **`providers/`** - Riverpod providers for state management
- Reactive state updates and dependency injection

### 🧠 **Business Logic Layer**
- **`services/`** - Pure business logic and domain rules
- Platform-agnostic and easily testable

### 💾 **Data Access Layer**
- **`repositories/`** - Data persistence and external APIs
- **`models/`** - Data structures and entities

## 🎮 Features

### Current Features
- ✅ Game library organization by status (Playing, Backlog, Completed, Abandoned)
- ✅ Platform filtering and search functionality
- ✅ Responsive design for portrait and landscape orientations
- ✅ Onboarding flow with subscription options
- ✅ Modern, retro-gaming inspired UI design

### Planned Features
- 🔄 Game progress tracking with detailed statistics
- 🔄 External API integration (Steam, PlayStation, etc.)
- 🔄 Cloud backup and synchronization
- 🔄 Achievement and trophy tracking
- 🔄 Social features and shared lists
- 🔄 Wishlist and price tracking

## 🏗️ Development Guidelines

### Widget Architecture
- Extract complex `build()` methods into focused `_buildXXX()` methods
- Separate business logic from UI rendering
- Use centralized styling from `lib/styles/`
- Follow consistent naming conventions

### State Management
- Use Riverpod for state management
- Separate UI state from business state
- Implement proper error handling with AsyncValue
- Use dependency injection for services

### Styling
- All styling constants in `lib/styles/styles.dart`
- Group related styles in logical classes
- Use semantic names instead of magic numbers
- Support both light and dark themes

## 🧪 Testing Strategy

### Unit Tests
- **Services** - Business logic with mocked dependencies
- **Repositories** - Data access with in-memory databases
- **Models** - Data serialization and validation

### Widget Tests
- **Shared Components** - Reusable UI widgets
- **Providers** - State management logic
- **Screens** - Full screen functionality

### Integration Tests
- End-to-end user flows
- Cross-platform compatibility
- Performance benchmarks

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK (latest)
- Android Studio / VS Code
- Git

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd chkpnt

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Development Setup
```bash
# Enable code generation (when adding models)
flutter packages pub run build_runner build

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 📚 Documentation

Each directory contains detailed README files:
- [`lib/models/README.md`](lib/models/README.md) - Data models and entities
- [`lib/styles/README.md`](lib/styles/README.md) - Styling system and guidelines
- [`lib/shared/README.md`](lib/shared/README.md) - Reusable UI components
- [`lib/providers/README.md`](lib/providers/README.md) - State management patterns
- [`lib/services/README.md`](lib/services/README.md) - Business logic architecture
- [`lib/repositories/README.md`](lib/repositories/README.md) - Data access patterns

## 🔄 Contributing

1. Follow the established architecture patterns
2. Write tests for new functionality
3. Use the centralized styling system
4. Document new components and patterns
5. Ensure code passes `flutter analyze`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
