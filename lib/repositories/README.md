# Repositories Directory

This directory contains data access layer implementations for persistent storage and external APIs.

## 🎯 Purpose

Repositories handle data persistence and retrieval, providing a clean interface between business logic and data sources:
- **Data Abstraction** - Hide implementation details from services
- **Multiple Data Sources** - Support local storage, APIs, caching
- **Consistent Interface** - Standardized CRUD operations
- **Error Handling** - Convert storage errors to domain exceptions

## 🗄️ Repository Types

### Game Data Repositories

**`GameRepository`**
```dart
abstract class GameRepository {
  Future<List<GameItem>> getAllGames();
  Future<GameItem?> getGameById(String id);
  Future<List<GameItem>> getGamesByStatus(GameStatus status);
  Future<GameItem> createGame(GameItem game);
  Future<GameItem> updateGame(GameItem game);
  Future<void> deleteGame(String id);
  Stream<List<GameItem>> watchGames();
}
```

**`GameRepositoryImpl`**
- Local database implementation (SQLite/Hive)
- CRUD operations with proper error handling
- Offline-first approach with sync capabilities

**`GameApiRepository`**
- External API integration (IGDB, Steam, etc.)
- Game metadata fetching
- Cover art and screenshots
- Platform-specific data

### User Data Repositories

**`UserPreferencesRepository`**
```dart
abstract class UserPreferencesRepository {
  Future<UserPreferences> getPreferences();
  Future<void> savePreferences(UserPreferences preferences);
  Future<void> clearPreferences();
  Stream<UserPreferences> watchPreferences();
}
```

**`BackupRepository`**
- Data export/import functionality
- Cloud backup integration
- Data synchronization across devices

### Cache Repositories

**`ImageCacheRepository`**
- Game cover art caching
- Screenshot storage
- Offline image availability
- Cache management and cleanup

## 🏗️ Repository Architecture

### Interface Pattern
Define contracts with abstract classes:

```dart
abstract class GameRepository {
  Future<List<GameItem>> getAllGames();
  Future<GameItem> createGame(GameItem game);
  // ... other methods
}

class LocalGameRepository implements GameRepository {
  final Database _database;

  LocalGameRepository(this._database);

  @override
  Future<List<GameItem>> getAllGames() async {
    try {
      final maps = await _database.query('games');
      return maps.map((map) => GameItem.fromMap(map)).toList();
    } catch (e) {
      throw RepositoryException('Failed to load games: $e');
    }
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    try {
      final id = await _database.insert('games', game.toMap());
      return game.copyWith(id: id.toString());
    } catch (e) {
      throw RepositoryException('Failed to create game: $e');
    }
  }
}
```

### Multiple Implementations
Support different data sources:

```dart
// Local storage implementation
class LocalGameRepository implements GameRepository {
  final Database _database;
  // SQLite/Hive implementation
}

// API implementation
class ApiGameRepository implements GameRepository {
  final ApiClient _apiClient;
  // REST API implementation
}

// Cached implementation
class CachedGameRepository implements GameRepository {
  final GameRepository _localRepository;
  final GameRepository _remoteRepository;

  // Cache-first with fallback strategy
}
```

### Error Handling
Convert storage errors to domain exceptions:

```dart
class RepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  RepositoryException(this.message, {this.code, this.originalError});
}

Future<GameItem> createGame(GameItem game) async {
  try {
    // Database operation
    return await _performDatabaseOperation(game);
  } on DatabaseException catch (e) {
    throw RepositoryException(
      'Database error while creating game',
      code: 'DB_ERROR',
      originalError: e,
    );
  } catch (e) {
    throw RepositoryException(
      'Unexpected error while creating game',
      originalError: e,
    );
  }
}
```

## 💾 Data Persistence Strategies

### Local Storage Options

**SQLite (sqflite)**
- Complex relational data
- Advanced queries and joins
- Good performance for large datasets
- SQL expertise required

**Hive**
- Simple key-value storage
- Fast and lightweight
- Type-safe with code generation
- Easy to use and maintain

**Shared Preferences**
- Simple app settings
- User preferences
- Small amounts of data
- Built-in Flutter support

### Data Serialization
```dart
class GameItem {
  // ... properties

  // From/to Map for database storage
  factory GameItem.fromMap(Map<String, dynamic> map) {
    return GameItem(
      id: map['id'],
      title: map['title'],
      platform: map['platform'],
      status: GameStatus.values[map['status']],
      progress: map['progress'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'platform': platform,
      'status': status.index,
      'progress': progress,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  // From/to JSON for API communication
  factory GameItem.fromJson(Map<String, dynamic> json) { /* ... */ }
  Map<String, dynamic> toJson() { /* ... */ }
}
```

## 🔄 Data Flow

```
Service Layer
    ↓ (domain objects)
Repository Interface
    ↓ (maps/serializes)
Repository Implementation
    ↓ (storage operations)
Database/API/Cache
```

## 🧪 Testing Repositories

### Repository Testing
```dart
group('LocalGameRepository', () {
  late Database database;
  late LocalGameRepository repository;

  setUp(() async {
    database = await openInMemoryDatabase();
    repository = LocalGameRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should create game successfully', () async {
    final game = GameItem(title: 'Test Game', platform: 'PC');

    final createdGame = await repository.createGame(game);

    expect(createdGame.id, isNotNull);
    expect(createdGame.title, 'Test Game');
  });

  test('should throw RepositoryException on database error', () async {
    // Test error scenarios
  });
});
```

### Mock Repositories
```dart
class MockGameRepository extends Mock implements GameRepository {}

// In tests
final mockRepository = MockGameRepository();
when(() => mockRepository.getAllGames())
    .thenAnswer((_) async => [testGame1, testGame2]);
```

## 📋 Repository Guidelines

### Design Principles
✅ **Single Responsibility** - One repository per aggregate root
✅ **Interface Segregation** - Small, focused interfaces
✅ **Dependency Inversion** - Depend on abstractions
✅ **Error Handling** - Convert storage errors to domain errors

### Performance
✅ **Lazy Loading** - Load data on demand
✅ **Caching Strategy** - Implement appropriate caching
✅ **Batch Operations** - Support bulk operations where needed
✅ **Connection Pooling** - Reuse database connections

### Data Integrity
✅ **Transactions** - Use transactions for multi-step operations
✅ **Validation** - Validate data before persistence
✅ **Migrations** - Handle schema changes gracefully
✅ **Backup/Restore** - Implement data recovery mechanisms

## 🔄 Future Implementation

Repositories will be implemented progressively:

1. **Local Storage** - Start with simple local persistence
2. **API Integration** - Add external data sources
3. **Caching Layer** - Implement offline-first approach
4. **Sync & Backup** - Add cloud synchronization

## 🛠️ Technology Stack

Planned technologies for different storage needs:
- **SQLite** (sqflite) - Complex relational data
- **Hive** - Simple object storage
- **HTTP** (dio) - API communication
- **Shared Preferences** - App settings
- **Firebase** - Cloud backup and sync