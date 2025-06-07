import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/models/game_models.dart';

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

      expect(find.text('Change Status'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays all game statuses', (tester) async {
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

      // Should show all 5 status buttons
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
    });

    testWidgets('calls onStatusChanged when status is tapped', (tester) async {
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

      await tester.tap(find.text('Completed'));
      await tester.pump();

      expect(changedStatus, equals(GameStatus.completed));
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

    testWidgets('renders responsive grid layout', (tester) async {
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

      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.shrinkWrap, isTrue);
      expect(gridView.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets('maintains proper structure', (tester) async {
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

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('handles status changes correctly', (tester) async {
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
                  selectedStatus: GameStatus.wishlist,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GameStatusSelector), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('renders with wide constraints', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 500, // Wide width
                child: GameStatusSelector(
                  selectedStatus: GameStatus.wishlist,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GameStatusSelector), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
