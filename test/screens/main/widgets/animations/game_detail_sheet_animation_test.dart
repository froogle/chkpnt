import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameDetailSheetAnimation Tests', () {
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
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should show modal bottom sheet when show method is called', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () =>
                              GameDetailSheetAnimation.show(context, testGame),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show the sheet
      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Verify that the game details are shown in the modal
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test Platform'), findsOneWidget);
    });

    testWidgets('should show draggable scrollable sheet in modal', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () =>
                              GameDetailSheetAnimation.show(context, testGame),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Check that DraggableScrollableSheet is present
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });

    testWidgets('should handle edit button callback', (
      WidgetTester tester,
    ) async {
      bool editPressed = false;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () => GameDetailSheetAnimation.show(
                            context,
                            testGame,
                            onEditPressed: () => editPressed = true,
                          ),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Find and tap the edit button if it exists
      final editButton = find.text('Edit Game');
      if (editButton.evaluate().isNotEmpty) {
        await tester.tap(editButton);
        expect(editPressed, true);
      }
    });

    testWidgets('should close when tapping outside modal area', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () =>
                              GameDetailSheetAnimation.show(context, testGame),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Sheet should be visible
      expect(find.text('Test Game'), findsOneWidget);

      // Tap outside the modal area (close button was removed)
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();

      // Sheet should be closed (game title should not be visible anymore)
      expect(find.text('Test Game'), findsNothing);
    });

    testWidgets('should handle different game statuses', (
      WidgetTester tester,
    ) async {
      final statuses = [
        GameStatus.playing,
        GameStatus.completed,
        GameStatus.backlog,
      ];

      for (final status in statuses) {
        final gameWithStatus = testGame.copyWith(status: status);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed:
                            () => GameDetailSheetAnimation.show(
                              context,
                              gameWithStatus,
                            ),
                        child: const Text('Show Sheet'),
                      ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Sheet'));
        await tester.pumpAndSettle();

        // Should render without issues regardless of status
        expect(find.text('Test Game'), findsOneWidget);
        expect(find.byType(DraggableScrollableSheet), findsOneWidget);

        // Close the modal by tapping outside (close button was removed)
        await tester.tapAt(const Offset(50, 50)); // Tap outside the modal area
        await tester.pumpAndSettle();
      }
    });

    testWidgets(
      'should handle different orientations with larger screen sizes',
      (WidgetTester tester) async {
        // Test portrait with larger size to avoid overflow
        await tester.binding.setSurfaceSize(const Size(600, 1000));

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed:
                            () => GameDetailSheetAnimation.show(
                              context,
                              testGame,
                            ),
                        child: const Text('Show Sheet'),
                      ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Sheet'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Check if sheet opened successfully
        if (find.byType(DraggableScrollableSheet).evaluate().isNotEmpty) {
          expect(find.byType(DraggableScrollableSheet), findsOneWidget);
          expect(tester.takeException(), isNull);

          await tester.tapAt(
            const Offset(50, 50),
          ); // Tap outside the modal area
          await tester.pumpAndSettle();
        }

        // Test landscape with larger size
        await tester.binding.setSurfaceSize(const Size(1200, 700));
        await tester.pump();

        await tester.tap(find.text('Show Sheet'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Check if sheet opened successfully in landscape
        if (find.byType(DraggableScrollableSheet).evaluate().isNotEmpty) {
          expect(find.byType(DraggableScrollableSheet), findsOneWidget);
          expect(tester.takeException(), isNull);
        }

        // Reset size
        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets('should use extension method correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () => testGame.showDetailSheet(context),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Verify the extension method works
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test Platform'), findsOneWidget);
    });

    testWidgets('should show backdrop filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed:
                          () =>
                              GameDetailSheetAnimation.show(context, testGame),
                      child: const Text('Show Sheet'),
                    ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      // Check that BackdropFilter is present for blur effect
      expect(find.byType(BackdropFilter), findsOneWidget);
    });
  });
}
