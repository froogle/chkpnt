import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_info.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';

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

    testWidgets('should render compact platform badge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: GameDetailSheetInfo(game: testGame))),
      );

      // Platform is displayed in compact form (truncated to 12 chars + ellipsis for unknown platforms)
      expect(find.text('Test Platfor...'), findsOneWidget);
    });

    group('Status-specific icon and text tests', () {
      testWidgets('should render no status badge for a game with no state', (
        WidgetTester tester,
      ) async {
        final ownedGame = testGame.copyWith(status: GameStatus.owned);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: ownedGame)),
          ),
        );

        expect(find.text('Owned'), findsNothing);
        expect(find.text('In Collection'), findsNothing);
        expect(find.byIcon(Icons.bookmark), findsNothing);
        expect(find.text('Test Platfor...'), findsOneWidget);
      });

      testWidgets('should paint a no-state badge in the neutral colour', (
        WidgetTester tester,
      ) async {
        final ownedGame = testGame.copyWith(status: GameStatus.owned);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: GameDetailSheetInfo(game: ownedGame)),
          ),
        );

        final neutralBadge = _statusBadgeDecoration(tester);
        expect(
          neutralBadge.color,
          AppColors.emptyStateIcon.withValues(alpha: 0.9),
        );
        expect(
          neutralBadge.color,
          isNot(equals(const Color(0xFF64748B).withValues(alpha: 0.9))),
        );

        final badgeText = tester.widget<Text>(find.text('Test Platfor...'));
        expect(badgeText.style?.color, Colors.white);

        expect(
          find.descendant(
            of: find.byType(GameDetailSheetInfo),
            matching: find.byIcon(Icons.bookmark),
          ),
          findsNothing,
        );
      });

      testWidgets('presents every Status as Status presentation does', (
        WidgetTester tester,
      ) async {
        final statuses = GameStatus.values.where((s) => s != GameStatus.owned);

        for (final status in statuses) {
          final style = StatusStyles.of(status);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GameDetailSheetInfo(
                  game: testGame.copyWith(status: status),
                ),
              ),
            ),
          );

          final statusText = tester.widget<Text>(find.text(style.label));
          expect(statusText.style?.color, AppLayout.detailSubtitleStyle.color);
          expect(
            find.byIcon(style.icon!),
            findsNWidgets(2),
            reason: '$status icon on the badge and in the status row',
          );
          expect(
            _statusBadgeDecoration(tester).color,
            style.colour.withValues(alpha: 0.9),
            reason: '$status badge colour',
          );

          final badgeIcon = tester.widget<Icon>(find.byIcon(style.icon!).first);
          expect(badgeIcon.color, Colors.white);
          expect(badgeIcon.size, 14);
        }
      });

      testWidgets('greys the status row icon only for Abandoned', (
        WidgetTester tester,
      ) async {
        final statuses = GameStatus.values.where((s) => s != GameStatus.owned);

        for (final status in statuses) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: GameDetailSheetInfo(
                  game: testGame.copyWith(status: status),
                ),
              ),
            ),
          );

          final rowIcon = tester.widget<Icon>(
            find.byIcon(StatusStyles.of(status).icon!).last,
          );
          expect(
            rowIcon.color,
            status == GameStatus.abandoned
                ? AppColors.expandIcon
                : AppColors.primaryPurple,
            reason: '$status status row icon colour',
          );
        }
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

    group('Kind of copy', () {
      testWidgets('names a Physical Game once, as Physical', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetInfo(
                game: testGame.copyWith(isPhysical: true),
              ),
            ),
          ),
        );

        expect(find.text('Physical'), findsOneWidget);
        expect(find.byIcon(Icons.sd_card), findsOneWidget);
        expect(find.text('Boxed Copy'), findsNothing);
        expect(find.byIcon(Icons.inventory_2_outlined), findsNothing);
      });

      testWidgets('names a Digital Game once, as Digital', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetInfo(
                game: testGame.copyWith(isPhysical: false),
              ),
            ),
          ),
        );

        expect(find.text('Digital'), findsOneWidget);
        expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
        expect(find.text('Download'), findsNothing);
        expect(find.byIcon(Icons.download_outlined), findsNothing);
      });
    });
  });
}

BoxDecoration _statusBadgeDecoration(WidgetTester tester) {
  return tester
          .widget<Container>(
            find
                .ancestor(
                  of: find.text('Test Platfor...'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .decoration
      as BoxDecoration;
}
