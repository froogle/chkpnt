# Services Directory

This directory contains business logic and domain services that handle core application functionality.

## 🎯 Purpose

Services contain pure business logic that is:
- **Independent of UI** - No Flutter widgets or BuildContext
- **Testable** - Easy to unit test in isolation
- **Reusable** - Can be used across multiple providers/screens
- **Single Responsibility** - Each service handles one domain

## 🧩 Service Types

### Game Management Services
Future services for game-related functionality:

**`GameService`**
- Game CRUD operations
- Progress calculations
- Status transitions
- Game validation logic

**`GameSearchService`**
- Game database searches
- Platform filtering
- Recommendation algorithms
- Search result ranking

**`GameImportService`**
- Import from external APIs (Steam, PlayStation, etc.)
- Game metadata enrichment
- Duplicate detection and merging

### User & Preferences Services

**`UserPreferencesService`**
- App settings and configurations
- Theme preferences
- Notification settings
- Export/import user data

**`AnalyticsService`**
- Usage tracking and analytics
- Performance metrics
- User behavior insights

### External Integration Services

**`ApiService`**
- HTTP client wrapper
- API error handling
- Request/response logging
- Authentication tokens

**`NotificationService`**
- Local notifications
- Push notifications
- Reminder scheduling

## 🏗️ Architecture Guidelines

### Service Structure
```dart
abstract class GameService {
  // Define interface/contract
  Future<List<GameItem>> getGamesByStatus(GameStatus status);
  Future<void> updateGameStatus(String gameId, GameStatus newStatus);
  Future<double> calculateProgress(String gameId);
}

class GameServiceImpl implements GameService {
  final GameRepository _repository;

  GameServiceImpl(this._repository);

  @override
  Future<List<GameItem>> getGamesByStatus(GameStatus status) async {
    // Business logic here
    final games = await _repository.getGamesByStatus(status);
    return _sortGamesByRecentActivity(games);
  }

  // Private helper methods for business logic
  List<GameItem> _sortGamesByRecentActivity(List<GameItem> games) {
    // Implementation
  }
}
```

### Dependencies
- Services depend on **repositories** for data access
- Services are **injected into providers** for state management
- Services should **not depend on other services** directly
- Use dependency injection for loose coupling

### Error Handling
```dart
class GameServiceException implements Exception {
  final String message;
  final String? code;

  GameServiceException(this.message, {this.code});
}

// In service methods
Future<GameItem> updateGame(GameItem game) async {
  try {
    final updatedGame = await _repository.updateGame(game);
    return updatedGame;
  } catch (e) {
    throw GameServiceException('Failed to update game: $e');
  }
}
```

## 🔄 Future Implementation

Services will be implemented as the app grows:

1. **Start Simple** - Begin with basic CRUD operations
2. **Add Business Logic** - Implement game progress tracking
3. **External APIs** - Integrate with gaming platforms
4. **Advanced Features** - Add recommendations, analytics

## 🧪 Testing

Services should be thoroughly unit tested:
- Mock repository dependencies
- Test business logic edge cases
- Verify error handling
- Test async operations

## 📋 Best Practices

✅ **Pure Functions** - Services should be stateless where possible
✅ **Async/Await** - Use proper async patterns
✅ **Error Boundaries** - Handle and wrap exceptions appropriately
✅ **Single Responsibility** - Each service has one clear purpose
✅ **Interface Segregation** - Define clear contracts with abstract classes