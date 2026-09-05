import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/shared/widgets/buttons/status_button.dart';
import 'package:chkpnt/styles/styles.dart';

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

    group('Owned Status Tests', () {
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

      testWidgets('offers Owned in add mode', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.backlog, isAddMode: true),
        );

        expect(find.text('Owned'), findsOneWidget);
      });

      testWidgets('offers Owned for a playing game', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.playing),
        );

        expect(find.text('Owned'), findsOneWidget);
      });

      testWidgets('offers the general options for an owned game', (
        tester,
      ) async {
        await tester.pumpWidget(buildSelector(selectedStatus: GameStatus.owned));

        expect(find.text('Owned'), findsOneWidget);
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);
        expect(find.text('Wishlist'), findsNothing);
        expect(find.text('Ordered'), findsNothing);
      });

      testWidgets('does not offer Owned for a wishlist game', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.wishlist),
        );

        expect(find.text('Owned'), findsNothing);
      });

      testWidgets('does not offer Owned for an ordered game', (tester) async {
        await tester.pumpWidget(
          buildSelector(selectedStatus: GameStatus.ordered),
        );

        expect(find.text('Owned'), findsNothing);
      });

      testWidgets('calls onStatusChanged with owned when tapped', (
        tester,
      ) async {
        GameStatus? changedStatus;

        await tester.pumpWidget(
          buildSelector(
            selectedStatus: GameStatus.playing,
            onStatusChanged: (status) => changedStatus = status,
          ),
        );

        await tester.tap(find.text('Owned'));
        await tester.pump();

        expect(changedStatus, equals(GameStatus.owned));
      });

      testWidgets('paints the selected Owned button in the selected colours', (
        tester,
      ) async {
        await tester.pumpWidget(buildSelector(selectedStatus: GameStatus.owned));

        final ownedButton = find.byWidgetPredicate(
          (widget) => widget is StatusButton && widget.status == GameStatus.owned,
        );
        expect(ownedButton, findsOneWidget);
        expect(
          tester.widget<StatusButton>(ownedButton).isSelected,
          isTrue,
        );

        final label = tester.widget<Text>(
          find.descendant(of: ownedButton, matching: find.text('Owned')),
        );
        final icon = tester.widget<Icon>(
          find.descendant(of: ownedButton, matching: find.byType(Icon)),
        );
        final decoration =
            tester
                    .widget<Container>(
                      find
                          .descendant(
                            of: ownedButton,
                            matching: find.byType(Container),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;

        expect(label.style?.color, AppColors.primaryPurple);
        expect(icon.color, AppColors.primaryPurple);
        expect(
          decoration.gradient,
          isNot(equals(AppGradients.cardGradient)),
        );
        expect(
          (decoration.border as Border).top.width,
          2,
        );
      });

      testWidgets(
        'paints the unselected Owned button in the unselected colours',
        (tester) async {
          await tester.pumpWidget(
            buildSelector(selectedStatus: GameStatus.playing),
          );

          final ownedButton = find.byWidgetPredicate(
            (widget) =>
                widget is StatusButton && widget.status == GameStatus.owned,
          );
          expect(
            tester.widget<StatusButton>(ownedButton).isSelected,
            isFalse,
          );

          final label = tester.widget<Text>(
            find.descendant(of: ownedButton, matching: find.text('Owned')),
          );
          final icon = tester.widget<Icon>(
            find.descendant(of: ownedButton, matching: find.byType(Icon)),
          );
          final decoration =
              tester
                      .widget<Container>(
                        find
                            .descendant(
                              of: ownedButton,
                              matching: find.byType(Container),
                            )
                            .first,
                      )
                      .decoration
                  as BoxDecoration;

          expect(label.style?.color, AppColors.expandIcon);
          expect(icon.color, AppColors.expandIcon);
          expect(decoration.gradient, AppGradients.cardGradient);
          expect((decoration.border as Border).top.width, 1);
          expect(
            label.style?.color,
            isNot(equals(AppColors.primaryPurple)),
          );
        },
      );
    });
  });
}
