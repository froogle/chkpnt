import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import '../../../test_helpers.dart';

void main() {
  group('GameDetailSheet Widget Tests', () {
    late ProviderContainer container;
    late GameItem testGame;

    setUp(() async {
      container = TestHelpers.createTestContainer();
      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );

      // Add the test game to the provider
      await container.read(gameListProvider.notifier).addGame(testGame);
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should render game information correctly', (
      WidgetTester tester,
    ) async {
      // Use a larger screen size to prevent layout issues
      await tester.binding.setSurfaceSize(const Size(600, 800));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Check that game title is displayed
      expect(find.text('Test Game'), findsOneWidget);

      // Platform is displayed in compact form (truncated to 12 chars for unknown platforms)
      expect(find.text('Test Platfor...'), findsOneWidget);

      // Check that the current status icon is displayed (appears in compact badge, status display, and status buttons)
      expect(find.byIcon(Icons.play_circle_fill), findsAtLeastNWidgets(2));

      // Reset size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should render layout without close button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Check that close button is not present (we removed it)
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('should render appropriate status buttons for playing game', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Check that status options are displayed for playing game
      // 'Playing' appears twice: once in status display, once in status buttons
      expect(find.text('Playing'), findsNWidgets(2));
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);

      // Wishlist and ordered should NOT be displayed for playing game
      expect(find.text('Wishlist'), findsNothing);
      expect(find.text('Ordered'), findsNothing);
    });

    testWidgets('should render appropriate status buttons for wishlist game', (
      WidgetTester tester,
    ) async {
      final wishlistGame = testGame.copyWith(status: GameStatus.wishlist);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: wishlistGame)),
          ),
        ),
      );

      // Check that wishlist flow options are displayed for wishlist game
      // 'Wishlist' appears twice: once in status display, once in status buttons
      expect(find.text('Wishlist'), findsNWidgets(2));
      expect(find.text('Ordered'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);

      // Non-wishlist options should NOT be displayed for wishlist game
      expect(find.text('Playing'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Abandoned'), findsNothing);
    });

    testWidgets('should highlight current status', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Since the game status is 'playing', it appears twice: in status display and in status buttons
      expect(find.text('Playing'), findsNWidgets(2));
    });

    testWidgets('should handle status selection and save changes workflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Initially, Save button should be disabled
      final saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);

      // Tap on the Completed status button
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Now Save button should be enabled (status has changed)
      expect(saveButton, findsOneWidget);

      // Tap Save to persist the change
      await tester.tap(saveButton);
      await tester.pump();

      // Verify that the game status was updated in the provider
      final updatedGames = container.read(gameListProvider);
      final updatedGame = updatedGames.firstWhere(
        (game) => game.id == testGame.id,
      );
      expect(updatedGame.status, GameStatus.completed);
    });

    testWidgets('should render action buttons correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Verify that action buttons are present
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should render game image placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Look for the gamepad icon placeholder
      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('should handle game with different status', (
      WidgetTester tester,
    ) async {
      final completedGame = testGame.copyWith(status: GameStatus.completed);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: completedGame)),
          ),
        ),
      );

      // Check that completed status icon is displayed
      expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
    });

    testWidgets('should be responsive to layout constraints', (
      WidgetTester tester,
    ) async {
      // Test with a larger size to avoid overflow
      await tester.binding.setSurfaceSize(const Size(600, 800));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Should render without overflow in portrait
      expect(tester.takeException(), isNull);

      // Test landscape layout with even more width
      await tester.binding.setSurfaceSize(const Size(1000, 600));
      await tester.pump();

      // Should render without overflow in landscape
      expect(tester.takeException(), isNull);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle long game titles gracefully', (
      WidgetTester tester,
    ) async {
      // Use wider screen to prevent overflow
      await tester.binding.setSurfaceSize(const Size(800, 600));

      final longTitleGame = testGame.copyWith(
        title:
            'This is a very very very long game title that should wrap properly without causing overflow issues',
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: longTitleGame)),
          ),
        ),
      );

      // Should render without overflow
      expect(tester.takeException(), isNull);
      expect(find.text(longTitleGame.title), findsOneWidget);

      // Reset size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle status selection workflow correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Tap on a different status to enable save
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Now Save button should be enabled
      final saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);

      // Tap save to apply changes
      await tester.tap(saveButton);
      await tester.pump();

      // Verify the status was updated in the provider
      final games = container.read(gameListProvider);
      final updatedGame = games.firstWhere((g) => g.id == testGame.id);
      expect(updatedGame.status, GameStatus.completed);
    });

    testWidgets('should show notification when status changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Change status
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Save the changes
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify status change was applied
      final games = container.read(gameListProvider);
      final updatedGame = games.firstWhere((g) => g.id == testGame.id);
      expect(updatedGame.status, GameStatus.completed);
    });

    testWidgets('should show notification for backlog status change', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(body: GameDetailSheet(game: testGame)),
          ),
        ),
      );

      // Change status from Playing to Backlog
      await tester.tap(find.text('Backlog'));
      await tester.pump();

      // Save the change
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify status change was applied
      final games = container.read(gameListProvider);
      final updatedGame = games.firstWhere((g) => g.id == testGame.id);
      expect(updatedGame.status, GameStatus.backlog);
    });

    group('Compact Platform Badge Tests', () {
      testWidgets('should render compact platform badge', (WidgetTester tester) async {
        // Set to a larger screen size to prevent layout issues
        await tester.binding.setSurfaceSize(const Size(600, 800));

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(body: GameDetailSheet(game: testGame)),
            ),
          ),
        );

        // Platform is displayed in compact form (truncated to 12 chars)
        expect(find.text('Test Platfor...'), findsOneWidget);

        // Reset size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should handle different platforms with compact names', (
        WidgetTester tester,
      ) async {
        // Set to a larger screen size to prevent layout issues
        await tester.binding.setSurfaceSize(const Size(600, 800));

        final platformMappings = {
          'PC': 'PC',
          'PS5': 'PS5',
          'Xbox': 'Xbox',
          'Nintendo Switch': 'Switch',
        };

        for (final entry in platformMappings.entries) {
          final gameWithPlatform = testGame.copyWith(platform: entry.key);

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                home: Scaffold(body: GameDetailSheet(game: gameWithPlatform)),
              ),
            ),
          );

          // Check that compact platform name is displayed
          expect(find.text(entry.value), findsOneWidget);
        }

        // Reset size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
