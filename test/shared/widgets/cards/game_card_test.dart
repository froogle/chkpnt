import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/cards/game_card.dart';

void main() {
  group('GameCard', () {
    late GameItem testGame;
    late VoidCallback onTapCallback;

    setUp(() {
      testGame = GameItem.create(
        title: 'Test Game',
        platform: 'PC',
        status: GameStatus.playing,
      );
      onTapCallback = () {};
    });

    testWidgets('builds without error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(game: testGame, onTap: onTapCallback),
            ),
          ),
        ),
      );

      expect(find.byType(GameCard), findsOneWidget);
    });

    testWidgets('displays game title in compact layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: testGame,
                layout: GameCardLayout.compact,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Game'), findsOneWidget);
    });

    testWidgets('displays game title in overlay layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: testGame,
                layout: GameCardLayout.overlay,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('PC'), findsOneWidget);
    });

    testWidgets('displays game title in detailed layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: testGame,
                layout: GameCardLayout.detailed,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('PC'), findsOneWidget);
    });

    testWidgets('responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(game: testGame, onTap: () => tapped = true),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GameCard));
      expect(tapped, true);
    });

    testWidgets('shows play button for backlog games in overlay layout', (
      tester,
    ) async {
      final backlogGame = testGame.copyWith(status: GameStatus.backlog);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: backlogGame,
                layout: GameCardLayout.overlay,
                onTap: onTapCallback,
                onPlayPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows play button for backlog games in compact layout', (
      tester,
    ) async {
      final backlogGame = testGame.copyWith(status: GameStatus.backlog);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: backlogGame,
                layout: GameCardLayout.compact,
                onTap: onTapCallback,
                onPlayPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows completed badge for completed games', (tester) async {
      final completedGame = testGame.copyWith(status: GameStatus.completed);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameCard(
                game: completedGame,
                layout: GameCardLayout.overlay,
                onTap: onTapCallback,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
