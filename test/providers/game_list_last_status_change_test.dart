import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import '../test_helpers.dart';

void main() {
  group('GameList lastStatusChange Integration Tests', () {
    late ProviderContainer container;
    late GameItem testGame;
    late DateTime initialTime;

    setUp(() async {
      container = TestHelpers.createTestContainer();
      initialTime = DateTime(2024, 1, 1, 12, 0, 0);

      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.backlog,
        lastModified: initialTime,
        lastStatusChange: initialTime,
      );

      // Add the test game to the provider
      await container.read(gameListProvider.notifier).addGame(testGame);
    });

    tearDown(() {
      container.dispose();
    });

    group('updateGame method behavior', () {
      test(
        'should preserve lastStatusChange when only title changes',
        () async {
          final notifier = container.read(gameListProvider.notifier);

          // Update only the title
          final updatedGame = testGame.copyWith(title: 'Updated Title');
          await notifier.updateGame(updatedGame);

          // Wait for the update to complete
          await TestHelpers.waitForAsyncOperation();

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.title, equals('Updated Title'));
          expect(savedGame.status, equals(GameStatus.backlog)); // Same status
          expect(savedGame.lastStatusChange, equals(initialTime)); // Unchanged
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test('should preserve lastStatusChange when only platform changes', () {
        final notifier = container.read(gameListProvider.notifier);

        // Update only the platform
        final updatedGame = testGame.copyWith(platform: 'Xbox Series X');
        notifier.updateGame(updatedGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.platform, equals('Xbox Series X'));
        expect(savedGame.status, equals(GameStatus.backlog)); // Same status
        expect(savedGame.lastStatusChange, equals(initialTime)); // Unchanged
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test('should preserve lastStatusChange when only imagePath changes', () {
        final notifier = container.read(gameListProvider.notifier);

        // Update only the imagePath
        final updatedGame = testGame.copyWith(imagePath: '/new/path/image.jpg');
        notifier.updateGame(updatedGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.imagePath, equals('/new/path/image.jpg'));
        expect(savedGame.status, equals(GameStatus.backlog)); // Same status
        expect(savedGame.lastStatusChange, equals(initialTime)); // Unchanged
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test(
        'should preserve lastStatusChange when only remoteImageUrl changes',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update only the remoteImageUrl
          final updatedGame = testGame.copyWith(
            remoteImageUrl: 'https://example.com/new-image.jpg',
          );
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(
            savedGame.remoteImageUrl,
            equals('https://example.com/new-image.jpg'),
          );
          expect(savedGame.status, equals(GameStatus.backlog)); // Same status
          expect(savedGame.lastStatusChange, equals(initialTime)); // Unchanged
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test(
        'should preserve lastStatusChange when multiple fields change but status stays same',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update multiple fields but keep the same status
          final updatedGame = testGame.copyWith(
            title: 'Updated Title',
            platform: 'Nintendo Switch',
            imagePath: '/new/path/image.jpg',
            remoteImageUrl: 'https://example.com/image.jpg',
          );
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.title, equals('Updated Title'));
          expect(savedGame.platform, equals('Nintendo Switch'));
          expect(savedGame.imagePath, equals('/new/path/image.jpg'));
          expect(
            savedGame.remoteImageUrl,
            equals('https://example.com/image.jpg'),
          );
          expect(savedGame.status, equals(GameStatus.backlog)); // Same status
          expect(savedGame.lastStatusChange, equals(initialTime)); // Unchanged
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test('should update lastStatusChange when status changes to playing', () {
        final notifier = container.read(gameListProvider.notifier);

        // Update the status
        final updatedGame = testGame.copyWith(status: GameStatus.playing);
        notifier.updateGame(updatedGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.status, equals(GameStatus.playing));
        expect(
          savedGame.lastStatusChange.isAfter(initialTime),
          isTrue,
        ); // Updated
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test(
        'should update lastStatusChange when status changes to completed',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update the status
          final updatedGame = testGame.copyWith(status: GameStatus.completed);
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.status, equals(GameStatus.completed));
          expect(
            savedGame.lastStatusChange.isAfter(initialTime),
            isTrue,
          ); // Updated
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test(
        'should update lastStatusChange when status changes to abandoned',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update the status
          final updatedGame = testGame.copyWith(status: GameStatus.abandoned);
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.status, equals(GameStatus.abandoned));
          expect(
            savedGame.lastStatusChange.isAfter(initialTime),
            isTrue,
          ); // Updated
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test(
        'should update lastStatusChange when status changes to wishlist',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update the status
          final updatedGame = testGame.copyWith(status: GameStatus.wishlist);
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.status, equals(GameStatus.wishlist));
          expect(
            savedGame.lastStatusChange.isAfter(initialTime),
            isTrue,
          ); // Updated
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test('should update lastStatusChange when status changes to ordered', () {
        final notifier = container.read(gameListProvider.notifier);

        // Update the status
        final updatedGame = testGame.copyWith(status: GameStatus.ordered);
        notifier.updateGame(updatedGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.status, equals(GameStatus.ordered));
        expect(
          savedGame.lastStatusChange.isAfter(initialTime),
          isTrue,
        ); // Updated
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test(
        'should update lastStatusChange when status changes with other fields',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Update status along with other fields
          final updatedGame = testGame.copyWith(
            title: 'Updated Title',
            platform: 'Nintendo Switch',
            status: GameStatus.playing,
            imagePath: '/new/path/image.jpg',
          );
          notifier.updateGame(updatedGame);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.title, equals('Updated Title'));
          expect(savedGame.platform, equals('Nintendo Switch'));
          expect(savedGame.status, equals(GameStatus.playing));
          expect(savedGame.imagePath, equals('/new/path/image.jpg'));
          expect(
            savedGame.lastStatusChange.isAfter(initialTime),
            isTrue,
          ); // Updated
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );
    });

    group('startPlaying method behavior', () {
      test(
        'should update lastStatusChange when moving from backlog to playing',
        () {
          final notifier = container.read(gameListProvider.notifier);

          // Start playing the game
          notifier.startPlaying(testGame.id);

          final games = container.read(gameListProvider);
          final savedGame = games.firstWhere((game) => game.id == testGame.id);

          expect(savedGame.status, equals(GameStatus.playing));
          expect(
            savedGame.lastStatusChange.isAfter(initialTime),
            isTrue,
          ); // Updated
          expect(
            savedGame.lastModified.isAfter(initialTime),
            isTrue,
          ); // Updated
        },
      );

      test(
        'should update lastStatusChange when starting to play from completed status',
        () {
          // First mark the game as completed
          final completedGame = testGame.copyWith(status: GameStatus.completed);
          container.read(gameListProvider.notifier).updateGame(completedGame);

          // Get the updated lastStatusChange time
          final games1 = container.read(gameListProvider);
          final intermediateGame = games1.firstWhere(
            (game) => game.id == testGame.id,
          );
          final completedTime = intermediateGame.lastStatusChange;

          // Wait a bit to ensure time difference
          Future.delayed(const Duration(milliseconds: 1));

          // Now start playing again
          container.read(gameListProvider.notifier).startPlaying(testGame.id);

          final games2 = container.read(gameListProvider);
          final finalGame = games2.firstWhere((game) => game.id == testGame.id);

          expect(finalGame.status, equals(GameStatus.playing));
          expect(
            finalGame.lastStatusChange.isAfter(completedTime),
            isTrue,
          ); // Updated again
          expect(
            finalGame.lastModified.isAfter(completedTime),
            isTrue,
          ); // Updated
        },
      );
    });

    group('markCompleted method behavior', () {
      test('should update lastStatusChange when marking game as completed', () {
        final notifier = container.read(gameListProvider.notifier);

        // Mark the game as completed
        notifier.markCompleted(testGame.id);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.status, equals(GameStatus.completed));
        expect(
          savedGame.lastStatusChange.isAfter(initialTime),
          isTrue,
        ); // Updated
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test(
        'should update lastStatusChange when completing from playing status',
        () {
          // First start playing the game
          container.read(gameListProvider.notifier).startPlaying(testGame.id);

          // Get the updated lastStatusChange time
          final games1 = container.read(gameListProvider);
          final playingGame = games1.firstWhere(
            (game) => game.id == testGame.id,
          );
          final playingTime = playingGame.lastStatusChange;

          // Wait a bit to ensure time difference
          Future.delayed(const Duration(milliseconds: 1));

          // Now mark as completed
          container.read(gameListProvider.notifier).markCompleted(testGame.id);

          final games2 = container.read(gameListProvider);
          final completedGame = games2.firstWhere(
            (game) => game.id == testGame.id,
          );

          expect(completedGame.status, equals(GameStatus.completed));
          expect(
            completedGame.lastStatusChange.isAfter(playingTime),
            isTrue,
          ); // Updated again
          expect(
            completedGame.lastModified.isAfter(playingTime),
            isTrue,
          ); // Updated
        },
      );
    });

    group('addGame method behavior', () {
      test('should set lastStatusChange when adding a new game', () {
        final newGame = GameItem(
          id: GameId.generate(),
          title: 'New Game',
          platform: 'Xbox',
          status: GameStatus.wishlist,
          lastModified: initialTime,
          lastStatusChange: initialTime,
        );

        container.read(gameListProvider.notifier).addGame(newGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == newGame.id);

        expect(savedGame.title, equals('New Game'));
        expect(savedGame.status, equals(GameStatus.wishlist));
        expect(
          savedGame.lastStatusChange,
          equals(initialTime),
        ); // Should be set as provided
        expect(
          savedGame.lastModified,
          equals(initialTime),
        ); // Should be set as provided
      });
    });

    group('Edge cases and validation', () {
      test('should handle same status update correctly', () {
        final notifier = container.read(gameListProvider.notifier);

        // Update with the same status (should preserve lastStatusChange)
        final updatedGame = testGame.copyWith(
          title: 'Updated Title',
          status: GameStatus.backlog, // Same as original
        );
        notifier.updateGame(updatedGame);

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((game) => game.id == testGame.id);

        expect(savedGame.title, equals('Updated Title'));
        expect(savedGame.status, equals(GameStatus.backlog)); // Same status
        expect(savedGame.lastStatusChange, equals(initialTime)); // Preserved
        expect(savedGame.lastModified.isAfter(initialTime), isTrue); // Updated
      });

      test('should handle rapid status changes correctly', () {
        final notifier = container.read(gameListProvider.notifier);

        // First status change
        notifier.startPlaying(testGame.id);
        final games1 = container.read(gameListProvider);
        final playingGame = games1.firstWhere((game) => game.id == testGame.id);
        final playingChangeTime = playingGame.lastStatusChange;

        // Second status change
        notifier.markCompleted(testGame.id);
        final games2 = container.read(gameListProvider);
        final completedGame = games2.firstWhere(
          (game) => game.id == testGame.id,
        );

        expect(completedGame.status, equals(GameStatus.completed));
        expect(
          completedGame.lastStatusChange.isAfter(playingChangeTime),
          isTrue,
        );
        expect(completedGame.lastModified.isAfter(playingChangeTime), isTrue);
      });
    });
  });
}
