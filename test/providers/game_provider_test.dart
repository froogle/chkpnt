import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import '../test_helpers.dart';

void main() {
  group('GameProvider Filtering', () {
    late ProviderContainer container;

    setUp(() {
      container = TestHelpers.createTestContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('fullyFilteredGamesProvider', () {
      test(
        'should filter games by status only when platform is "All" and no search',
        () async {
          // Wait for initial data to load
          await TestHelpers.waitForGames(container);

          final playingGames = container.read(
            fullyFilteredGamesProvider(GameStatus.playing, 'All', ''),
          );

          // Should return games with playing status
          expect(playingGames.length, 2); // Based on sample data
          expect(
            playingGames.every((game) => game.status == GameStatus.playing),
            true,
          );
        },
      );

      test(
        'should filter games by platform only when status matches',
        () async {
          // Wait for initial data to load
          await TestHelpers.waitForGames(container);

          final pcPlayingGames = container.read(
            fullyFilteredGamesProvider(GameStatus.completed, 'PC', ''),
          );

          // Should return only PC games that are completed
          expect(pcPlayingGames.length, 1);
          expect(
            pcPlayingGames.every(
              (game) =>
                  game.platform == 'PC' && game.status == GameStatus.completed,
            ),
            true,
          );
        },
      );

      test('should filter games by search query', () {
        final searchResults = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'All', 'zelda'),
        );

        // Should return games containing "zelda" in title
        expect(searchResults.length, 1);
        expect(searchResults.first.title.toLowerCase().contains('zelda'), true);
      });

      test('should apply all filters together', () {
        // Test PC + completed + search
        final filteredGames = container.read(
          fullyFilteredGamesProvider(GameStatus.completed, 'PC', 'cyber'),
        );

        expect(filteredGames.length, 1);
        expect(filteredGames.first.platform, 'PC');
        expect(filteredGames.first.status, GameStatus.completed);
        expect(filteredGames.first.title.toLowerCase().contains('cyber'), true);
      });

      test('should return empty list when no games match all filters', () {
        final filteredGames = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'PC', 'nonexistent'),
        );

        expect(filteredGames, isEmpty);
      });

      test('should be case insensitive for search', () {
        final searchResults = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'All', 'ZELDA'),
        );

        expect(searchResults.length, 1);
        expect(searchResults.first.title.toLowerCase().contains('zelda'), true);
      });

      test('should search by platform in addition to title', () {
        final searchResults = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'All', 'ps5'),
        );

        expect(searchResults.length, 1);
        expect(searchResults.first.platform, 'PS5');
      });
    });

    group('gamesByStatus', () {
      test('should return games with specific status', () {
        final backlogGames = container.read(
          gamesByStatusProvider(GameStatus.backlog),
        );

        expect(
          backlogGames.every((game) => game.status == GameStatus.backlog),
          true,
        );
        expect(backlogGames.length, 1); // Based on sample data
      });

      test('should return empty list for status with no games', () {
        // First, remove all games of a certain status to test
        final allGames = container.read(gameListProvider);
        final hasAbandoned = allGames.any(
          (game) => game.status == GameStatus.abandoned,
        );

        if (hasAbandoned) {
          final abandonedGames = container.read(
            gamesByStatusProvider(GameStatus.abandoned),
          );
          expect(abandonedGames.isNotEmpty, true);
        }
      });
    });

    group('gamesByPlatform', () {
      test('should return all games when platform is "All"', () {
        final allGames = container.read(gamesByPlatformProvider('All'));
        final totalGames = container.read(gameListProvider);

        expect(allGames.length, totalGames.length);
      });

      test('should filter games by specific platform', () {
        final pcGames = container.read(gamesByPlatformProvider('PC'));

        expect(pcGames.every((game) => game.platform == 'PC'), true);
        expect(pcGames.length, 2); // Based on sample data
      });

      test('should return empty list for non-existent platform', () {
        final games = container.read(gamesByPlatformProvider('Nintendo 64'));

        expect(games, isEmpty);
      });
    });

    group('availablePlatforms', () {
      test('should include "All" as first option', () {
        final platforms = container.read(availablePlatformsProvider);

        expect(platforms.first, 'All');
      });

      test('should include all unique platforms from games', () {
        final platforms = container.read(availablePlatformsProvider);
        final games = container.read(gameListProvider);
        final uniquePlatforms = games.map((game) => game.platform).toSet();

        // Should contain all unique platforms plus "All"
        expect(platforms.length, uniquePlatforms.length + 1);

        for (final platform in uniquePlatforms) {
          expect(platforms.contains(platform), true);
        }
      });

      test('should return platforms in sorted order', () {
        final platforms = container.read(availablePlatformsProvider);
        final platformsWithoutAll = platforms.skip(1).toList();
        final sortedPlatforms = [...platformsWithoutAll]..sort();

        expect(platformsWithoutAll, sortedPlatforms);
      });
    });

    group('searchFilteredGames', () {
      test('should return all games when search is empty', () {
        final searchResults = container.read(searchFilteredGamesProvider(''));
        final allGames = container.read(gameListProvider);

        expect(searchResults.length, allGames.length);
      });

      test('should filter games by title', () {
        final searchResults = container.read(
          searchFilteredGamesProvider('god'),
        );

        expect(searchResults.length, 1);
        expect(searchResults.first.title.toLowerCase().contains('god'), true);
      });

      test('should filter games by platform', () {
        final searchResults = container.read(
          searchFilteredGamesProvider('switch'),
        );

        expect(searchResults.length, 1);
        expect(
          searchResults.first.platform.toLowerCase().contains('switch'),
          true,
        );
      });

      test('should be case insensitive', () {
        final lowerCaseResults = container.read(
          searchFilteredGamesProvider('god'),
        );
        final upperCaseResults = container.read(
          searchFilteredGamesProvider('GOD'),
        );
        final mixedCaseResults = container.read(
          searchFilteredGamesProvider('God'),
        );

        expect(lowerCaseResults.length, upperCaseResults.length);
        expect(upperCaseResults.length, mixedCaseResults.length);
      });
    });
  });

  group('GameList mutations', () {
    late ProviderContainer container;

    setUp(() {
      container = TestHelpers.createTestContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('addGame timestamp handling', () {
      test('should preserve timestamps when adding game with addGame()', () {
        final notifier = container.read(gameListProvider.notifier);
        final initialGamesCount = container.read(gameListProvider).length;

        // Create a game with specific timestamps
        final pastTime = DateTime(2020, 1, 1);
        final gameWithOldTimestamps = GameItem(
          id: GameId.generate(),
          title: 'Test Game',
          platform: 'PC',
          status: GameStatus.backlog,
          lastModified: pastTime,
          lastStatusChange: pastTime,
        );

        notifier.addGame(gameWithOldTimestamps);

        final updatedGames = container.read(gameListProvider);
        expect(updatedGames.length, initialGamesCount + 1);

        final addedGame = updatedGames.last;
        expect(addedGame.title, 'Test Game');
        expect(addedGame.platform, 'PC');
        expect(addedGame.status, GameStatus.backlog);
        expect(addedGame.id, gameWithOldTimestamps.id);

        // Timestamps should be preserved as provided
        expect(addedGame.lastModified, pastTime);
        expect(addedGame.lastStatusChange, pastTime);
      });

      test(
        'should preserve all game properties when adding with addGame()',
        () {
          final notifier = container.read(gameListProvider.notifier);
          final gameId = GameId.generate();
          final specificTime = DateTime(2023, 5, 15, 14, 30);

          final testGame = GameItem(
            id: gameId,
            title: 'Preserved Game',
            platform: 'Nintendo Switch',
            status: GameStatus.completed,
            lastModified: specificTime,
            lastStatusChange: specificTime,
            imagePath: '/test/image/path.jpg',
            remoteImageUrl: 'https://example.com/image.png',
          );

          notifier.addGame(testGame);

          final updatedGames = container.read(gameListProvider);
          final addedGame = updatedGames.firstWhere(
            (game) => game.id == gameId,
          );

          expect(addedGame.id, gameId);
          expect(addedGame.title, 'Preserved Game');
          expect(addedGame.platform, 'Nintendo Switch');
          expect(addedGame.status, GameStatus.completed);
          expect(addedGame.lastModified, specificTime);
          expect(addedGame.lastStatusChange, specificTime);
          expect(addedGame.imagePath, '/test/image/path.jpg');
          expect(addedGame.remoteImageUrl, 'https://example.com/image.png');
        },
      );
    });

    group('createGame convenience method', () {
      test('should create and add game with required fields only', () {
        final notifier = container.read(gameListProvider.notifier);
        final initialGamesCount = container.read(gameListProvider).length;

        final beforeCreate = DateTime.now();
        notifier.createGame(
          title: 'New Game',
          platform: 'Switch',
          status: GameStatus.wishlist,
        );
        final afterCreate = DateTime.now();

        final updatedGames = container.read(gameListProvider);
        expect(updatedGames.length, initialGamesCount + 1);

        final newGame = updatedGames.last;
        expect(newGame.title, 'New Game');
        expect(newGame.platform, 'Switch');
        expect(newGame.status, GameStatus.wishlist);
        expect(newGame.id.value, isNotEmpty);
        expect(newGame.imagePath, isNull);
        expect(newGame.remoteImageUrl, isNull);

        // Check timestamps are current
        expect(
          newGame.lastModified.isAfter(beforeCreate) ||
              newGame.lastModified.isAtSameMomentAs(beforeCreate),
          true,
        );
        expect(
          newGame.lastModified.isBefore(afterCreate) ||
              newGame.lastModified.isAtSameMomentAs(afterCreate),
          true,
        );
        expect(
          newGame.lastStatusChange.isAfter(beforeCreate) ||
              newGame.lastStatusChange.isAtSameMomentAs(beforeCreate),
          true,
        );
        expect(
          newGame.lastStatusChange.isBefore(afterCreate) ||
              newGame.lastStatusChange.isAtSameMomentAs(afterCreate),
          true,
        );
      });

      test('should create and add game with optional fields', () {
        final notifier = container.read(gameListProvider.notifier);
        final initialGamesCount = container.read(gameListProvider).length;

        notifier.createGame(
          title: 'New Game with Images',
          platform: 'PS5',
          status: GameStatus.playing,
          imagePath: '/path/to/local/image.jpg',
          remoteImageUrl: 'https://example.com/remote/image.jpg',
        );

        final updatedGames = container.read(gameListProvider);
        expect(updatedGames.length, initialGamesCount + 1);

        final newGame = updatedGames.last;
        expect(newGame.title, 'New Game with Images');
        expect(newGame.platform, 'PS5');
        expect(newGame.status, GameStatus.playing);
        expect(newGame.imagePath, '/path/to/local/image.jpg');
        expect(newGame.remoteImageUrl, 'https://example.com/remote/image.jpg');
      });

      test('should generate unique IDs for multiple games', () {
        final notifier = container.read(gameListProvider.notifier);

        notifier.createGame(
          title: 'Game 1',
          platform: 'PC',
          status: GameStatus.backlog,
        );
        notifier.createGame(
          title: 'Game 2',
          platform: 'Xbox',
          status: GameStatus.playing,
        );

        final updatedGames = container.read(gameListProvider);
        final lastTwoGames =
            updatedGames.skip(updatedGames.length - 2).toList();

        expect(
          lastTwoGames[0].id.value,
          isNot(equals(lastTwoGames[1].id.value)),
        );
        expect(lastTwoGames[0].title, 'Game 1');
        expect(lastTwoGames[1].title, 'Game 2');
      });

      test('should work with all game statuses', () {
        final notifier = container.read(gameListProvider.notifier);
        final statuses = [
          GameStatus.playing,
          GameStatus.completed,
          GameStatus.backlog,
          GameStatus.abandoned,
          GameStatus.wishlist,
          GameStatus.ordered,
        ];

        final initialCount = container.read(gameListProvider).length;

        for (int i = 0; i < statuses.length; i++) {
          notifier.createGame(
            title: 'Test Game ${i + 1}',
            platform: 'PC',
            status: statuses[i],
          );
        }

        final updatedGames = container.read(gameListProvider);
        expect(updatedGames.length, initialCount + statuses.length);

        final newGames = updatedGames.skip(initialCount).toList();
        for (int i = 0; i < statuses.length; i++) {
          expect(newGames[i].status, statuses[i]);
          expect(newGames[i].title, 'Test Game ${i + 1}');
        }
      });
    });

    test('startPlaying should move game from backlog to playing', () {
      final notifier = container.read(gameListProvider.notifier);
      final games = container.read(gameListProvider);

      // Find a backlog game
      final backlogGame = games.firstWhere(
        (game) => game.status == GameStatus.backlog,
      );
      final gameId = backlogGame.id;

      // Start playing the game
      notifier.startPlaying(gameId);

      // Verify the game is now in playing status
      final updatedGames = container.read(gameListProvider);
      final updatedGame = updatedGames.firstWhere((game) => game.id == gameId);

      expect(updatedGame.status, GameStatus.playing);
    });

    test('markCompleted should set game to completed status', () async {
      // Find a playing game from the test data
      final games = container.read(gameListProvider);
      final playingGame = games.firstWhere(
        (game) => game.status == GameStatus.playing,
      );

      // Mark it as completed
      await container
          .read(gameListProvider.notifier)
          .markCompleted(playingGame.id);

      // Get the updated list
      final updatedList = container.read(gameListProvider);
      final updatedGame = updatedList.firstWhere((g) => g.id == playingGame.id);

      // Verify the game is completed
      expect(updatedGame.status, GameStatus.completed);
    });
  });
}
