import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_actions.dart';

void main() {
  group('GameDetailSheetActions Widget Tests', () {
    late bool editPressed;
    late bool savePressed;

    setUp(() {
      editPressed = false;
      savePressed = false;
    });

    void onEditPressed() {
      editPressed = true;
    }

    void onSavePressed() {
      savePressed = true;
    }

    testWidgets('should render both Edit and Save buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Check that both buttons are present
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Check that the buttons have the correct icons
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('should call onEditPressed when Edit button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Tap the Edit button
      await tester.tap(find.text('Edit Game'));
      await tester.pump();

      expect(editPressed, true);
    });

    testWidgets(
      'should call onSavePressed when Save button is tapped and hasChanges is true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetActions(
                onEditPressed: onEditPressed,
                onSavePressed: onSavePressed,
                hasChanges: true,
              ),
            ),
          ),
        );

        // Tap the Save button - should work since hasChanges is true
        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        expect(savePressed, true);
      },
    );

    testWidgets('should not call onSavePressed when hasChanges is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Tap the Save button - should not work since hasChanges is false
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      expect(savePressed, false);
    });

    testWidgets('should handle null callbacks gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: null,
              onSavePressed: null,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Should render without errors
      expect(tester.takeException(), isNull);

      // Buttons should still be present
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Should render without throwing any exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Verify it's a StatelessWidget (no state management)
      final widget = tester.widget<GameDetailSheetActions>(
        find.byType(GameDetailSheetActions),
      );
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should have proper layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Check that the main widget is present
      expect(find.byType(GameDetailSheetActions), findsOneWidget);

      // Check that both buttons are present
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Check that both button icons are present (more reliable than checking button types)
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('should handle multiple button taps correctly', (
      WidgetTester tester,
    ) async {
      int editCount = 0;
      int saveCount = 0;

      void countingEditPressed() {
        editCount++;
      }

      void countingSavePressed() {
        saveCount++;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: countingEditPressed,
              onSavePressed: countingSavePressed,
              hasChanges: true,
            ),
          ),
        ),
      );

      // Tap Edit button multiple times
      await tester.tap(find.text('Edit Game'));
      await tester.pump();
      await tester.tap(find.text('Edit Game'));
      await tester.pump();

      // Tap Save button multiple times
      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.tap(find.text('Save Changes'));
      await tester.pump();

      expect(editCount, 2);
      expect(saveCount, 2);
    });

    group('Button state tests', () {
      testWidgets('should show enabled Save button when hasChanges is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetActions(
                onEditPressed: onEditPressed,
                onSavePressed: onSavePressed,
                hasChanges: true,
              ),
            ),
          ),
        );

        // Save button should be tappable
        await tester.tap(find.text('Save Changes'));
        await tester.pump();
        expect(savePressed, true);
      });

      testWidgets('should show disabled Save button when hasChanges is false', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetActions(
                onEditPressed: onEditPressed,
                onSavePressed: onSavePressed,
                hasChanges: false,
              ),
            ),
          ),
        );

        // Save button should not trigger callback
        await tester.tap(find.text('Save Changes'));
        await tester.pump();
        expect(savePressed, false);
      });

      testWidgets('should always enable Edit button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetActions(
                onEditPressed: onEditPressed,
                onSavePressed: onSavePressed,
                hasChanges: false,
              ),
            ),
          ),
        );

        // Edit button should always be tappable
        await tester.tap(find.text('Edit Game'));
        await tester.pump();
        expect(editPressed, true);
      });
    });

    testWidgets('should display correct button icons and text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Verify button texts
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Verify button icons
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });
  });
}
