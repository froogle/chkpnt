import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_info.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameDetailSheetInfo Widget Tests', () {
    late GameItem testGame;

    setUp(() {
      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );
    });

    testWidgets('should render game title correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Check that the game title is displayed
      expect(find.text('Test Game'), findsOneWidget);
    });

    testWidgets('should render compact platform badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Platform is displayed in compact form (truncated to 12 chars + ellipsis for unknown platforms)
      expect(find.text('Test Platfor...'), findsOneWidget);
    });

    testWidgets('should display current status with correct icon and text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Check that current status text is displayed
      expect(find.text('Current Status: Playing'), findsOneWidget);

      // Check that the playing icon is displayed (appears in both compact badge and status display)
      expect(find.byIcon(Icons.play_circle_fill), findsNWidgets(2));
    });

    group('Status-specific icon and text tests', () {
      testWidgets('should display completed status correctly', (
        WidgetTester tester,
      ) async {
        final completedGame = testGame.copyWith(status: GameStatus.completed);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: completedGame)),
          ),
        );

        expect(find.text('Current Status: Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
      });

      testWidgets('should display abandoned status correctly', (
        WidgetTester tester,
      ) async {
        final abandonedGame = testGame.copyWith(status: GameStatus.abandoned);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: abandonedGame)),
          ),
        );

        expect(find.text('Current Status: Abandoned'), findsOneWidget);
        expect(find.byIcon(Icons.pause_circle_filled), findsNWidgets(2));
      });

      testWidgets('should display backlog status correctly', (
        WidgetTester tester,
      ) async {
        final backlogGame = testGame.copyWith(status: GameStatus.backlog);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: backlogGame)),
          ),
        );

        expect(find.text('Current Status: Backlog'), findsOneWidget);
        // Backlog uses schedule icon in compact badge but list icon in status display
        expect(find.byIcon(Icons.schedule), findsOneWidget);
        expect(find.byIcon(Icons.list), findsOneWidget);
      });

      testWidgets('should display wishlist status correctly', (
        WidgetTester tester,
      ) async {
        final wishlistGame = testGame.copyWith(status: GameStatus.wishlist);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: wishlistGame)),
          ),
        );

        expect(find.text('Current Status: Wishlist'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNWidgets(2));
      });

      testWidgets('should display ordered status correctly', (
        WidgetTester tester,
      ) async {
        final orderedGame = testGame.copyWith(status: GameStatus.ordered);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: orderedGame)),
          ),
        );

        expect(find.text('Current Status: Ordered'), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart), findsNWidgets(2));
      });
    });

    testWidgets('should handle long game titles gracefully', (
      WidgetTester tester,
    ) async {
      final longTitleGame = testGame.copyWith(
        title:
            'This is a very very very long game title that should display properly without causing layout issues',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GameDetailSheetInfo(game: longTitleGame)),
        ),
      );

      // Should render without overflow
      expect(tester.takeException(), isNull);
      expect(find.text(longTitleGame.title), findsOneWidget);
    });

    testWidgets('should handle different platforms with compact names', (
      WidgetTester tester,
    ) async {
      final platformMappings = {
        'PC': 'PC',
        'PlayStation 5': 'PS5',
        'Xbox Series X': 'Xbox Series',
        'Steam Deck': 'Steam Deck',
        'Nintendo Switch': 'Switch',
      };

      for (final entry in platformMappings.entries) {
        final gameWithPlatform = testGame.copyWith(platform: entry.key);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: gameWithPlatform)),
          ),
        );

        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('should maintain proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Verify the GameDetailSheetInfo widget exists
      expect(find.byType(GameDetailSheetInfo), findsOneWidget);

      // Verify that status icons are present (in both compact badge and status display)
      expect(find.byIcon(Icons.play_circle_fill), findsNWidgets(2));
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Should render without throwing any exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Verify it's a StatelessWidget (no state management)
      final widget = tester.widget<GameDetailSheetInfo>(
        find.byType(GameDetailSheetInfo),
      );
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should properly format status display text', (
      WidgetTester tester,
    ) async {
      // Test all status values to ensure proper formatting
      final statusTests = [
        (GameStatus.playing, 'Playing'),
        (GameStatus.completed, 'Completed'),
        (GameStatus.backlog, 'Backlog'),
        (GameStatus.abandoned, 'Abandoned'),
        (GameStatus.wishlist, 'Wishlist'),
        (GameStatus.ordered, 'Ordered'),
      ];

      for (final (status, expectedText) in statusTests) {
        final gameWithStatus = testGame.copyWith(status: status);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: gameWithStatus)),
          ),
        );

        expect(find.text('Current Status: $expectedText'), findsOneWidget);
      }
    });

    group('Interactive functionality tests', () {
      testWidgets('should call onEditPressed when title is tapped', (
        WidgetTester tester,
      ) async {
        bool editPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetInfo(
                game: testGame,
                onEditPressed: () {
                  editPressed = true;
                },
              ),
            ),
          ),
        );

        // Tap on the title
        await tester.tap(find.text(testGame.title));
        await tester.pump();

        expect(editPressed, isTrue);
      });

      testWidgets('should call onEditPressed when platform is tapped', (
        WidgetTester tester,
      ) async {
        bool editPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetInfo(
                game: testGame,
                onEditPressed: () {
                  editPressed = true;
                },
              ),
            ),
          ),
        );

        // Tap on the compact platform badge (truncated to 12 chars)
        await tester.tap(find.text('Test Platfor...'));
        await tester.pump();

        expect(editPressed, isTrue);
      });

      testWidgets(
        'should not crash when onEditPressed is null and title is tapped',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: GameDetailSheetInfo(game: testGame)),
            ),
          );

          // Tap on the title - should not crash
          await tester.tap(find.text(testGame.title));
          await tester.pump();

          // Should still display the title
          expect(find.text(testGame.title), findsOneWidget);
        },
      );

      testWidgets(
        'should not crash when onEditPressed is null and platform is tapped',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: GameDetailSheetInfo(game: testGame)),
            ),
          );

          // Tap on the compact platform badge - should not crash
          await tester.tap(find.text('Test Platfor...'));
          await tester.pump();

          // Should still display the compact platform
          expect(find.text('Test Platfor...'), findsOneWidget);
        },
      );
    });
  });
}
