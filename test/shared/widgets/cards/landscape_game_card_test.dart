import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:chkpnt/shared/widgets/cards/landscape_game_card.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/game_image_service.dart';

// Mock GameImageService for testing
class MockGameImageService extends GameImageService {
  final bool shouldReturnImage;
  final File? mockFile;

  MockGameImageService({this.shouldReturnImage = false, this.mockFile});

  @override
  Future<File?> getImageFile(String imagePath) async {
    if (shouldReturnImage && mockFile != null) {
      return mockFile;
    }
    return null;
  }
}

void main() {
  group('LandscapeGameCard', () {
    late GameItem testGame;
    late VoidCallback onTapCallback;
    late VoidCallback onPlayPressedCallback;
    bool onTapCalled = false;
    bool onPlayPressedCalled = false;

    setUp(() {
      onTapCalled = false;
      onPlayPressedCalled = false;
      onTapCallback = () => onTapCalled = true;
      onPlayPressedCallback = () => onPlayPressedCalled = true;

      testGame = GameItem(
        id: GameId('test-id'),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.backlog,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );
    });

    testWidgets('renders correctly with default props', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandscapeGameCard(game: testGame, onTap: onTapCallback),
          ),
        ),
      );

      expect(find.byType(LandscapeGameCard), findsOneWidget);
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test Platform'), findsOneWidget);
      expect(find.text('In Backlog'), findsOneWidget);
    });

    testWidgets('shows placeholder when no image path', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandscapeGameCard(game: testGame, onTap: onTapCallback),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching image', (tester) async {
      final gameWithImage = testGame.copyWith(imagePath: 'test/path.jpg');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandscapeGameCard(game: gameWithImage, onTap: onTapCallback),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows placeholder when image service returns null', (
      tester,
    ) async {
      final gameWithImage = testGame.copyWith(imagePath: 'test/path.jpg');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameImageServiceProvider.overrideWithValue(
              MockGameImageService(shouldReturnImage: false),
            ),
          ],
          child: MaterialApp(
            home: LandscapeGameCard(game: gameWithImage, onTap: onTapCallback),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('handles card tap correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandscapeGameCard(game: testGame, onTap: onTapCallback),
          ),
        ),
      );

      await tester.tap(find.byType(LandscapeGameCard));
      expect(onTapCalled, isTrue);
    });

    testWidgets(
      'shows play button for backlog games when onPlayPressed provided',
      (tester) async {
        final backlogGame = testGame.copyWith(status: GameStatus.backlog);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: LandscapeGameCard(
                game: backlogGame,
                onTap: onTapCallback,
                onPlayPressed: onPlayPressedCallback,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.play_arrow), findsOneWidget);

        await tester.tap(find.byIcon(Icons.play_arrow));
        expect(onPlayPressedCalled, isTrue);
      },
    );

    testWidgets(
      'does not show play button for backlog games without onPlayPressed',
      (tester) async {
        final backlogGame = testGame.copyWith(status: GameStatus.backlog);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: LandscapeGameCard(game: backlogGame, onTap: onTapCallback),
            ),
          ),
        );

        expect(find.byIcon(Icons.play_arrow), findsNothing);
      },
    );

    testWidgets('shows completed badge for completed games', (tester) async {
      final completedGame = testGame.copyWith(status: GameStatus.completed);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LandscapeGameCard(game: completedGame, onTap: onTapCallback),
          ),
        ),
      );

      expect(find.text('Completed'), findsOneWidget);
      // Should find the completed badge (check icon in badge)
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows correct status icons for different game statuses', (
      tester,
    ) async {
      final testCases = [
        (GameStatus.playing, Icons.play_circle_fill),
        (GameStatus.completed, Icons.check_circle),
        (GameStatus.abandoned, Icons.pause_circle_filled),
        (GameStatus.wishlist, Icons.favorite_outline),
        (GameStatus.ordered, Icons.shopping_cart),
      ];

      for (final (status, expectedIcon) in testCases) {
        final gameWithStatus = testGame.copyWith(status: status);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: LandscapeGameCard(
                game: gameWithStatus,
                onTap: onTapCallback,
              ),
            ),
          ),
        );

        expect(find.byIcon(expectedIcon), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('shows correct status text for different game statuses', (
      tester,
    ) async {
      final testCases = [
        (GameStatus.playing, 'In Progress'),
        (GameStatus.completed, 'Completed'),
        (GameStatus.backlog, 'In Backlog'),
        (GameStatus.abandoned, 'Abandoned'),
        (GameStatus.wishlist, 'Wishlist'),
        (GameStatus.ordered, 'Ordered'),
      ];

      for (final (status, expectedText) in testCases) {
        final gameWithStatus = testGame.copyWith(status: status);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: LandscapeGameCard(
                game: gameWithStatus,
                onTap: onTapCallback,
              ),
            ),
          ),
        );

        expect(find.text(expectedText), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('handles long titles with ellipsis', (tester) async {
      final longTitleGame = testGame.copyWith(
        title: 'This is a very long game title that should be truncated',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SizedBox(
              width: 200, // Constrain width to force ellipsis
              child: LandscapeGameCard(
                game: longTitleGame,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(
        find.text('This is a very long game title that should be truncated'),
      );
      expect(titleWidget.overflow, TextOverflow.ellipsis);
      expect(titleWidget.maxLines, 1);
    });

    testWidgets('handles long platform names with ellipsis', (tester) async {
      final longPlatformGame = testGame.copyWith(
        platform: 'Very Long Platform Name That Should Be Truncated',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: SizedBox(
              width: 200, // Constrain width to force ellipsis
              child: LandscapeGameCard(
                game: longPlatformGame,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      final platformWidget = tester.widget<Text>(
        find.text('Very Long Platform Name That Should Be Truncated'),
      );
      expect(platformWidget.overflow, TextOverflow.ellipsis);
      expect(platformWidget.maxLines, 1);
    });
  });
}
