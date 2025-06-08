# ChkPnt - Gaming Backlog Manager

A Flutter application for managing your gaming backlog with progress tracking, platform organisation, and wishlist management.

## 🏗️ Project Architecture

This project follows a clean architecture pattern with **streaming-based state management** and clear separation of concerns:

```
lib/
├── models/           # Data models and entities
│   ├── game_models.dart
│   └── README.md
├── styles/           # Centralised styling and themes
│   ├── styles.dart
│   └── README.md
├── shared/           # Reusable UI components
│   ├── widgets/      # Truly reusable widgets (2+ screens)
│   │   ├── cards/    # Display components
│   │   ├── inputs/   # Form inputs and controls
│   │   ├── buttons/  # Interactive elements
│   │   └── layout/   # Layout helpers and containers
│   └── README.md
├── screens/          # Screen-level widgets and components
│   ├── main/
│   │   ├── widgets/  # Main screen specific widgets
│   │   └── main_screen.dart
│   ├── splash/
│   └── onboarding/
├── providers/        # Streaming state management (Riverpod)
│   ├── game_provider.dart
│   ├── ui_state_provider.dart
│   └── README.md
├── services/         # Business logic and domain services
│   ├── game_actions_service.dart
│   ├── game_image_service.dart
│   └── README.md
├── repositories/     # Data access layer with streaming
│   ├── game_repository.dart
│   ├── in_memory_game_repository.dart
│   └── README.md
├── utils/            # Utility functions
└── main.dart
```

## 📋 Architecture Layers

### 🎨 **Presentation Layer**
- **`screens/`** - Full-screen widgets with screen-specific components
- **`shared/`** - Truly reusable UI components (used by 2+ screens)
- **`styles/`** - Centralised styling and themes

### 🔄 **State Management Layer (Streaming Architecture)**
- **`providers/`** - Riverpod providers with **streaming data sources**
- **Reactive state updates** with automatic UI rebuilds
- **Async state management** with proper error handling
- **Repository integration** for persistent storage readiness

### 🧠 **Business Logic Layer**
- **`services/`** - Pure business logic and domain rules
- Platform-agnostic and extensively tested
- **Async operations** with proper error handling

### 💾 **Data Access Layer (Repository Pattern)**
- **`repositories/`** - **Streaming data sources** and external APIs
- **`models/`** - Data structures and entities
- **Abstract interfaces** for easy storage backend swapping
- **Currently**: In-memory implementation with streaming capabilities
- **Ready for**: SQLite, Hive, Firebase, or any persistent storage

## 🎮 Features

### Current Features
- ✅ **Streaming reactive state management** with automatic UI updates
- ✅ Game library organisation by status (Playing, Backlog, Completed, Abandoned)
- ✅ Platform filtering and search functionality with real-time updates
- ✅ Responsive design for portrait and landscape orientations
- ✅ Onboarding flow with subscription options
- ✅ Modern, retro-gaming inspired UI design
- ✅ **Comprehensive test suite** (310+ tests) with streaming architecture support

### Planned Features
- 🔄 **Persistent storage integration** (repository pattern ready)
- 🔄 Game progress tracking with detailed statistics
- 🔄 External API integration (Steam, PlayStation, etc.)
- 🔄 Cloud backup and synchronisation
- 🔄 Achievement and trophy tracking
- 🔄 Social features and shared lists
- 🔄 Wishlist and price tracking

## 🏗️ Development Guidelines

### Widget Architecture
- **Extract Complex Build Methods** using `_buildXXX()` pattern
- **Separate Business Logic** from UI rendering
- **Use Centralised Styling** from `lib/styles/`
- **Follow Consistent Naming** conventions throughout

### State Management (Streaming Architecture)
- **Streaming Providers**: All data sources use streams for reactive updates
- **Repository Pattern**: Abstract interfaces for easy storage backend swapping
- **Async State Management**: Proper `AsyncValue` handling throughout
- **Dependency Injection**: Services and repositories provided through Riverpod
- **Error Handling**: Comprehensive error states and user feedback

### Repository Pattern
```dart
// Abstract interface - easy to swap implementations
abstract class GameRepository {
  Stream<List<GameItem>> watchGames();        // Streaming data
  Future<List<GameItem>> getAllGames();       // One-time access
  Future<GameItem> createGame(GameItem game); // Mutations
  Future<GameItem> updateGame(GameItem game);
  Future<void> deleteGame(GameId gameId);
}

// Current: In-memory implementation
class InMemoryGameRepository implements GameRepository {
  // Streaming implementation with proper error handling
}

// Future: Your persistent storage implementation
class HiveGameRepository implements GameRepository {
  // Your implementation here
}
```

### Styling
- All styling constants in `lib/styles/`
- Group related styles in logical classes
- Use semantic names instead of magic numbers
- **British English** spellings throughout (colour, centre, organisation)

## 🧪 Testing Strategy (Production-Ready)

### **310+ Tests Passing** with Streaming Architecture Support

#### **Core Testing Focus**
- **State Management Tests** (100% coverage) - Provider and business logic
- **Business Logic Tests** - Service layer and domain logic
- **Functional UI Tests** - User interactions that trigger state changes
- **Integration Tests** - State transitions and data integrity

#### **Test Architecture**
```dart
// Streaming-compatible test infrastructure
final container = TestHelpers.createTestContainer();
await TestHelpers.waitForGames(container); // Async data loading

// Tests work with streaming providers
final games = container.read(gameListProvider);
expect(games.length, 6); // Reliable test data
```

#### **What We Test**
- ✅ **State Transitions** - All game status changes
- ✅ **Filtering Logic** - Platform, status, search combinations
- ✅ **Business Rules** - Game creation, updates, validation
- ✅ **Data Integrity** - Referential integrity, timestamp handling
- ✅ **User Interactions** - UI workflows that change state

#### **What We Don't Test** (Following Best Practices)
- ❌ Animation timing and visual effects
- ❌ Pure UI rendering without interactions
- ❌ Layout positioning and styling details

### Running Tests
```bash
# Run all tests (310+ passing)
flutter test

# Run specific test suites
flutter test test/providers/        # State management tests
flutter test test/business_logic/   # Business logic tests
flutter test test/core_functionality/ # Core state tests

# Generate test coverage
flutter test --coverage
```

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

# Generate code (for providers and models)
flutter packages pub run build_runner build

# Run tests to verify setup
flutter test

# Run the app
flutter run
```

### Development Workflow
```bash
# 1. Code quality check
flutter analyze

# 2. Run tests
flutter test

# 3. Generate updated code (if needed)
flutter packages pub run build_runner build

# 4. Run app
flutter run
```

## 🔄 **Ready for Persistent Storage**

The app is **production-ready** with a streaming architecture that will seamlessly integrate with any persistent storage solution:

### **Current State**: In-Memory Repository
- ✅ Streaming data with immediate UI updates
- ✅ Full CRUD operations with error handling
- ✅ All 310+ tests passing
- ✅ Repository pattern abstracts storage implementation

### **Integration Ready**: Your Choice of Storage
```dart
// Easy to swap - just change the provider override
gameRepositoryProvider.overrideWithValue(
  HiveGameRepository(),     // or
  SqliteGameRepository(),   // or
  FirebaseGameRepository(), // or
  YourCustomRepository(),   // Your implementation
);
```

### **Supported Storage Options**
- **SQLite** (flutter_sqflite) - Complex relational queries
- **Hive** - Fast NoSQL local storage
- **Firebase** - Cloud storage with offline sync
- **Shared Preferences** - Simple key-value storage
- **Custom APIs** - Your backend integration

## 📚 Documentation

Each directory contains detailed README files:
- [`lib/models/README.md`](lib/models/README.md) - Data models and entities
- [`lib/styles/README.md`](lib/styles/README.md) - Styling system and guidelines
- [`lib/shared/README.md`](lib/shared/README.md) - Reusable UI components
- [`lib/providers/README.md`](lib/providers/README.md) - **Streaming state management patterns**
- [`lib/services/README.md`](lib/services/README.md) - Business logic architecture
- [`lib/repositories/README.md`](lib/repositories/README.md) - **Repository pattern and data access**

## 🔄 Contributing

1. Follow the established **streaming architecture** patterns
2. Write tests for new functionality (maintain 310+ passing tests)
3. Use the centralised styling system
4. Document new components and patterns
5. Ensure code passes `flutter analyze`
6. **Use British English** spellings (colour, centre, organisation)

### **Quality Gates**
- ✅ All tests must pass (`flutter test`)
- ✅ No lint issues (`flutter analyze`)
- ✅ New features must include tests
- ✅ Streaming providers for state management
- ✅ Repository pattern for data access

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
