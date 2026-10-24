# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Development Commands

### Core Flutter Commands
```bash
# Install dependencies after checkout
flutter pub get

# Generate code after model/provider changes (required after any Riverpod/Freezed/Drift changes)
dart run build_runner build

# Clean rebuild of generated code
dart run build_runner build --delete-conflicting-outputs

# Run the application
flutter run

# Code analysis (no warnings allowed)
flutter analyze

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Testing Commands
```bash
# Run specific test categories
flutter test test/providers/        # State management tests
flutter test test/repositories/     # Data layer tests  
flutter test test/screens/          # UI component tests
flutter test test/services/         # Business logic tests

# Run single test file
flutter test test/providers/game_provider_test.dart
```

## Architecture Overview

ChkPnt is a production-ready Flutter gaming backlog manager using:

- **State Management**: Riverpod 2.5.1 with streaming providers and Family patterns
- **Database**: Drift 2.18.0 (SQLite) with full persistence and streaming queries
- **Data Models**: Freezed 2.5.2 for immutable data classes
- **UI Framework**: Flutter 3.7.2+ with explicit styling (Android 13 compatibility)

### Key Architecture Patterns

#### Repository Pattern with Streaming
```dart
// Abstract interface for easy backend swapping
abstract class GameRepository {
  Stream<List<GameItem>> watchGames();  // Streaming data
  Future<GameItem> createGame(GameItem game);  // CRUD operations
}

// Current SQLite implementation with Drift
class DriftGameRepository implements GameRepository {
  // Full production implementation with streaming, transactions, migrations
}
```

#### Riverpod Streaming State Management
```dart
// Repository provider - dependency injection
@riverpod
GameRepository gameRepository(Ref ref) => DriftGameRepository();

// Streaming provider - automatic UI updates
@riverpod
Stream<List<GameItem>> gamesStream(Ref ref) {
  return ref.watch(gameRepositoryProvider).watchGames();
}

// State management with CRUD operations
@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() {
    final gamesAsync = ref.watch(gamesStreamProvider);
    return gamesAsync.when(
      data: (games) => games,
      loading: () => [],
      error: (error, stack) => [],
    );
  }
}
```

#### Family Providers for Context-Dependent State
Always use Family providers instead of runtime initialization:

```dart
// Context class with proper equality
class GameEditContext {
  final bool isAddMode;
  final GameItem? game;
  
  @override
  bool operator ==(Object other) => /* proper implementation */;
  @override
  int get hashCode => Object.hash(isAddMode, game);
}

// Family provider eliminates initialization issues
@riverpod
class GameEditState extends _$GameEditState {
  @override
  GameEditFormState build(GameEditContext context) => /* implementation */;
}
```

### Core Data Models

#### GameItem (with Freezed)
```dart
@freezed
class GameItem with _$GameItem {
  const factory GameItem({
    required GameId id,           // UUID-based unique identifier
    required String title,
    required String platform,
    required GameStatus status,   // playing, completed, backlog, etc.
    required DateTime lastModified,
    required DateTime lastStatusChange,
    String? imagePath,           // Local image storage
    String? remoteImageUrl,      // Remote image URLs
  }) = _GameItem;
}

enum GameStatus { playing, completed, backlog, abandoned, wishlist, ordered }
```

## Directory Structure & Widget Organization

### Screen Organization Rules
- **Feature-based screens** in `screens/[feature]/`
- **Screen-specific widgets** in `screens/[feature]/widgets/`  
- **Animations** in `screens/[feature]/widgets/animations/`
- **Truly reusable components** in `shared/widgets/` (used by 2+ screens)

### Current Screen Features
- **Main Dashboard** (`screens/main/`) - Game overview with status sections and quick actions
- **Backlog Management** (`screens/backlog/`) - Advanced sorting and platform-specific sections
- **Wishlist & Orders** (`screens/wishlist/`) - Track desired and incoming games
- **Profile & Statistics** (`screens/profile/`) - FL Chart visualizations and progress tracking
- **Game Editing** (`screens/edit/`) - Full CRUD with image selection and form validation
- **Onboarding** (`screens/onboarding/`) - User onboarding flow with subscription options

### Styling System (Critical for Android 13 Compatibility)

**CRITICAL**: Always use explicit colours - never rely on Material Design defaults due to Android 13 compatibility issues.

```dart
// ❌ FORBIDDEN - causes invisible text on Android 13
Text('Hello', style: Theme.of(context).textTheme.bodyMedium)
Card(child: Text('Hello'))  // No explicit background colour

// ✅ REQUIRED - explicit styling from centralised system
Text('Hello', style: TextStyle(
  fontSize: 16,
  color: AppColors.primaryText,  // Explicit colour required
  fontWeight: FontWeight.w500,
))

Card(
  color: Colors.white,  // Explicit background
  child: Text('Hello', style: TextStyle(color: AppColors.primaryText)),
)
```

Use centralised styling from `lib/styles/`:
```dart
import 'package:chkpnt/styles/game_card_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

Container(
  decoration: GameCardStyles.gameCardDecoration,
  child: Text('Title', style: GameCardStyles.titleTextStyle),
)
```

### Widget Extraction Pattern
Always extract complex build methods to prevent excessive nesting:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(child: _buildContent()),
  );
}

Widget _buildContent() {
  return Column(
    children: [
      _buildHeader(),
      Expanded(child: _buildGamesList()),
      _buildBottomActions(),
    ],
  );
}
```

## Testing Strategy

### Test Structure
```
test/
├── models/              # Data model tests
├── providers/           # State management tests  
├── repositories/        # Data persistence tests
├── services/            # Business logic tests
├── screens/             # Screen and widget tests
├── shared/widgets/      # Reusable component tests
├── test_helpers.dart    # Shared testing utilities
├── core_functionality_test.dart
└── business_logic_test.dart
```

### Testing Requirements
- All new widgets must have corresponding test files
- Use `TestHelpers.createTestContainer()` for Riverpod provider testing
- Test state management with streaming providers
- Verify data persistence operations
- Test UI interactions and user workflows

### Test Implementation Pattern
```dart
testWidgets('GameCard displays correctly', (tester) async {
  final container = TestHelpers.createTestContainer();
  
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: GameCard(game: TestHelpers.createTestGame())),
    ),
  );

  expect(find.byType(GameCard), findsOneWidget);
  container.dispose();
});
```

## Quality Requirements

### Pre-Development Checklist
1. **Flutter Analyze** must pass with no warnings
2. **All tests must pass** before any commit
3. **Code generation** required after Riverpod/Freezed/Drift changes
4. **Manual Android 13 testing** for UI visibility

### Development Standards
- **British English spellings** throughout (colour, centre, organisation)
- **Explicit colours** in all UI components
- **Streaming providers** for all data access
- **Family providers** for context-dependent state
- **Build method extraction** using `_buildXXX()` pattern
- **Comprehensive error handling** with user-friendly messages
- **NO COMMENTS IN CODE** - All code must be self-explanatory; if you feel the need to write a comment, simplify the code instead

### Avoiding Over-Engineering

This codebase has a history of custom machinery that fights normal Android and
Flutter behaviour instead of using it. Before adding any workaround, confirm the
framework does not already solve the problem.

- **Prefer stock Flutter behaviour.** Reach for a platform channel, native code
  or manual state tracking only after the built-in approach has been shown to
  fail. `keyboardDismissBehavior` replacing a hand-rolled keyboard hack is the
  reference example.
- **One mechanism per job.** Layering several fallbacks for the same effect
  hides which one actually works and lets them fight each other.
- **Never bypass framework state.** Driving the platform directly - for example
  hiding the keyboard through `InputMethodManager` - leaves Flutter's own focus
  state untouched, so the framework can simply undo the change. This class of
  workaround tends to cause the bug it was meant to fix.
- **Treat existing workarounds as suspects.** When fixing a bug near one, first
  check whether the workaround is the cause, and remove it if the framework now
  handles the case.
- **When a fix grows, stop and reconsider.** A bug fix that needs new
  abstractions is usually solving the wrong problem.

The explicit-colour rules above are a deliberate exception: they address a real
Android 13 rendering issue, not imagined complexity.

### Forbidden Patterns
- `Theme.of(context)` usage for colours or text styles
- Runtime provider initialization in widget lifecycle
- Magic numbers - use named constants from styles
- Inline styling - use centralised style classes
- Missing test coverage for new functionality

## Data Persistence

### Current SQLite Implementation
- **Full database persistence** with Drift ORM
- **Streaming queries** with automatic UI updates
- **ACID transactions** for data integrity
- **Database migrations** for schema evolution
- **Backup and restore** with JSON export/import

### Repository Usage
```dart
// All data operations go through repository
final repository = ref.read(gameRepositoryProvider);

// Create game with automatic timestamps
final newGame = GameItem.create(
  title: 'Elden Ring',
  platform: 'PS5', 
  status: GameStatus.backlog,
);
await repository.createGame(newGame);

// Streaming data automatically updates UI
final games = ref.watch(gameListProvider);
```

This architecture provides production-ready persistence, scalable state management, and comprehensive testing for a Flutter gaming backlog application.

## Agent skills

### Issue tracker

Issues live as local markdown files under `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default triage roles (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`), recorded as a `Status:` line in each issue file. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
