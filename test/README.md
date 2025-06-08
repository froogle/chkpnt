# Testing Strategy - Focused on State Management and Business Logic

## 🎯 Core Testing Philosophy

This project prioritises testing **state management** and **business logic** over UI animations and visual details. The testing strategy focuses on:

1. **State Transitions** - Game status changes, data updates
2. **Business Logic** - Filtering, searching, game management
3. **Core Functionality** - User interactions that trigger state changes
4. **Data Integrity** - Consistency and referential integrity

## 📁 Test Structure

### Core Tests (Priority 1)
- `test/core_functionality_test.dart` - Pure state management testing
- `test/business_logic_test.dart` - Service layer and business logic
- `test/providers/` - Provider state management
- `test/services/` - Business logic services
- `test/models/` - Data model behaviour

### Functional UI Tests (Priority 2)
- `test/screens/main/widgets/game_detail_sheet_test.dart` - Status change workflows
- `test/shared/widgets/cards/` - Card interaction and callback testing
- Tests that verify UI triggers correct state changes

### Removed Tests
- ❌ Animation tests - Removed to focus on core functionality
- ❌ Pure UI rendering tests - Minimised in favour of state testing
- ❌ Async timing tests - Simplified to focus on state outcomes

## 🧪 Test Categories

### 1. State Management Tests (`core_functionality_test.dart`)

**Focus**: Pure state transitions without UI dependencies

```dart
test('should transition game from backlog to playing', () {
  // Create game, change status, verify state change
  // No UI components involved
});
```

**Coverage**:
- Game state transitions (backlog → playing → completed)
- Filtering logic (platform, status, search)
- Game creation and management
- Data integrity and consistency

### 2. Business Logic Tests (`business_logic_test.dart`)

**Focus**: Service layer behaviour and complex business rules

```dart
test('should update section expansion based on filters', () {
  // Test GameActionsService logic
  // Verify business rules are applied correctly
});
```

**Coverage**:
- GameActionsService functionality
- UI state management (section expansion, filters)
- Filter integration logic
- Data consistency across state changes

### 3. Provider Tests (`test/providers/`)

**Focus**: Riverpod provider behaviour and state management

**Coverage**:
- Game filtering providers
- UI state providers
- Provider composition and dependencies
- State persistence and updates

### 4. Service Tests (`test/services/`)

**Focus**: Business logic services and domain operations

**Coverage**:
- Game actions and operations
- Image handling services
- Business rule enforcement

### 5. Model Tests (`test/models/`)

**Focus**: Data model behaviour and validation

**Coverage**:
- Game model creation and updates
- Timestamp handling
- Data validation and constraints

### 6. Functional UI Tests (Selected)

**Focus**: UI interactions that trigger state changes

**Criteria for inclusion**:
- ✅ Tests user interactions (taps, form submissions)
- ✅ Verifies state changes occur correctly
- ✅ Tests callback functionality
- ✅ Validates business logic integration
- ❌ Avoids pure visual/layout testing
- ❌ Avoids animation timing tests

## 🎯 Testing Principles

### What We Test
1. **State Transitions**: Game status changes, filter updates
2. **Business Logic**: Complex filtering, search, game management
3. **User Interactions**: Callbacks, form submissions, navigation triggers
4. **Data Integrity**: Consistency, validation, referential integrity
5. **Integration**: Provider-service-model interactions

### What We Don't Test
1. **Animations**: Timing, visual effects, transitions
2. **Pure UI Layout**: Positioning, styling, visual appearance
3. **Widget Rendering**: Unless it affects functionality
4. **Async Timing**: Focus on end state, not timing details

### Test Quality Guidelines

#### ✅ Good Tests
```dart
test('should filter games by status correctly', () {
  // Add test data
  container.read(gameListProvider.notifier).createGame(/*...*/);

  // Test filtering logic
  final playingGames = container.read(gamesByStatusProvider(GameStatus.playing));

  // Verify results
  expect(playingGames.every((g) => g.status == GameStatus.playing), true);
});
```

#### ❌ Avoid
```dart
testWidgets('should animate smoothly', (tester) async {
  // Animation timing tests
  await tester.pump(Duration(milliseconds: 100));
  // Visual effect verification
});
```

## 🚀 Running Tests

### Run Core Tests
```bash
# State management tests
flutter test test/core_functionality_test.dart

# Business logic tests
flutter test test/business_logic_test.dart

# All provider tests
flutter test test/providers/

# All service tests
flutter test test/services/
```

### Run All Tests
```bash
flutter test
```

### Test Coverage
```bash
flutter test --coverage
```

## 📊 Test Coverage Goals

- **Providers**: 100% - All state management logic
- **Services**: 100% - All business logic
- **Models**: 95% - Core data behaviour
- **Core Functionality**: 100% - All state transitions
- **UI Widgets**: 70% - Focus on interaction, not rendering

## 🔄 Maintenance

### Adding New Features
1. **Start with state tests** - Test the core logic first
2. **Add business logic tests** - Test service layer behaviour
3. **Add functional UI tests** - Only for user interactions
4. **Avoid animation tests** - Focus on state outcomes

### Refactoring Guidelines
- Maintain test coverage for state management
- Update business logic tests when rules change
- Keep UI tests minimal and focused on functionality
- Remove tests that don't add value to core functionality

This testing strategy ensures robust, maintainable tests that focus on what matters most: **reliable state management and correct business logic**.