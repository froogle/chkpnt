import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';

void main() {
  group('Core Game State Management Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Game State Transitions', () {
      test('should transition game from backlog to playing', () {
        // Create a backlog game
        final backlogGame = GameItem.create(
          title: 'Test Backlog Game',
          platform: 'PC',
          status: GameStatus.backlog,
        );

        // Add game to list
        container.read(gameListProvider.notifier).addGame(backlogGame);

        // Verify initial state
        final initialGames = container.read(gameListProvider);
        expect(initialGames.length, greaterThan(0));
        final addedGame = initialGames.firstWhere(
          (g) => g.title == 'Test Backlog Game',
        );
        expect(addedGame.status, GameStatus.backlog);

        // Transition to playing
        container.read(gameListProvider.notifier).startPlaying(addedGame.id);

        // Verify state change
        final updatedGames = container.read(gameListProvider);
        final updatedGame = updatedGames.firstWhere(
          (g) => g.id == addedGame.id,
        );
        expect(updatedGame.status, GameStatus.playing);
        expect(
          updatedGame.lastStatusChange.isAfter(addedGame.lastStatusChange),
          true,
        );
      });

      test('should transition game from playing to completed', () {
        // Create a playing game
        final playingGame = GameItem.create(
          title: 'Test Playing Game',
          platform: 'PS5',
          status: GameStatus.playing,
        );

        container.read(gameListProvider.notifier).addGame(playingGame);

        // Mark as completed
        container.read(gameListProvider.notifier).markCompleted(playingGame.id);

        // Verify state change
        final games = container.read(gameListProvider);
        final completedGame = games.firstWhere((g) => g.id == playingGame.id);
        expect(completedGame.status, GameStatus.completed);
        expect(
          completedGame.lastStatusChange.isAfter(playingGame.lastStatusChange),
          true,
        );
      });

      test('should update game details while preserving timestamps correctly', () {
        // Create original game
        final originalGame = GameItem.create(
          title: 'Original Title',
          platform: 'Switch',
          status: GameStatus.backlog,
        );

        container.read(gameListProvider.notifier).addGame(originalGame);

        // Update with new details but same status (lastStatusChange should not update)
        final updatedGame = originalGame.copyWith(
          title: 'Updated Title',
          platform: 'PC',
        );

        container.read(gameListProvider.notifier).updateGame(updatedGame);

        // Verify changes
        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((g) => g.id == originalGame.id);

        expect(savedGame.title, 'Updated Title');
        expect(savedGame.platform, 'PC');
        expect(savedGame.status, GameStatus.backlog); // Status unchanged
        expect(savedGame.lastModified.isAfter(originalGame.lastModified), true);
        // Status change time should remain the same since status didn't change
        expect(
          savedGame.lastStatusChange.millisecondsSinceEpoch,
          originalGame.lastStatusChange.millisecondsSinceEpoch,
        );
      });

      test(
        'should update lastStatusChange when status changes via updateGame',
        () {
          // Create original game
          final originalGame = GameItem.create(
            title: 'Status Change Test',
            platform: 'Xbox',
            status: GameStatus.backlog,
          );

          container.read(gameListProvider.notifier).addGame(originalGame);

          // Update with status change
          final updatedGame = originalGame.copyWith(status: GameStatus.playing);
          container.read(gameListProvider.notifier).updateGame(updatedGame);

          // Verify status change tracking
          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((g) => g.id == originalGame.id);

          expect(savedGame.status, GameStatus.playing);
          expect(
            savedGame.lastStatusChange.isAfter(originalGame.lastStatusChange),
            true,
          );
          expect(
            savedGame.lastModified.isAfter(originalGame.lastModified),
            true,
          );
        },
      );
    });

    group('Game Filtering Logic', () {
      test('should filter games by status correctly', () {
        // Add test games with different statuses
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Playing Game',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Backlog Game',
              platform: 'PC',
              status: GameStatus.backlog,
            );

        // Test filtering
        final playingGames = container.read(
          gamesByStatusProvider(GameStatus.playing),
        );
        final backlogGames = container.read(
          gamesByStatusProvider(GameStatus.backlog),
        );

        expect(playingGames.every((g) => g.status == GameStatus.playing), true);
        expect(backlogGames.every((g) => g.status == GameStatus.backlog), true);
        expect(playingGames.any((g) => g.title == 'Playing Game'), true);
        expect(backlogGames.any((g) => g.title == 'Backlog Game'), true);
      });

      test('should filter games by platform correctly', () {
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'PC Game',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Switch Game',
              platform: 'Switch',
              status: GameStatus.playing,
            );

        final pcGames = container.read(gamesByPlatformProvider('PC'));
        final switchGames = container.read(gamesByPlatformProvider('Switch'));
        final allGames = container.read(gamesByPlatformProvider('All'));

        expect(pcGames.every((g) => g.platform == 'PC'), true);
        expect(switchGames.every((g) => g.platform == 'Switch'), true);
        expect(allGames.length, greaterThan(pcGames.length));
      });

      test('should apply complex filters correctly', () {
        // Add games for complex filtering test
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Cyberpunk PC Playing',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Cyberpunk PS5 Completed',
              platform: 'PS5',
              status: GameStatus.completed,
            );

        // Test status + platform + search filtering
        final filteredGames = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'PC', 'cyber'),
        );

        expect(filteredGames.length, 1);
        expect(filteredGames.first.title, 'Cyberpunk PC Playing');
        expect(filteredGames.first.platform, 'PC');
        expect(filteredGames.first.status, GameStatus.playing);
      });

      test('should return empty list when no games match filters', () {
        final noMatches = container.read(
          fullyFilteredGamesProvider(
            GameStatus.playing,
            'Nonexistent',
            'nomatch',
          ),
        );

        expect(noMatches, isEmpty);
      });
    });

    group('Game Creation and Management', () {
      test('should create game with auto-generated timestamps', () {
        final beforeCreate = DateTime.now();

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'New Game',
              platform: 'Steam Deck',
              status: GameStatus.wishlist,
            );

        final games = container.read(gameListProvider);
        final newGame = games.firstWhere((g) => g.title == 'New Game');

        expect(newGame.platform, 'Steam Deck');
        expect(newGame.status, GameStatus.wishlist);
        expect(newGame.lastModified.isAfter(beforeCreate), true);
        expect(newGame.lastStatusChange.isAfter(beforeCreate), true);
        expect(newGame.id.value.isNotEmpty, true);
      });

      test('should remove game correctly', () {
        // Add a game to remove
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Game to Remove',
              platform: 'PC',
              status: GameStatus.backlog,
            );

        final initialGames = container.read(gameListProvider);
        final gameToRemove = initialGames.firstWhere(
          (g) => g.title == 'Game to Remove',
        );
        final initialCount = initialGames.length;

        // Remove the game
        container.read(gameListProvider.notifier).removeGame(gameToRemove.id);

        final finalGames = container.read(gameListProvider);
        expect(finalGames.length, initialCount - 1);
        expect(finalGames.any((g) => g.id == gameToRemove.id), false);
      });

      test('should maintain data integrity when modifying games list', () {
        // Create multiple games
        final initialCount = container.read(gameListProvider).length;

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Integrity Test 1',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Integrity Test 2',
              platform: 'Switch',
              status: GameStatus.backlog,
            );

        final games = container.read(gameListProvider);
        expect(games.length, initialCount + 2);

        // Verify all games have unique IDs
        final gameIds = games.map((g) => g.id.value).toSet();
        expect(gameIds.length, games.length);

        // Verify all games have valid timestamps
        for (final game in games) {
          expect(game.lastModified.millisecondsSinceEpoch, greaterThan(0));
          expect(game.lastStatusChange.millisecondsSinceEpoch, greaterThan(0));
        }
      });
    });

    group('Platform Management', () {
      test('should provide available platforms correctly', () {
        // Add games with various platforms
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Test PC',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Test Mobile',
              platform: 'Mobile',
              status: GameStatus.backlog,
            );

        final platforms = container.read(availablePlatformsProvider);

        // Should start with "All"
        expect(platforms.first, 'All');

        // Should contain both new platforms
        expect(platforms.contains('PC'), true);
        expect(platforms.contains('Mobile'), true);

        // Should be sorted (after "All")
        final sortedPlatforms = platforms.skip(1).toList();
        final expectedSorted = [...sortedPlatforms]..sort();
        expect(sortedPlatforms, expectedSorted);
      });
    });

    group('Search Functionality', () {
      test('should search games by title case-insensitively', () {
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'The Elder Scrolls',
              platform: 'PC',
              status: GameStatus.playing,
            );

        final searchResults = container.read(
          searchFilteredGamesProvider('elder'),
        );
        expect(searchResults.length, 1);
        expect(searchResults.first.title, 'The Elder Scrolls');

        // Test case insensitivity
        final upperCaseResults = container.read(
          searchFilteredGamesProvider('ELDER'),
        );
        expect(upperCaseResults.length, 1);
      });

      test('should search games by platform', () {
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Steam Game',
              platform: 'Steam Deck',
              status: GameStatus.playing,
            );

        final platformResults = container.read(
          searchFilteredGamesProvider('steam'),
        );
        expect(platformResults.any((g) => g.platform == 'Steam Deck'), true);
      });

      test('should return all games for empty search', () {
        final allGames = container.read(gameListProvider);
        final emptySearchResults = container.read(
          searchFilteredGamesProvider(''),
        );

        expect(emptySearchResults.length, allGames.length);
      });
    });
  });
}
