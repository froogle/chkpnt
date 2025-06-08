import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';

part 'game_provider.g.dart';

// Sample games data - in a real app, this would come from a repository
final List<GameItem> _sampleGames = [
  GameItem(
    id: GameId.generate(),
    title: 'The Legend of Zelda: Breath of the Wild',
    platform: 'Switch',
    status: GameStatus.playing,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
  GameItem(
    id: GameId.generate(),
    title: 'God of War',
    platform: 'PS5',
    status: GameStatus.playing,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
  GameItem(
    id: GameId.generate(),
    title: 'Cyberpunk 2077',
    platform: 'PC',
    status: GameStatus.completed,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
  GameItem(
    id: GameId.generate(),
    title: 'Red Dead Redemption 2',
    platform: 'Xbox',
    status: GameStatus.completed,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
  GameItem(
    id: GameId.generate(),
    title: 'Elden Ring',
    platform: 'Steam Deck',
    status: GameStatus.backlog,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
  GameItem(
    id: GameId.generate(),
    title: 'Mass Effect Legendary Edition',
    platform: 'PC',
    status: GameStatus.abandoned,
    lastModified: DateTime.now(),
    lastStatusChange: DateTime.now(),
  ),
];

// Main games list provider
@riverpod
class GameList extends _$GameList {
  @override
  List<GameItem> build() {
    return _sampleGames;
  }

  // Add a new game
  void addGame(GameItem game) {
    state = [...state, game];
  }

  /// Convenience method for creating new games without timestamp concerns.
  /// This is the preferred method for UI code to add games as it automatically
  /// handles timestamp generation.
  void createGame({
    required String title,
    required String platform,
    required GameStatus status,
    String? imagePath,
    String? remoteImageUrl,
  }) {
    final game = GameItem.create(
      title: title,
      platform: platform,
      status: status,
      imagePath: imagePath,
      remoteImageUrl: remoteImageUrl,
    );
    addGame(game);
  }

  // Update an existing game
  void updateGame(GameItem updatedGame) {
    state = [
      for (final game in state)
        if (game.id == updatedGame.id)
          updatedGame.copyWith(
            lastModified: DateTime.now(),
            lastStatusChange:
                game.status != updatedGame.status
                    ? DateTime.now()
                    : game.lastStatusChange,
          )
        else
          game,
    ];
  }

  // Remove a game
  void removeGame(GameId gameId) {
    state = state.where((game) => game.id != gameId).toList();
  }

  // Start playing a game (move from backlog to playing)
  void startPlaying(GameId gameId) {
    state = [
      for (final game in state)
        if (game.id == gameId)
          game.copyWith(
            status: GameStatus.playing,
            lastStatusChange: DateTime.now(),
            lastModified: DateTime.now(),
          )
        else
          game,
    ];
  }

  // Mark game as completed
  void markCompleted(GameId gameId) {
    state = [
      for (final game in state)
        if (game.id == gameId)
          game.copyWith(
            status: GameStatus.completed,
            lastStatusChange: DateTime.now(),
            lastModified: DateTime.now(),
          )
        else
          game,
    ];
  }
}

// Provider for games filtered by status
@riverpod
List<GameItem> gamesByStatus(Ref ref, GameStatus status) {
  final games = ref.watch(gameListProvider);
  return games.where((game) => game.status == status).toList();
}

// Provider for games filtered by platform
@riverpod
List<GameItem> gamesByPlatform(Ref ref, String platform) {
  final games = ref.watch(gameListProvider);
  if (platform == 'All') return games;
  return games.where((game) => game.platform == platform).toList();
}

// Provider for games filtered by both status and platform
@riverpod
List<GameItem> filteredGames(Ref ref, GameStatus status, String platform) {
  final games = ref.watch(gameListProvider);
  return games.where((game) {
    final matchesStatus = game.status == status;
    final matchesPlatform = platform == 'All' || game.platform == platform;
    return matchesStatus && matchesPlatform;
  }).toList();
}

// Provider for available platforms
@riverpod
List<String> availablePlatforms(Ref ref) {
  final games = ref.watch(gameListProvider);
  final platforms = games.map((game) => game.platform).toSet().toList();
  platforms.sort();
  return ['All', ...platforms];
}

// Provider for games filtered by search query
@riverpod
List<GameItem> searchFilteredGames(Ref ref, String searchQuery) {
  final games = ref.watch(gameListProvider);
  if (searchQuery.isEmpty) return games;

  return games.where((game) {
    final query = searchQuery.toLowerCase();
    return game.title.toLowerCase().contains(query) ||
        game.platform.toLowerCase().contains(query);
  }).toList();
}

// Provider for games filtered by status, platform, and search
@riverpod
List<GameItem> fullyFilteredGames(
  Ref ref,
  GameStatus status,
  String platform,
  String searchQuery,
) {
  final games = ref.watch(gameListProvider);
  return games.where((game) {
    final matchesStatus = game.status == status;
    final matchesPlatform = platform == 'All' || game.platform == platform;

    bool matchesSearch = true;
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      matchesSearch =
          game.title.toLowerCase().contains(query) ||
          game.platform.toLowerCase().contains(query);
    }

    return matchesStatus && matchesPlatform && matchesSearch;
  }).toList();
}
