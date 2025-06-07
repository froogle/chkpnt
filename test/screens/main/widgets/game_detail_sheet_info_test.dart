import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_info.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameDetailSheetInfo Widget Tests', () {
    late GameItem testGame;

    setUp(() {
      testGame = const GameItem(
        id: GameId('test-1'),
        title: 'The Legend of Zelda: Breath of the Wild',
        platform: 'Nintendo Switch',
        status: GameStatus.playing,
        progress: 50.0,
      );
    });

    testWidgets('should render game title correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Check that the game title is displayed
      expect(
        find.text('The Legend of Zelda: Breath of the Wild'),
        findsOneWidget,
      );
    });

    testWidgets('should render platform badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Check that platform information is displayed via PlatformBadge
      expect(find.text('Nintendo Switch'), findsOneWidget);
    });

    testWidgets('should display current status with correct icon and text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Check that current status text is displayed
      expect(find.text('Current Status: Playing'), findsOneWidget);

      // Check that the playing icon is displayed
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
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
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
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
        expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
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
        expect(find.byIcon(Icons.playlist_add), findsOneWidget);
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
        expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
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
        expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
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

    testWidgets('should handle different platforms', (
      WidgetTester tester,
    ) async {
      final platforms = ['PC', 'PlayStation 5', 'Xbox Series X', 'Steam Deck'];

      for (final platform in platforms) {
        final gameWithPlatform = testGame.copyWith(platform: platform);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: gameWithPlatform)),
          ),
        );

        expect(find.text(platform), findsOneWidget);
      }
    });

    testWidgets('should maintain proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Verify the main column structure
      expect(find.byType(Column), findsOneWidget);

      // Verify that the status row exists
      final statusRow = find.byWidgetPredicate(
        (widget) =>
            widget is Row &&
            widget.children.any(
              (child) => child is Icon && child.icon == Icons.play_circle_fill,
            ),
      );
      expect(statusRow, findsOneWidget);
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
  });
}
