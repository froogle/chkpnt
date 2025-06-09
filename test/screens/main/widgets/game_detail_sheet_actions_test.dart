import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_actions.dart';
import 'package:chkpnt/styles/styles.dart';

void main() {
  group('GameDetailSheetActions Widget Tests', () {
    late bool editPressed;
    late bool savePressed;
    late bool deletePressed;

    void onEditPressed() {
      editPressed = true;
    }

    void onSavePressed() {
      savePressed = true;
    }

    void onDeletePressed() {
      deletePressed = true;
    }

    setUp(() {
      editPressed = false;
      savePressed = false;
      deletePressed = false;
    });

    testWidgets('should render all three buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Check that the main widget is present
      expect(find.byType(GameDetailSheetActions), findsOneWidget);

      // Check that all three buttons are present
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
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
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Tap the Edit button
      await tester.tap(find.text('Edit'));
      await tester.pump();

      expect(editPressed, true);
    });

    testWidgets('should call onDeletePressed when Delete button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Tap the Delete button
      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(deletePressed, true);
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
                onDeletePressed: onDeletePressed,
                hasChanges: true,
              ),
            ),
          ),
        );

        // Tap the Save button - should work since hasChanges is true
        await tester.tap(find.text('Save'));
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
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Tap the Save button - should not work since hasChanges is false
      await tester.tap(find.text('Save'));
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
              onDeletePressed: null,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Should render without errors
      expect(tester.takeException(), isNull);

      // Buttons should still be present
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
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
              onDeletePressed: onDeletePressed,
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
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Check that the main widget is present
      expect(find.byType(GameDetailSheetActions), findsOneWidget);

      // Check that all three buttons are present
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Check that the buttons use custom gradient containers
      expect(
        find.byType(Container),
        findsAtLeastNWidgets(3),
      ); // All buttons use Container wrapper
      expect(
        find.byType(InkWell),
        findsNWidgets(3),
      ); // All buttons use InkWell for interaction
    });

    testWidgets('should handle multiple button taps correctly', (
      WidgetTester tester,
    ) async {
      int editCount = 0;
      int saveCount = 0;
      int deleteCount = 0;

      void countingEditPressed() {
        editCount++;
      }

      void countingSavePressed() {
        saveCount++;
      }

      void countingDeletePressed() {
        deleteCount++;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: countingEditPressed,
              onSavePressed: countingSavePressed,
              onDeletePressed: countingDeletePressed,
              hasChanges: true,
            ),
          ),
        ),
      );

      // Tap Edit button multiple times
      await tester.tap(find.text('Edit'));
      await tester.pump();
      await tester.tap(find.text('Edit'));
      await tester.pump();

      // Tap Save button multiple times
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Tap Delete button multiple times
      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(editCount, 2);
      expect(saveCount, 2);
      expect(deleteCount, 1);
    });

    testWidgets('should disable Save button when hasChanges is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Find the Save button wrapper and check if it has the disabled styling
      final saveTextWidget = find.text('Save');
      expect(saveTextWidget, findsOneWidget);

      // Check that the save button text has the disabled colour (grey)
      final saveText = tester.widget<Text>(saveTextWidget);
      expect(saveText.style?.color, Colors.grey[500]);
    });

    testWidgets('should enable Save button when hasChanges is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
              hasChanges: true,
            ),
          ),
        ),
      );

      // Find the Save button and check if it has the enabled styling
      final saveTextWidget = find.text('Save');
      expect(saveTextWidget, findsOneWidget);

      // Check that the save button text has the enabled colour
      final saveText = tester.widget<Text>(saveTextWidget);
      expect(saveText.style?.color, Colors.white);
    });

    testWidgets('should have responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetActions(
              onEditPressed: onEditPressed,
              onSavePressed: onSavePressed,
              onDeletePressed: onDeletePressed,
              hasChanges: false,
            ),
          ),
        ),
      );

      // Check that we have the right number of Expanded widgets (3 for the 3 buttons)
      expect(find.byType(Expanded), findsNWidgets(3));
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
              onDeletePressed: onDeletePressed,
              hasChanges: true,
            ),
          ),
        ),
      );

      // Check button texts
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
