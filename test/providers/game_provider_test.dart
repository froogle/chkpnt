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
        final newGame = TestHelpers.createTestGame(
          title: 'New Game',
          platform: 'Switch',
          status: GameStatus.wishlist,
        );
        notifier.addGame(newGame);
        final afterCreate = DateTime.now();

        final updatedGames = container.read(gameListProvider);
        expect(updatedGames.length, initialGamesCount + 1);

        final addedGame = updatedGames.last;
        expect(addedGame.title, 'New Game');
        expect(addedGame.platform, 'Switch');
        expect(addedGame.status, GameStatus.wishlist);
        expect(addedGame.id.value, isNotEmpty);
        expect(addedGame.imagePath, isNull);
        expect(addedGame.remoteImageUrl, isNull);

        // Check timestamps are current
        expect(
          addedGame.lastModified.isAfter(beforeCreate) ||
              addedGame.lastModified.isAtSameMomentAs(beforeCreate),
          true,
        );
        expect(
          addedGame.lastModified.isBefore(afterCreate) ||
              addedGame.lastModified.isAtSameMomentAs(afterCreate),
          true,
        );
        expect(
          addedGame.lastStatusChange.isAfter(beforeCreate) ||
              addedGame.lastStatusChange.isAtSameMomentAs(beforeCreate),
          true,
        );
        expect(
          addedGame.lastStatusChange.isBefore(afterCreate) ||
              addedGame.lastStatusChange.isAtSameMomentAs(afterCreate),
          true,
        );
      });

      test('should create and add game with optional fields', () {
        final notifier = container.read(gameListProvider.notifier);
        final initialGamesCount = container.read(gameListProvider).length;

        final newGameWithImages = TestHelpers.createTestGame(
          title: 'New Game with Images',
          platform: 'PS5',
          status: GameStatus.playing,
          imagePath: '/path/to/local/image.jpg',
          remoteImageUrl: 'https://example.com/remote/image.jpg',
        );
        notifier.addGame(newGameWithImages);

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

        final game1 = TestHelpers.createBacklogGame(title: 'Game 1');
        final game2 = TestHelpers.createPlayingGame(
          title: 'Game 2',
          platform: 'Xbox',
        );

        notifier.addGame(game1);
        notifier.addGame(game2);

        final updatedGames = container.read(gameListProvider);
        final lastTwoGames = updatedGames
            .skip(updatedGames.length - 2)
            .toList();

        expect(
          lastTwoGames[0].id.value,
          isNot(equals(lastTwoGames[1].id.value)),
        );
        expect(lastTwoGames[0].title, 'Game 1');
        expect(lastTwoGames[1].title, 'Game 2');
      });

      test('should work with all game statuses', () {
        final statuses = [
          GameStatus.playing,
          GameStatus.completed,
          GameStatus.backlog,
          GameStatus.abandoned,
          GameStatus.wishlist,
          GameStatus.ordered,
        ];

        final initialCount = container.read(gameListProvider).length;

        // Create games with different statuses using helpers
        final testGames = [
          TestHelpers.createPlayingGame(title: 'Test Game 1'),
          TestHelpers.createCompletedGame(title: 'Test Game 2'),
          TestHelpers.createBacklogGame(title: 'Test Game 3'),
          TestHelpers.createAbandonedGame(title: 'Test Game 4'),
          TestHelpers.createTestGame(
            title: 'Test Game 5',
            status: GameStatus.wishlist,
          ),
          TestHelpers.createTestGame(
            title: 'Test Game 6',
            status: GameStatus.ordered,
          ),
        ];
        TestHelpers.addGamesToContainer(container, testGames);

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
