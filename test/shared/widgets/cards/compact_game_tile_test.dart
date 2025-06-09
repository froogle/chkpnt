import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/cards/compact_game_tile.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('CompactGameTile', () {
    late GameItem testGame;

    setUp(() {
      testGame = GameItem.create(
        title: 'Test Game',
        platform: 'PC',
        status: GameStatus.backlog,
      );
    });

    testWidgets('renders game title correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CompactGameTile(game: testGame, onTap: () {})),
          ),
        ),
      );

      expect(find.text('Test Game'), findsOneWidget);
    });

    testWidgets('shows platform in status overlay', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: CompactGameTile(game: testGame, onTap: () {})),
          ),
        ),
      );

      expect(find.text('PC'), findsOneWidget);
    });

    testWidgets('shows play button for backlog games', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CompactGameTile(
                game: testGame,
                onTap: () {},
                onPlayPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('does not show play button for non-backlog games', (
      tester,
    ) async {
      final playingGame = testGame.copyWith(status: GameStatus.playing);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CompactGameTile(
                game: playingGame,
                onTap: () {},
                onPlayPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('calls onTap when tile is tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CompactGameTile(
                game: testGame,
                onTap: () => wasTapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CompactGameTile));
      expect(wasTapped, true);
    });

    testWidgets('calls onPlayPressed when play button is tapped', (
      tester,
    ) async {
      bool wasPlayPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CompactGameTile(
                game: testGame,
                onTap: () {},
                onPlayPressed: () => wasPlayPressed = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.play_arrow));
      expect(wasPlayPressed, true);
    });

    testWidgets('displays correct status icon for different game statuses', (
      tester,
    ) async {
      final testCases = [
        (GameStatus.playing, Icons.play_circle_fill),
        (GameStatus.completed, Icons.check_circle),
        (GameStatus.backlog, Icons.schedule),
        (GameStatus.abandoned, Icons.pause_circle_filled),
      ];

      for (final (status, expectedIcon) in testCases) {
        final gameWithStatus = testGame.copyWith(status: status);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CompactGameTile(game: gameWithStatus, onTap: () {}),
              ),
            ),
          ),
        );

        expect(find.byIcon(expectedIcon), findsOneWidget);
      }
    });
  });
}
