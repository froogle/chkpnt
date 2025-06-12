import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/widgets/profile_incoming_games_section.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('ProfileIncomingGamesSection', () {
    testWidgets('displays empty state when no ordered games', (
      WidgetTester tester,
    ) async {
      // Simplified test without provider container timing issues
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamesByStatusProvider(
              GameStatus.ordered,
            ).overrideWith((ref) => <GameItem>[]),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileIncomingGamesSection()),
          ),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid timer issues
      await tester.pump();

      expect(find.text('No games on the way'), findsOneWidget);
      expect(
        find.text('Games you mark as "ordered" will appear here'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('displays heading', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gamesByStatusProvider(
              GameStatus.ordered,
            ).overrideWith((ref) => <GameItem>[]),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileIncomingGamesSection()),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Incoming Games'), findsOneWidget);
    });

    group('with ordered games', () {
      late List<GameItem> orderedGames;

      setUp(() {
        final now = DateTime.now();
        orderedGames = [
          GameItem(
            id: GameId.generate(),
            title: 'Ordered Game 1',
            platform: 'PC',
            status: GameStatus.ordered,
            lastModified: now.subtract(const Duration(days: 2)),
            lastStatusChange: now.subtract(const Duration(days: 2)),
          ),
          GameItem(
            id: GameId.generate(),
            title: 'Ordered Game 2',
            platform: 'PlayStation 5',
            status: GameStatus.ordered,
            lastModified: now.subtract(const Duration(days: 1)),
            lastStatusChange: now.subtract(const Duration(days: 1)),
          ),
        ];
      });

      testWidgets('shows only ordered games', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gamesByStatusProvider(
                GameStatus.ordered,
              ).overrideWith((ref) => orderedGames),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileIncomingGamesSection()),
            ),
          ),
        );

        await tester.pump();

        expect(find.text('Ordered Game 1'), findsOneWidget);
        expect(find.text('Ordered Game 2'), findsOneWidget);
      });

      testWidgets('shows game titles and platforms', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gamesByStatusProvider(
                GameStatus.ordered,
              ).overrideWith((ref) => orderedGames),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileIncomingGamesSection()),
            ),
          ),
        );

        await tester.pump();

        // Check titles
        expect(find.text('Ordered Game 1'), findsOneWidget);
        expect(find.text('Ordered Game 2'), findsOneWidget);

        // Check platforms
        expect(find.text('PC'), findsOneWidget);
        expect(find.text('PlayStation 5'), findsOneWidget);
      });

      testWidgets('shows basic visual elements', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gamesByStatusProvider(
                GameStatus.ordered,
              ).overrideWith((ref) => orderedGames),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileIncomingGamesSection()),
            ),
          ),
        );

        await tester.pump();

        // Simplified test - just check that arrow icons are present
        expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      });

      testWidgets('does not show empty state when games exist', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gamesByStatusProvider(
                GameStatus.ordered,
              ).overrideWith((ref) => orderedGames),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileIncomingGamesSection()),
            ),
          ),
        );

        await tester.pump();

        // Should not show empty state
        expect(find.text('No games on the way'), findsNothing);
        expect(find.byIcon(Icons.local_shipping_outlined), findsNothing);
      });
    });
  });
}
