import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/shared/widgets/buttons/status_button.dart';

void main() {
  group('GameStatusSelector Widget Tests', () {
    group('Add Mode Tests', () {
      testWidgets('displays all statuses when isAddMode is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: GameStatusSelector(
                  selectedStatus: GameStatus.backlog,
                  onStatusChanged: (status) {},
                  isAddMode: true,
                ),
              ),
            ),
          ),
        );

        // Should show ALL status options when adding a new game
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);
        expect(find.text('Wishlist'), findsOneWidget);
        expect(find.text('Ordered'), findsOneWidget);
      });

      testWidgets(
        'displays all statuses regardless of selectedStatus in add mode',
        (tester) async {
          // Test with wishlist status but add mode enabled
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                home: Scaffold(
                  body: GameStatusSelector(
                    selectedStatus: GameStatus.wishlist,
                    onStatusChanged: (status) {},
                    isAddMode: true,
                  ),
                ),
              ),
            ),
          );

          // Should show ALL status options, not just wishlist flow
          expect(find.text('Playing'), findsOneWidget);
          expect(find.text('Backlog'), findsOneWidget);
          expect(find.text('Completed'), findsOneWidget);
          expect(find.text('Abandoned'), findsOneWidget);
          expect(find.text('Wishlist'), findsOneWidget);
          expect(find.text('Ordered'), findsOneWidget);
        },
      );

      testWidgets('calls onStatusChanged correctly in add mode', (
        tester,
      ) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: GameStatusSelector(
                  selectedStatus: GameStatus.backlog,
                  onStatusChanged: (status) => changedStatus = status,
                  isAddMode: true,
                ),
              ),
            ),
          ),
        );

        // Should be able to select any status in add mode
        await tester.tap(find.text('Wishlist'));
        await tester.pump();

        expect(changedStatus, equals(GameStatus.wishlist));
      });
    });

    group('Edit Mode Tests', () {
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
        expect(find.byType(GridView), findsOneWidget);
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

      testWidgets('displays filtered statuses for ordered games', (
        tester,
      ) async {
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

      testWidgets('displays filtered statuses for playing games', (
        tester,
      ) async {
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

        // Should show only 4 non-wishlist options
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);

        // Should NOT show wishlist flow options
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);
      });

      testWidgets('displays filtered statuses for backlog games', (
        tester,
      ) async {
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

        // Should show only 4 non-wishlist options
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);

        // Should NOT show wishlist flow options
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);
      });

      testWidgets('displays filtered statuses for completed games', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: GameStatusSelector(
                  selectedStatus: GameStatus.completed,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        );

        // Should show only 4 non-wishlist options
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);

        // Should NOT show wishlist flow options
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);
      });

      testWidgets('displays filtered statuses for abandoned games', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: GameStatusSelector(
                  selectedStatus: GameStatus.abandoned,
                  onStatusChanged: (status) {},
                ),
              ),
            ),
          ),
        );

        // Should show only 4 non-wishlist options
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);

        // Should NOT show wishlist flow options
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);
      });

      testWidgets('calls onStatusChanged when status is tapped', (
        tester,
      ) async {
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
    });


    group('State Deselection Tests', () {
      Widget buildSelector({
        required GameStatus selectedStatus,
        bool isAddMode = false,
        ValueChanged<GameStatus>? onStatusChanged,
      }) {
        return ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameStatusSelector(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged ?? (status) {},
                isAddMode: isAddMode,
              ),
            ),
          ),
        );
      }

      Finder buttonFor(GameStatus status) {
        return find.byWidgetPredicate(
          (widget) => widget is StatusButton && widget.status == status,
        );
      }

      testWidgets('never offers an Owned chip in add mode', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.backlog, isAddMode: true),
        );

        expect(buttonFor(GameStatus.owned), findsNothing);
        expect(find.text('In Collection'), findsNothing);
      });

      testWidgets('never offers an Owned chip in edit mode', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.playing),
        );

        expect(buttonFor(GameStatus.owned), findsNothing);
        expect(find.text('In Collection'), findsNothing);
      });

      testWidgets('deselects a playing game back to owned', (tester) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          buildSelector(
            selectedStatus: GameStatus.playing,
            onStatusChanged: (status) => changedStatus = status,
          ),
        );

        await tester.tap(find.text('Playing'));
        await tester.pump();

        expect(changedStatus, equals(GameStatus.owned));
      });

      testWidgets('deselects every other general state back to owned', (
        tester,
      ) async {
        final labels = {
          GameStatus.backlog: 'Backlog',
          GameStatus.ongoing: 'Ongoing',
          GameStatus.completed: 'Completed',
          GameStatus.abandoned: 'Abandoned',
        };

        for (final entry in labels.entries) {
          GameStatus? changedStatus;

          await tester.pumpWidget(
            buildSelector(
              selectedStatus: entry.key,
              onStatusChanged: (status) => changedStatus = status,
            ),
          );

          await tester.tap(find.text(entry.value));
          await tester.pump();

          expect(
            changedStatus,
            equals(GameStatus.owned),
            reason: 'tapping the selected ${entry.key} chip should deselect it',
          );
        }
      });

      testWidgets('does not deselect a wishlist game', (tester) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          buildSelector(
            selectedStatus: GameStatus.wishlist,
            onStatusChanged: (status) => changedStatus = status,
          ),
        );

        await tester.tap(find.text('Wishlist'));
        await tester.pump();

        expect(changedStatus, isNull);
      });

      testWidgets('does not deselect an ordered game', (tester) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          buildSelector(
            selectedStatus: GameStatus.ordered,
            onStatusChanged: (status) => changedStatus = status,
          ),
        );

        await tester.tap(find.text('Ordered'));
        await tester.pump();

        expect(changedStatus, isNull);
      });

      testWidgets('renders the general chips unselected for an owned game', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.owned),
        );

        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Ongoing'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);

        final buttons = tester.widgetList<StatusButton>(
          find.byType(StatusButton),
        );
        expect(buttons, isNotEmpty);
        expect(buttons.every((button) => !button.isSelected), isTrue);
      });

      testWidgets('selects a status normally on an owned game', (tester) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          buildSelector(
            selectedStatus: GameStatus.owned,
            onStatusChanged: (status) => changedStatus = status,
          ),
        );

        await tester.tap(find.text('Completed'));
        await tester.pump();

        expect(changedStatus, equals(GameStatus.completed));
      });
    });
  });
}
