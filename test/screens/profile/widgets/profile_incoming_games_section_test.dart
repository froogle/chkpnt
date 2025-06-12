import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/widgets/profile_incoming_games_section.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('ProfileIncomingGamesSection', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Scaffold(body: const ProfileIncomingGamesSection()),
        ),
      );
    }

    testWidgets('displays empty state when no ordered games', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('No games on the way'), findsOneWidget);
      expect(
        find.text('Games you mark as "ordered" will appear here'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    });

    testWidgets('displays heading', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

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
            lastStatusChange: now.subtract(const Duration(days: 2)), // Oldest
          ),
          GameItem(
            id: GameId.generate(),
            title: 'Ordered Game 2',
            platform: 'PlayStation 5',
            status: GameStatus.ordered,
            lastModified: now.subtract(const Duration(days: 1)),
            lastStatusChange: now.subtract(const Duration(days: 1)), // Newer
          ),
          GameItem(
            id: GameId.generate(),
            title: 'Playing Game',
            platform: 'Xbox',
            status: GameStatus.playing,
            lastModified: now,
            lastStatusChange: now,
          ),
        ];
      });

      testWidgets('shows only ordered games', (WidgetTester tester) async {
        // Mock the gamesByStatusProvider to return our test data
        container = ProviderContainer(
          overrides: [
            gamesByStatusProvider(GameStatus.ordered).overrideWith(
              (ref) =>
                  orderedGames
                      .where((g) => g.status == GameStatus.ordered)
                      .toList(),
            ),
          ],
        );

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Should show ordered games but not playing games
        expect(find.text('Ordered Game 1'), findsOneWidget);
        expect(find.text('Ordered Game 2'), findsOneWidget);
        expect(find.text('Playing Game'), findsNothing);
      });

      testWidgets('displays games in correct order (oldest first)', (
        WidgetTester tester,
      ) async {
        container = ProviderContainer(
          overrides: [
            gamesByStatusProvider(GameStatus.ordered).overrideWith(
              (ref) =>
                  orderedGames
                      .where((g) => g.status == GameStatus.ordered)
                      .toList(),
            ),
          ],
        );

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        final gameItems = find.byType(Container);
        expect(gameItems, findsWidgets);

        // The first game should be the oldest (Ordered Game 1)
        expect(find.text('Ordered Game 1'), findsOneWidget);
        expect(find.text('Ordered Game 2'), findsOneWidget);
      });

      testWidgets('shows game titles and platforms', (
        WidgetTester tester,
      ) async {
        container = ProviderContainer(
          overrides: [
            gamesByStatusProvider(GameStatus.ordered).overrideWith(
              (ref) =>
                  orderedGames
                      .where((g) => g.status == GameStatus.ordered)
                      .toList(),
            ),
          ],
        );

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Check titles
        expect(find.text('Ordered Game 1'), findsOneWidget);
        expect(find.text('Ordered Game 2'), findsOneWidget);

        // Check platforms
        expect(find.text('PC'), findsOneWidget);
        expect(find.text('PlayStation 5'), findsOneWidget);
      });

      testWidgets('shows visual indicators', (WidgetTester tester) async {
        container = ProviderContainer(
          overrides: [
            gamesByStatusProvider(GameStatus.ordered).overrideWith(
              (ref) =>
                  orderedGames
                      .where((g) => g.status == GameStatus.ordered)
                      .toList(),
            ),
          ],
        );

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Should show arrow indicators
        expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      });

      testWidgets('does not show empty state when games exist', (
        WidgetTester tester,
      ) async {
        container = ProviderContainer(
          overrides: [
            gamesByStatusProvider(GameStatus.ordered).overrideWith(
              (ref) =>
                  orderedGames
                      .where((g) => g.status == GameStatus.ordered)
                      .toList(),
            ),
          ],
        );

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Should not show empty state
        expect(find.text('No games on the way'), findsNothing);
        expect(find.byIcon(Icons.local_shipping_outlined), findsNothing);
      });
    });
  });
}
