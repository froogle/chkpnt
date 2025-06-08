import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameItem Model Tests', () {
    late GameItem testGame;
    late DateTime initialTime;
    late DateTime laterTime;

    setUp(() {
      initialTime = DateTime(2024, 1, 1, 12, 0, 0);
      laterTime = DateTime(2024, 1, 1, 12, 30, 0);

      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.backlog,
        lastModified: initialTime,
        lastStatusChange: initialTime,
      );
    });

    group('lastStatusChange behaviour', () {
      test('should preserve lastStatusChange when status remains the same', () {
        // Create a copy with updated title but same status
        final updatedGame = testGame.copyWith(
          title: 'Updated Test Game',
          lastModified: laterTime,
          // lastStatusChange should remain unchanged
        );

        expect(updatedGame.status, equals(testGame.status));
        expect(updatedGame.lastModified, equals(laterTime));
        expect(updatedGame.lastStatusChange, equals(initialTime));
        expect(updatedGame.title, equals('Updated Test Game'));
      });

      test(
        'should preserve lastStatusChange when platform changes but status stays same',
        () {
          // Create a copy with updated platform but same status
          final updatedGame = testGame.copyWith(
            platform: 'Xbox Series X',
            lastModified: laterTime,
            // lastStatusChange should remain unchanged
          );

          expect(updatedGame.status, equals(testGame.status));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(initialTime));
          expect(updatedGame.platform, equals('Xbox Series X'));
        },
      );

      test(
        'should preserve lastStatusChange when imagePath changes but status stays same',
        () {
          // Create a copy with updated imagePath but same status
          final updatedGame = testGame.copyWith(
            imagePath: '/path/to/new/image.jpg',
            lastModified: laterTime,
            // lastStatusChange should remain unchanged
          );

          expect(updatedGame.status, equals(testGame.status));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(initialTime));
          expect(updatedGame.imagePath, equals('/path/to/new/image.jpg'));
        },
      );

      test(
        'should preserve lastStatusChange when remoteImageUrl changes but status stays same',
        () {
          // Create a copy with updated remoteImageUrl but same status
          final updatedGame = testGame.copyWith(
            remoteImageUrl: 'https://example.com/new-image.jpg',
            lastModified: laterTime,
            // lastStatusChange should remain unchanged
          );

          expect(updatedGame.status, equals(testGame.status));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(initialTime));
          expect(
            updatedGame.remoteImageUrl,
            equals('https://example.com/new-image.jpg'),
          );
        },
      );

      test('should update lastStatusChange when status changes to playing', () {
        // Create a copy with updated status
        final updatedGame = testGame.copyWith(
          status: GameStatus.playing,
          lastModified: laterTime,
          lastStatusChange: laterTime,
        );

        expect(updatedGame.status, equals(GameStatus.playing));
        expect(updatedGame.lastModified, equals(laterTime));
        expect(updatedGame.lastStatusChange, equals(laterTime));
      });

      test(
        'should update lastStatusChange when status changes to completed',
        () {
          // Create a copy with updated status
          final updatedGame = testGame.copyWith(
            status: GameStatus.completed,
            lastModified: laterTime,
            lastStatusChange: laterTime,
          );

          expect(updatedGame.status, equals(GameStatus.completed));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(laterTime));
        },
      );

      test(
        'should update lastStatusChange when status changes to abandoned',
        () {
          // Create a copy with updated status
          final updatedGame = testGame.copyWith(
            status: GameStatus.abandoned,
            lastModified: laterTime,
            lastStatusChange: laterTime,
          );

          expect(updatedGame.status, equals(GameStatus.abandoned));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(laterTime));
        },
      );

      test(
        'should update lastStatusChange when status changes to wishlist',
        () {
          // Create a copy with updated status
          final updatedGame = testGame.copyWith(
            status: GameStatus.wishlist,
            lastModified: laterTime,
            lastStatusChange: laterTime,
          );

          expect(updatedGame.status, equals(GameStatus.wishlist));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(laterTime));
        },
      );

      test('should update lastStatusChange when status changes to ordered', () {
        // Create a copy with updated status
        final updatedGame = testGame.copyWith(
          status: GameStatus.ordered,
          lastModified: laterTime,
          lastStatusChange: laterTime,
        );

        expect(updatedGame.status, equals(GameStatus.ordered));
        expect(updatedGame.lastModified, equals(laterTime));
        expect(updatedGame.lastStatusChange, equals(laterTime));
      });

      test(
        'should handle multiple field changes with status change correctly',
        () {
          // Create a copy with multiple fields updated including status
          final updatedGame = testGame.copyWith(
            title: 'Updated Title',
            platform: 'Nintendo Switch',
            status: GameStatus.playing,
            imagePath: '/new/image/path.jpg',
            lastModified: laterTime,
            lastStatusChange: laterTime,
          );

          expect(updatedGame.title, equals('Updated Title'));
          expect(updatedGame.platform, equals('Nintendo Switch'));
          expect(updatedGame.status, equals(GameStatus.playing));
          expect(updatedGame.imagePath, equals('/new/image/path.jpg'));
          expect(updatedGame.lastModified, equals(laterTime));
          expect(updatedGame.lastStatusChange, equals(laterTime));
        },
      );

      test(
        'should handle multiple field changes without status change correctly',
        () {
          // Create a copy with multiple fields updated but same status
          final updatedGame = testGame.copyWith(
            title: 'Updated Title',
            platform: 'Nintendo Switch',
            imagePath: '/new/image/path.jpg',
            remoteImageUrl: 'https://example.com/image.jpg',
            lastModified: laterTime,
            // lastStatusChange should remain unchanged
          );

          expect(updatedGame.title, equals('Updated Title'));
          expect(updatedGame.platform, equals('Nintendo Switch'));
          expect(updatedGame.status, equals(testGame.status)); // Same status
          expect(updatedGame.imagePath, equals('/new/image/path.jpg'));
          expect(
            updatedGame.remoteImageUrl,
            equals('https://example.com/image.jpg'),
          );
          expect(updatedGame.lastModified, equals(laterTime));
          expect(
            updatedGame.lastStatusChange,
            equals(initialTime),
          ); // Unchanged
        },
      );
    });

    group('GameItem creation and serialisation', () {
      test('should create GameItem with all required fields', () {
        final game = GameItem(
          id: GameId.generate(),
          title: 'Test Game',
          platform: 'PS5',
          status: GameStatus.playing,
          lastModified: DateTime.now(),
          lastStatusChange: DateTime.now(),
        );

        expect(game.title, equals('Test Game'));
        expect(game.platform, equals('PS5'));
        expect(game.status, equals(GameStatus.playing));
        expect(game.lastModified, isA<DateTime>());
        expect(game.lastStatusChange, isA<DateTime>());
      });

      test('should create GameItem with optional fields', () {
        final now = DateTime.now();
        final game = GameItem(
          id: GameId.generate(),
          title: 'Test Game',
          platform: 'PS5',
          status: GameStatus.playing,
          lastModified: now,
          lastStatusChange: now,
          imagePath: '/path/to/image.jpg',
          remoteImageUrl: 'https://example.com/image.jpg',
        );

        expect(game.imagePath, equals('/path/to/image.jpg'));
        expect(game.remoteImageUrl, equals('https://example.com/image.jpg'));
      });

      test('should convert to and from JSON correctly', () {
        final originalGame = GameItem(
          id: const GameId('test-game-id'),
          title: 'Test Game',
          platform: 'PS5',
          status: GameStatus.completed,
          lastModified: initialTime,
          lastStatusChange: laterTime,
          imagePath: '/path/to/image.jpg',
          remoteImageUrl: 'https://example.com/image.jpg',
        );

        final json = originalGame.toJson();

        // Verify the JSON structure
        expect(json['title'], equals('Test Game'));
        expect(json['platform'], equals('PS5'));
        expect(json['status'], equals('completed'));
        expect(json['imagePath'], equals('/path/to/image.jpg'));
        expect(json['remoteImageUrl'], equals('https://example.com/image.jpg'));
        expect(json['lastModified'], isA<String>());
        expect(json['lastStatusChange'], isA<String>());
      });
    });

    group('GameId tests', () {
      test('should generate unique GameIds', () {
        final id1 = GameId.generate();
        final id2 = GameId.generate();

        expect(id1.value, isNot(equals(id2.value)));
        expect(id1.value, isA<String>());
        expect(id2.value, isA<String>());
      });

      test('should create GameId from string value', () {
        const testValue = 'test-game-id';
        const gameId = GameId(testValue);

        expect(gameId.value, equals(testValue));
      });

      test('should convert GameId to JSON correctly', () {
        const originalId = GameId('test-game-id');
        final json = originalId.toJson();

        expect(json['value'], equals('test-game-id'));
      });
    });
  });
}
