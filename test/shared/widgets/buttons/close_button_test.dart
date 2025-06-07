import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/buttons/close_button.dart';

void main() {
  group('StyledCloseButton Widget Tests', () {
    testWidgets('should render close icon correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StyledCloseButton(onPressed: () {}))),
      );

      // Check that the close icon is displayed
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should trigger onPressed callback when tapped', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledCloseButton(onPressed: () => pressed = true),
          ),
        ),
      );

      // Tap the close button
      await tester.tap(find.byType(StyledCloseButton));

      // Verify the callback was triggered
      expect(pressed, true);
    });

    testWidgets('should render with proper container styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StyledCloseButton(onPressed: () {}))),
      );

      // Find the container with decoration
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(StyledCloseButton),
          matching: find.byType(Container),
        ),
      );

      // Verify that decoration is applied
      expect(container.decoration, isNotNull);
    });

    testWidgets('should render IconButton with correct properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StyledCloseButton(onPressed: () {}))),
      );

      // Find the IconButton
      final iconButton = tester.widget<IconButton>(
        find.descendant(
          of: find.byType(StyledCloseButton),
          matching: find.byType(IconButton),
        ),
      );

      // Verify IconButton properties
      expect(iconButton.onPressed, isNotNull);
      expect(iconButton.icon, isA<Icon>());
      expect(iconButton.iconSize, isNotNull);
      expect(iconButton.padding, isNotNull);
      expect(iconButton.constraints, isNotNull);
    });

    testWidgets('should have correct icon properties', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StyledCloseButton(onPressed: () {}))),
      );

      // Find the Icon widget
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(StyledCloseButton),
          matching: find.byIcon(Icons.close),
        ),
      );

      // Verify icon properties
      expect(icon.icon, Icons.close);
    });

    testWidgets('should work correctly when embedded in different parents', (
      WidgetTester tester,
    ) async {
      int pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Row(
                  children: [StyledCloseButton(onPressed: () => pressCount++)],
                ),
                StyledCloseButton(onPressed: () => pressCount++),
              ],
            ),
          ),
        ),
      );

      // Should find two close buttons
      expect(find.byType(StyledCloseButton), findsNWidgets(2));

      // Tap both buttons
      await tester.tap(find.byType(StyledCloseButton).first);
      await tester.tap(find.byType(StyledCloseButton).last);

      // Verify both callbacks were triggered
      expect(pressCount, 2);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StyledCloseButton(onPressed: () {}))),
      );

      // The IconButton should be tappable
      expect(find.byType(IconButton), findsOneWidget);

      // Should be able to find it by semantics (IconButton has built-in semantics)
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);
    });
  });
}
