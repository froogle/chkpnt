# ChkPnt - Gaming Backlog Manager

A Flutter application for managing your gaming backlog with progress tracking, platform organisation, and wishlist management.

## 🏗️ Project Architecture

This project follows a **clean architecture pattern** with **streaming-based state management** using **Riverpod** and **persistent SQLite storage** via **Drift**:

```
lib/
├── models/           # Data models with Freezed immutability
│   ├── game_models.dart
│   └── README.md
├── providers/        # Riverpod streaming state management  
│   ├── game_provider.dart
│   ├── ui_state_provider.dart
│   └── README.md
├── repositories/     # Data access layer with Drift/SQLite
│   ├── game_repository.dart        # Abstract interface
│   ├── drift_game_repository.dart  # SQLite implementation
│   └── README.md
├── services/         # Business logic and domain services
│   ├── game_actions_service.dart
│   ├── game_image_service.dart
│   ├── backup_service.dart
│   ├── chart_data_service.dart
│   ├── storage_service.dart
│   └── README.md
├── screens/          # Feature-based screen organisation
│   ├── main/         # Main dashboard
│   ├── backlog/      # Backlog management
│   ├── wishlist/     # Wishlist and ordered games
│   ├── profile/      # Statistics and visualisations
│   ├── edit/         # Game editing interface
│   ├── onboarding/   # User onboarding flow
│   └── splash/       # Splash screen
├── shared/           # Truly reusable UI components
│   └── widgets/      # Components used by 2+ screens
│       ├── cards/    # Game cards and display components
│       ├── inputs/   # Form inputs and search controls
│       ├── buttons/  # Interactive elements and badges
│       └── layout/   # Layout helpers and containers
├── styles/           # Centralised styling and themes
│   ├── styles.dart
│   └── README.md
├── utils/            # Utility functions
└── main.dart
```

## 📋 Architecture Layers

### 🎨 **Presentation Layer**
- **`screens/`** - Feature-based full-screen widgets with screen-specific components
- **`shared/widgets/`** - Truly reusable UI components (used by 2+ screens)
- **`styles/`** - Centralised styling system with semantic naming

### 🔄 **State Management Layer (Riverpod + Streaming)**
- **`providers/`** - Riverpod providers with **streaming data sources**
- **Reactive state updates** with automatic UI rebuilds
- **AsyncValue management** with proper loading and error states
- **Repository integration** for persistent storage

### 🧠 **Business Logic Layer**
- **`services/`** - Pure business logic and domain rules
- Platform-agnostic and extensively tested
- **Game actions**, **image handling**, **backup operations**
- **Chart data processing** for statistics

### 💾 **Data Access Layer (Repository Pattern + Drift)**
- **`repositories/`** - **Drift-based SQLite storage** with streaming capabilities
- **`models/`** - Immutable data structures with Freezed
- **Abstract interfaces** for easy storage backend swapping
- **Currently**: SQLite with Drift ORM providing full persistence
- **Ready for**: Additional backends (Firebase, Hive, etc.)

## 🎮 Features

### ✅ **Current Features (Production-Ready)**
- ✅ **Full SQLite persistence** with Drift ORM
- ✅ **Streaming reactive state management** with automatic UI updates
- ✅ **Complete game management** with multiple screens:
  - 🏠 **Main Dashboard** - Game overview and quick actions
  - 📚 **Backlog Management** - Advanced sorting and filtering
  - 🎯 **Wishlist & Orders** - Track desired and incoming games
  - 📊 **Profile & Statistics** - Visual progress tracking with charts
  - ✏️ **Game Editing** - Full CRUD operations with image support
- ✅ **Advanced filtering** by status, platform, and search
- ✅ **Image management** with local and remote image support
- ✅ **Responsive design** for portrait and landscape orientations
- ✅ **Onboarding flow** with subscription options
- ✅ **Modern UI design** with retro-gaming inspired themes
- ✅ **Comprehensive testing** with extensive test coverage
- ✅ **Data backup and export** capabilities

### 🔄 **Planned Features**
- 🔄 External API integration (Steam, PlayStation, etc.)
- 🔄 Cloud synchronisation and backup
- 🔄 Achievement and trophy tracking
- 🔄 Social features and shared lists
- 🔄 Advanced analytics and insights
- 🔄 Notification system for game releases
- 🔄 Affiliate purchase integration for wishlist games

## 🏗️ Development Guidelines

### Widget Architecture
- **Feature-based screens** in `screens/[feature]/`
- **Screen-specific widgets** in `screens/[feature]/widgets/`
- **Truly reusable components** in `shared/widgets/`
- **Extract complex build methods** using `_buildXXX()` pattern
- **Use centralised styling** from `lib/styles/`

### State Management (Riverpod + Streaming)
- **Streaming providers** for all data sources with automatic updates
- **Repository pattern** with abstract interfaces for easy backend swapping
- **AsyncValue handling** throughout with proper loading/error states
- **Dependency injection** via Riverpod providers
- **Comprehensive error handling** with user-friendly feedback

### Repository Pattern (Production Implementation)
```dart
// Abstract interface - easy to swap implementations
abstract class GameRepository {
  Stream<List<GameItem>> watchGames();        // Streaming data
  Future<List<GameItem>> getAllGames();       // One-time access
  Future<GameItem> createGame(GameItem game); // CRUD operations
  Future<GameItem> updateGame(GameItem game);
  Future<void> deleteGame(GameId gameId);
  // ... plus search, filtering, backup operations
}

// Current: Drift SQLite implementation (production-ready)
class DriftGameRepository implements GameRepository {
  // Full SQLite implementation with streaming, transactions, migrations
}

// Future: Additional implementations as needed
class FirebaseGameRepository implements GameRepository {
  // Cloud storage with offline sync
}
```

### Data Models (Freezed + Immutability)
```dart
@freezed
class GameItem with _$GameItem {
  const factory GameItem({
    required GameId id,
    required String title,
    required String platform,
    required GameStatus status,
    required DateTime lastModified,
    required DateTime lastStatusChange,
    String? imagePath,
    String? remoteImageUrl,
  }) = _GameItem;
  
  factory GameItem.fromJson(Map<String, dynamic> json) => _$GameItemFromJson(json);
}
```

## 🧪 Testing Strategy (Production-Ready)

### **Comprehensive Test Coverage**

#### **Core Testing Architecture**
- **Test Helpers** (`test_helpers.dart`) - Shared testing utilities and container setup
- **Business Logic Tests** - Service layer and domain logic validation
- **Core Functionality Tests** - State management and data flow verification
- **Screen-specific Tests** - UI interactions and component behaviour
- **Repository Tests** - Data persistence and streaming functionality

#### **Testing Infrastructure**
```dart
// Streaming-compatible test infrastructure
final container = TestHelpers.createTestContainer();
await TestHelpers.waitForAsyncData(container);

// Tests work with actual Riverpod providers
final games = container.read(gameListProvider);
expect(games.length, greaterThan(0));
```

#### **What We Test**
- ✅ **State transitions** - All game status changes and UI updates
- ✅ **Data persistence** - SQLite operations and streaming updates
- ✅ **Business rules** - Game creation, validation, and constraints
- ✅ **Filtering logic** - Platform, status, and search combinations
- ✅ **User interactions** - Complete user workflows
- ✅ **Error handling** - Network failures, data corruption, edge cases

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test categories
flutter test test/providers/        # State management
flutter test test/repositories/     # Data layer
flutter test test/screens/          # UI components
flutter test test/services/         # Business logic
```

## 🚧 Feature Flags

Feature flags are located in `lib/config/feature_flags.dart`:

### `kPaywallEnabled` (default: `true`)

Controls whether the paywall/subscription system is active:

- **`true`** (default): Paywall is enabled. Users can add up to 10 games for free. Adding game #11 or beyond requires a subscription.
- **`false`**: Paywall is disabled. All features are unlocked with no game limits. Useful for development and testing.

```dart
// lib/config/feature_flags.dart
const bool kPaywallEnabled = true;  // Set to false to disable paywall
const int kMaxFreeGames = 10;       // Number of free games before paywall
```

### How the Paywall Works

1. **App Start**: If `kPaywallEnabled` is true, the app checks subscription status and caches the result
2. **Adding Games**: Users can add up to `kMaxFreeGames` (10) games without a subscription
3. **Paywall Trigger**: When trying to add game #11+, if no active subscription exists, the paywall modal appears
4. **Expired Subscriptions**: Users with expired subscriptions retain access to existing games but cannot add more beyond the free limit
5. **Fallback**: If subscription check fails (e.g., network error), the last cached status is used

### For Testers

To test without the paywall, change the flag in `lib/config/feature_flags.dart`:

```dart
const bool kPaywallEnabled = false;
```

Then rebuild the app. The Profile screen will show "Premium (Dev Mode)" to indicate the paywall is disabled.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2 or later
- Dart SDK (latest stable)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation
```bash
# Clone the repository  
git clone <repository-url>
cd chkpnt

# Install dependencies
flutter pub get

# Generate code (Riverpod, Freezed, Drift)
dart run build_runner build

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

# 3. Regenerate code after model/provider changes
dart run build_runner build

# 4. Run with hot reload for development
flutter run
```

## 🗄️ **Persistent Storage (Production-Ready)**

The app uses **Drift** (SQLite) for full data persistence with:

### **Current Implementation**
- ✅ **Full SQLite database** with proper schema management
- ✅ **Streaming queries** with automatic UI updates
- ✅ **ACID transactions** for data integrity
- ✅ **Database migrations** for schema evolution
- ✅ **Backup and restore** functionality
- ✅ **Query optimisation** with proper indexing

### **Storage Features**
```dart
// All data persists automatically
await ref.read(gameListProvider.notifier).createGame(
  title: 'Elden Ring',
  platform: 'PS5',
  status: GameStatus.backlog,
);

// Streams automatically update UI when data changes
final games = ref.watch(gameListProvider); // Always up-to-date

// Advanced querying with filtering
final filteredGames = ref.watch(fullyFilteredGamesProvider(
  GameStatus.playing, 
  'Switch', 
  'zelda'
));
```

### **Backup & Export**
```dart
// Export all data to JSON
final backupJson = await repository.exportDatabaseToJson();

// Import from backup
await repository.importFromJson(backupJson);

// Get database file path for manual backup
final dbPath = await repository.getDatabasePath();
```

## 📱 **Screen Features**

### 🏠 **Main Dashboard**
- Game overview with status-based sections
- Quick actions (play, complete, edit)
- Search and platform filtering
- Animated transitions and interactions

### 📚 **Backlog Management**
- Advanced sorting options (alphabetical, date added, platform)
- Platform-specific sections with expansion controls
- Bulk operations and batch editing
- Smart filtering and search

### 🎯 **Wishlist & Orders**
- Track desired games and pre-orders
- Price tracking integration (planned)
- Release date management
- Platform-specific organisation

### 📊 **Profile & Statistics**  
- Visual progress charts with FL Chart
- Gaming statistics and insights
- Progress tracking over time
- Achievement-style milestones

### ✏️ **Game Editing**
- Full CRUD operations with form validation
- Image selection (camera, gallery, remote URL)
- Platform management with custom options
- Animated form transitions

## 📚 Documentation

Each directory contains detailed README files:
- [`lib/models/README.md`](lib/models/README.md) - Data models and entities
- [`lib/providers/README.md`](lib/providers/README.md) - Riverpod state management patterns
- [`lib/repositories/README.md`](lib/repositories/README.md) - Repository pattern and data access
- [`lib/services/README.md`](lib/services/README.md) - Business logic architecture
- [`lib/styles/README.md`](lib/styles/README.md) - Styling system and guidelines
- [`lib/shared/widgets/inputs/README.md`](lib/shared/widgets/inputs/README.md) - Reusable input components
- [`test/README.md`](test/README.md) - Testing architecture and guidelines

## 🔄 Contributing

### **Development Standards**
1. Follow the **streaming architecture** patterns with Riverpod
2. Write tests for new functionality (maintain comprehensive coverage)
3. Use the **centralised styling system** from `lib/styles/`
4. Follow **screen-based widget organisation** principles
5. Ensure code passes `flutter analyze` with no warnings
6. **Use British English** spellings (colour, centre, organisation)

### **Quality Gates**
- ✅ All tests must pass (`flutter test`)
- ✅ No analysis issues (`flutter analyze`)
- ✅ New features must include comprehensive tests
- ✅ Streaming providers for all state management
- ✅ Repository pattern for data access
- ✅ Proper error handling throughout

### **Adding New Features**
1. **Create screen-specific widgets** in `screens/[feature]/widgets/`
2. **Promote to shared** only when used by 2+ screens
3. **Add Riverpod providers** for state management
4. **Write comprehensive tests** for all new functionality
5. **Update documentation** as needed

## 🔧 **Technical Stack**

### **State Management**
- **Riverpod 2.5.1** - Compile-safe state management
- **Riverpod Generator** - Code generation for providers
- **AsyncValue handling** - Proper loading/error states

### **Data Persistence**
- **Drift 2.18.0** - Type-safe SQLite ORM
- **SQLite3** - Fast, reliable local database
- **Stream-based queries** - Reactive data updates

### **UI Framework**
- **Flutter 3.7.2+** - Modern cross-platform UI
- **Material Design 3** - Latest design system
- **Responsive layouts** - Portrait/landscape support

### **Data Models**
- **Freezed 2.5.2** - Immutable data classes
- **JSON serialisation** - API-ready data structures
- **Type safety** - Compile-time error prevention

### **Developer Experience**
- **Build Runner** - Code generation automation
- **Hot reload** - Fast development iteration
- **Comprehensive testing** - Reliable development workflow


This project is (c)2025 Peter Wright

---

**Built with 💙 using Flutter, Riverpod, and Drift**
