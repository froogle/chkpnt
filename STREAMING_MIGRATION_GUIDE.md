# Streaming Architecture Migration Guide

## 🎯 Quick Start: Add Persistent Storage

The ChkPnt app is **production-ready** with a streaming architecture that makes adding persistent storage incredibly simple. This guide shows you how to swap from in-memory to persistent storage in just a few steps.

## 🔄 Current Status

✅ **Streaming architecture implemented**
✅ **Repository pattern ready**
✅ **All 310+ tests passing**
✅ **Production-ready codebase**

**Current:** In-memory storage with sample data
**Target:** Your choice of persistent storage with seamless migration

## 🚀 Implementation Options

### Option 1: SQLite (Recommended for Complex Data)

#### 1. Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

#### 2. Create SQLite Repository
```dart
// lib/repositories/sqlite_game_repository.dart
class SqliteGameRepository implements GameRepository {
  final Database _database;
  final StreamController<List<GameItem>> _gamesController = StreamController.broadcast();

  @override
  Stream<List<GameItem>> watchGames() async* {
    yield await getAllGames();
    await for (final games in _gamesController.stream) {
      yield games;
    }
  }

  @override
  Future<List<GameItem>> getAllGames() async {
    final maps = await _database.query('games', orderBy: 'last_modified DESC');
    return maps.map((map) => GameItem.fromMap(map)).toList();
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    final gameWithTimestamps = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    );

    await _database.insert('games', gameWithTimestamps.toMap());
    _gamesController.add(await getAllGames());
    return gameWithTimestamps;
  }

  // ... implement other methods following the same pattern
}
```

#### 3. Swap Implementation (One Line Change!)
```dart
// lib/providers/game_provider.dart
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  // return InMemoryGameRepository(); // OLD
  return SqliteGameRepository(database);  // NEW
}
```

### Option 2: Hive (Recommended for Simplicity)

#### 1. Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

#### 2. Create Hive Repository
```dart
// lib/repositories/hive_game_repository.dart
class HiveGameRepository implements GameRepository {
  final Box<GameItem> _gamesBox;

  @override
  Stream<List<GameItem>> watchGames() async* {
    yield _gamesBox.values.toList();
    await for (final _ in _gamesBox.watch()) {
      yield _gamesBox.values.toList();
    }
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    final gameWithTimestamps = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    );

    await _gamesBox.put(game.id.value, gameWithTimestamps);
    return gameWithTimestamps;
  }

  // ... implement other methods
}
```

### Option 3: Firebase (Recommended for Cloud Sync)

#### 1. Add Dependencies
```yaml
# pubspec.yaml
dependencies:
  cloud_firestore: ^4.9.1
  firebase_core: ^2.15.1
```

#### 2. Create Firebase Repository
```dart
// lib/repositories/firebase_game_repository.dart
class FirebaseGameRepository implements GameRepository {
  final CollectionReference _gamesCollection;

  @override
  Stream<List<GameItem>> watchGames() {
    return _gamesCollection
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<GameItem> createGame(GameItem game) async {
    final gameWithTimestamps = game.copyWith(
      lastModified: DateTime.now(),
      lastStatusChange: DateTime.now(),
    );

    await _gamesCollection.doc(game.id.value).set(gameWithTimestamps.toMap());
    return gameWithTimestamps;
  }

  // ... implement other methods
}
```

## 🔧 Data Model Requirements

Your `GameItem` model needs serialization methods. If they don't exist, add:

```dart
// lib/models/game_models.dart (if not already present)
extension GameItemSerialization on GameItem {
  Map<String, dynamic> toMap() {
    return {
      'id': id.value,
      'title': title,
      'platform': platform,
      'status': status.index,
      'lastModified': lastModified.millisecondsSinceEpoch,
      'lastStatusChange': lastStatusChange.millisecondsSinceEpoch,
      'imagePath': imagePath,
      'remoteImageUrl': remoteImageUrl,
    };
  }

  static GameItem fromMap(Map<String, dynamic> map) {
    return GameItem(
      id: GameId(map['id']),
      title: map['title'],
      platform: map['platform'],
      status: GameStatus.values[map['status']],
      lastModified: DateTime.fromMillisecondsSinceEpoch(map['lastModified']),
      lastStatusChange: DateTime.fromMillisecondsSinceEpoch(map['lastStatusChange']),
      imagePath: map['imagePath'],
      remoteImageUrl: map['remoteImageUrl'],
    );
  }
}
```

## 🧪 Data Migration

### Preserve Existing Data
If you want to migrate sample data to persistent storage:

```dart
class DataMigrationService {
  static Future<void> migrateSampleData(GameRepository repository) async {
    final sampleGames = InMemoryGameRepository.sampleGames;

    for (final game in sampleGames) {
      try {
        await repository.createGame(game);
      } catch (e) {
        // Handle duplicates or errors
        print('Migration error for ${game.title}: $e');
      }
    }
  }
}

// Call once during app initialization
await DataMigrationService.migrateSampleData(newRepository);
```

## ✅ Verification Checklist

After implementing persistent storage:

1. **Tests Still Pass**
   ```bash
   flutter test  # Should still show 310+ tests passing
   ```

2. **Code Quality**
   ```bash
   flutter analyze  # Should show no issues
   ```

3. **App Functionality**
   - Games persist between app restarts
   - All CRUD operations work correctly
   - Search and filtering still work
   - Status changes are saved
   - UI updates reactively

4. **Performance**
   - App startup is still fast
   - UI remains responsive
   - Stream updates work smoothly

## 🔄 Rollback Plan

If you encounter issues, easily rollback:

```dart
// lib/providers/game_provider.dart
@riverpod
GameRepository gameRepository(GameRepositoryRef ref) {
  return InMemoryGameRepository(); // Rollback to working state
}
```

All tests and functionality return to working state immediately.

## 🚀 Advanced Features

Once basic persistence is working, consider:

### Offline-First with Sync
```dart
class CachedGameRepository implements GameRepository {
  final GameRepository _localRepository;
  final GameRepository _remoteRepository;

  // Local-first with background sync
}
```

### Data Backup
```dart
class BackupService {
  static Future<void> exportData(GameRepository repository) async {
    final games = await repository.getAllGames();
    // Export to file or cloud
  }
}
```

### Indexing for Performance
```sql
-- For SQLite
CREATE INDEX idx_games_status ON games(status);
CREATE INDEX idx_games_platform ON games(platform);
CREATE INDEX idx_games_modified ON games(last_modified);
```

## 📊 Expected Impact

**Zero Breaking Changes:**
- ✅ All existing code continues to work
- ✅ All tests continue to pass
- ✅ UI remains unchanged
- ✅ Business logic unchanged
- ✅ Only storage backend changes

**Immediate Benefits:**
- 🎯 Data persists between app sessions
- 🎯 Production-ready data management
- 🎯 Scalable architecture for future features
- 🎯 Foundation for cloud sync and backup

## 🆘 Need Help?

The streaming architecture is designed to be **failure-resistant**:

1. **Repository Interface**: Ensures all implementations are compatible
2. **Test Coverage**: 310+ tests verify everything works correctly
3. **Provider Abstraction**: UI layer is completely decoupled from storage
4. **Error Handling**: Proper exception handling and recovery

**Bottom Line:** If it implements `GameRepository` and passes the tests, it will work seamlessly with the entire app! 🚀