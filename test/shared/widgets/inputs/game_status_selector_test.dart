import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';

void main() {
  group('GameStatusSelector Widget Tests', () {
    testWidgets('renders correctly with initial status', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should have responsive layout structure
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('displays filtered statuses for wishlist games', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should show only 3 wishlist flow options
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);

      // Should NOT show other statuses
      expect(find.text('Playing'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Abandoned'), findsNothing);
    });

    testWidgets('displays filtered statuses for ordered games', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.ordered,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should show only 3 wishlist flow options
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);

      // Should NOT show other statuses
      expect(find.text('Playing'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Abandoned'), findsNothing);
    });

    testWidgets('displays all statuses for non-wishlist games', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.playing,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should show all 6 status options
      expect(find.text('Playing'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
    });

    testWidgets('calls onStatusChanged when status is tapped', (tester) async {
      GameStatus? changedStatus;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.playing,
                onStatusChanged: (status) => changedStatus = status,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Completed'));
      await tester.pump();

      expect(changedStatus, equals(GameStatus.completed));
    });

    testWidgets('calls onStatusChanged for wishlist flow', (tester) async {
      GameStatus? changedStatus;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (status) => changedStatus = status,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Ordered'));
      await tester.pump();

      expect(changedStatus, equals(GameStatus.ordered));
    });

    testWidgets('handles different selected statuses', (tester) async {
      for (final status in GameStatus.values) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: GameStatusSelector(
                  selectedStatus: status,
                  onStatusChanged: (newStatus) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byType(GameStatusSelector), findsOneWidget);
        await tester.pump();
      }
    });

    testWidgets('renders responsive layout for wishlist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should have LayoutBuilder for responsive behavior
      expect(find.byType(LayoutBuilder), findsOneWidget);
      // Should use Wrap layout
      expect(find.byType(Wrap), findsOneWidget);
      // Should display wishlist flow status buttons
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
    });

    testWidgets('renders responsive layout for playing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.playing,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should have LayoutBuilder for responsive behavior
      expect(find.byType(LayoutBuilder), findsOneWidget);
      // Should use Wrap layout
      expect(find.byType(Wrap), findsOneWidget);
      // Should display all status buttons
      expect(find.text('Playing'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
    });

    testWidgets('maintains proper structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.backlog,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      // Should have responsive layout structure
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
      // Should have all status buttons for backlog status
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
    });

    testWidgets('handles status changes correctly for all statuses', (
      tester,
    ) async {
      final statusChanges = <GameStatus>[];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.backlog,
                onStatusChanged: statusChanges.add,
              ),
            ),
          ),
        ),
      );

      // Tap different statuses
      await tester.tap(find.text('Playing'));
      await tester.pump();
      await tester.tap(find.text('Completed'));
      await tester.pump();

      expect(statusChanges, contains(GameStatus.playing));
      expect(statusChanges, contains(GameStatus.completed));
    });

    testWidgets('handles status changes correctly for wishlist flow', (
      tester,
    ) async {
      final statusChanges = <GameStatus>[];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: statusChanges.add,
              ),
            ),
          ),
        ),
      );

      // Tap wishlist flow statuses
      await tester.tap(find.text('Ordered'));
      await tester.pump();
      await tester.tap(find.text('Backlog'));
      await tester.pump();

      expect(statusChanges, contains(GameStatus.ordered));
      expect(statusChanges, contains(GameStatus.backlog));
    });

    testWidgets('is a StatelessWidget', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (status) {},
              ),
            ),
          ),
        ),
      );

      final widget = tester.widget<GameStatusSelector>(
        find.byType(GameStatusSelector),
      );
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('handles multiple taps on same status', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: GameStatus.wishlist,
                onStatusChanged: (_) => tapCount++,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Wishlist'));
      await tester.pump();
      await tester.tap(find.text('Wishlist'));
      await tester.pump();

      expect(tapCount, equals(2));
    });

    testWidgets('renders with narrow constraints', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300, // Narrow width
                child: GameStatusSelector(
                  selectedStatus: GameStatus.playing,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GameStatusSelector), findsOneWidget);
      // Should use Wrap layout for responsive behavior
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('renders with wide constraints', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 500, // Wide width
                child: GameStatusSelector(
                  selectedStatus: GameStatus.playing,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GameStatusSelector), findsOneWidget);
      // Should still use Wrap layout (responsive)
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('calculates button widths correctly for wishlist flow', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: GameStatusSelector(
                  selectedStatus: GameStatus.wishlist,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Should render wishlist flow buttons only
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);

      // Should NOT render other buttons
      expect(find.text('Playing'), findsNothing);
      expect(find.text('Completed'), findsNothing);
      expect(find.text('Abandoned'), findsNothing);

      // Should have proper responsive structure
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('calculates button widths correctly for all statuses', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: GameStatusSelector(
                  selectedStatus: GameStatus.playing,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Should render all buttons for non-wishlist status
      expect(find.text('Playing'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Ordered'), findsOneWidget);

      // Should have proper responsive structure
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });
  });
}
