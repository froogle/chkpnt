import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/edit/widgets/platform_entry_screen.dart';
import 'package:chkpnt/styles/platform_entry_styles.dart';

void main() {
  group('PlatformEntryScreen', () {
    testWidgets('renders correctly with default props', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      expect(find.byType(PlatformEntryScreen), findsOneWidget);
      expect(find.text('Enter Platform'), findsOneWidget);
      expect(find.text('Platform Name'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text(PlatformEntryStyles.primaryButtonText), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders correctly with initial platform', (tester) async {
      const initialPlatform = 'Nintendo Switch';

      await tester.pumpWidget(
        const MaterialApp(
          home: PlatformEntryScreen(initialPlatform: initialPlatform),
        ),
      );

      expect(find.byType(PlatformEntryScreen), findsOneWidget);

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, equals(initialPlatform));
    });

    testWidgets('close button navigates back', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PlatformEntryScreen(),
                  ),
                ),
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      expect(find.byType(PlatformEntryScreen), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(PlatformEntryScreen), findsNothing);
      expect(find.text('Open Platform Entry'), findsOneWidget);
    });

    testWidgets('save button is disabled when text is empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final saveButton = find.widgetWithText(TextButton, 'Save');
      expect(saveButton, findsOneWidget);

      final textButton = tester.widget<TextButton>(saveButton);
      expect(textButton.onPressed, isNull);
    });

    testWidgets('save button is disabled when text is only whitespace', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final textField = find.byType(TextField);
      await tester.enterText(textField, '   ');
      await tester.pump();

      final saveButton = find.widgetWithText(TextButton, 'Save');
      final textButton = tester.widget<TextButton>(saveButton);
      expect(textButton.onPressed, isNull);
    });

    testWidgets('save button is enabled when text is provided', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'PS5');
      await tester.pump();

      final saveButton = find.widgetWithText(TextButton, 'Save');
      final textButton = tester.widget<TextButton>(saveButton);
      expect(textButton.onPressed, isNotNull);
    });

    testWidgets('primary button is disabled when text is empty', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final primaryButton = find.widgetWithText(
        ElevatedButton,
        PlatformEntryStyles.primaryButtonText,
      );
      expect(primaryButton, findsOneWidget);

      final elevatedButton = tester.widget<ElevatedButton>(primaryButton);
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('primary button is enabled when text is provided', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Xbox Series X');
      await tester.pump();

      final primaryButton = find.widgetWithText(
        ElevatedButton,
        PlatformEntryStyles.primaryButtonText,
      );
      final elevatedButton = tester.widget<ElevatedButton>(primaryButton);
      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('save button returns platform text when pressed', (
      tester,
    ) async {
      const testPlatform = 'PC';
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const PlatformEntryScreen(),
                    ),
                  );
                },
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      // Enter platform text
      await tester.enterText(find.byType(TextField), testPlatform);
      await tester.pump();

      // Tap save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(result, equals(testPlatform));
    });

    testWidgets('primary button returns platform text when pressed', (
      tester,
    ) async {
      const testPlatform = 'Steam Deck';
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const PlatformEntryScreen(),
                    ),
                  );
                },
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      // Enter platform text
      await tester.enterText(find.byType(TextField), testPlatform);
      await tester.pump();

      // Tap primary button
      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          PlatformEntryStyles.primaryButtonText,
        ),
      );
      await tester.pumpAndSettle();

      expect(result, equals(testPlatform));
    });

    testWidgets('text field submission triggers save when valid', (
      tester,
    ) async {
      const testPlatform = 'Nintendo 3DS';
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const PlatformEntryScreen(),
                    ),
                  );
                },
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      // Enter platform text and submit
      await tester.enterText(find.byType(TextField), testPlatform);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(result, equals(testPlatform));
    });

    testWidgets('text field submission does nothing when empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PlatformEntryScreen(),
                  ),
                ),
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      expect(find.byType(PlatformEntryScreen), findsOneWidget);

      // Submit empty text field
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Should still be on platform entry screen
      expect(find.byType(PlatformEntryScreen), findsOneWidget);
    });

    testWidgets('platform text is trimmed when saved', (tester) async {
      const testPlatform = '  PlayStation 5  ';
      const expectedResult = 'PlayStation 5';
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const PlatformEntryScreen(),
                    ),
                  );
                },
                child: const Text('Open Platform Entry'),
              ),
            ),
          ),
        ),
      );

      // Navigate to platform entry screen
      await tester.tap(find.text('Open Platform Entry'));
      await tester.pumpAndSettle();

      // Enter platform text with whitespace
      await tester.enterText(find.byType(TextField), testPlatform);
      await tester.pump();

      // Tap save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(result, equals(expectedResult));
    });

    testWidgets('text input has correct capitalization', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textCapitalization, equals(TextCapitalization.words));
    });

    testWidgets('displays help text correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      expect(find.text(PlatformEntryStyles.helpText), findsOneWidget);
    });

    testWidgets('app bar has correct styling', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(
        appBar.backgroundColor,
        equals(PlatformEntryStyles.appBarBackgroundColor),
      );
      expect(appBar.elevation, equals(PlatformEntryStyles.appBarElevation));
      expect(
        appBar.surfaceTintColor,
        equals(PlatformEntryStyles.appBarSurfaceTintColor),
      );
    });

    testWidgets('text field has correct styling', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PlatformEntryScreen()));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style, equals(PlatformEntryStyles.textInputStyle));
      expect(
        textField.decoration?.hintText,
        equals(PlatformEntryStyles.inputHintText),
      );
    });
  });
}
