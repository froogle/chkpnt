# Models Directory

This directory contains all data models and entities used throughout the application.

## 🎮 Game Models

### `game_models.dart`

#### `GameStatus` Enum
Represents the current status of a game in the user's library:

- `playing` - Currently being played
- `completed` - Finished/completed
- `backlog` - Planned to play later
- `abandoned` - Started but stopped playing

#### `GameItem` Class
Represents a game in the user's library:

**Properties:**
- `title` (String) - The game's title
- `platform` (String) - Gaming platform (PS5, Switch, PC, etc.)
- `status` (GameStatus) - Current status of the game
- `progress` (double) - Completion progress (0.0 to 1.0)

**Usage:**
```dart
const game = GameItem(
  title: 'The Legend of Zelda: Breath of the Wild',
  platform: 'Switch',
  status: GameStatus.playing,
  progress: 0.65,
);
```

## 🔄 Future Models

As the app grows, consider adding models for:
- User profiles and preferences
- Game metadata (genre, release date, ratings)
- Achievement and trophy data
- Gaming session tracking
- Wishlist items
- Social features (friends, shared lists)

## 🏗️ Architecture Notes

- Models are pure data classes with no business logic
- All models should be immutable (use `const` constructors)
- Complex business logic should be handled in services or state management
- Models should be serializable for state persistence and API communication