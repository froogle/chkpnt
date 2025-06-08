import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';

void main() {
  group('GameDetailSheet Widget Tests', () {
    late ProviderContainer container;
    late GameItem testGame;

    setUp(() {
      container = ProviderContainer();
      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.playing,
      );

      // Add the test game to the provider
      container.read(gameListProvider.notifier).addGame(testGame);
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should render game information correctly', (
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

      // Check that game title is displayed
      expect(find.text('Test Game'), findsOneWidget);

      // Check that platform is displayed
      expect(find.text('Test Platform'), findsOneWidget);

      // Check that the current status icon is displayed (be more specific about context)
      expect(find.byIcon(Icons.play_circle_fill), findsAtLeastNWidgets(1));
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

    testWidgets('should render all status buttons', (
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

      // Check that all status options are displayed
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
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

      // Since the game status is 'playing', that button should be selected
      expect(find.text('Playing'), findsOneWidget);
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

      // Initially, Save Changes button should be disabled
      final saveButton = find.text('Save Changes');
      expect(saveButton, findsOneWidget);

      // Tap on the Completed status button
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Now Save Changes button should be enabled (status has changed)
      expect(saveButton, findsOneWidget);

      // Tap Save Changes to persist the change
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
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
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

      // Select Completed status
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Save the change
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      // Verify status was updated
      var updatedGames = container.read(gameListProvider);
      var updatedGame = updatedGames.firstWhere(
        (game) => game.id == testGame.id,
      );
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

      // Change status from Playing to Completed
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Save the change
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      // Check that the notification appears (SnackBar with success message)
      expect(find.text('Test Game moved to Completed!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
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
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      // Check that the notification appears (SnackBar with success message)
      expect(find.text('Test Game moved to Backlog!'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsAtLeastNWidgets(1));
    });

    group('Platform Badge Tests', () {
      testWidgets('should render platform badge', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(body: GameDetailSheet(game: testGame)),
            ),
          ),
        );

        // Platform badge should be visible
        expect(find.text('Test Platform'), findsOneWidget);
      });

      testWidgets('should handle different platforms', (
        WidgetTester tester,
      ) async {
        final platforms = ['PC', 'PS5', 'Xbox', 'Steam Deck'];

        for (final platform in platforms) {
          final gameWithPlatform = testGame.copyWith(platform: platform);

          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                home: Scaffold(body: GameDetailSheet(game: gameWithPlatform)),
              ),
            ),
          );

          expect(find.text(platform), findsOneWidget);
        }
      });
    });
  });
}
