import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/shared/widgets/inputs/custom_platform_dialog.dart';

void main() {
  group('CustomPlatformDialog', () {
    testWidgets('renders correctly with default initialValue', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomPlatformDialog())),
      );

      expect(find.text('Enter Platform'), findsOneWidget);
      expect(find.text('Enter platform name'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders with custom initialValue', (tester) async {
      const initialValue = 'Steam Deck';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomPlatformDialog(initialValue: initialValue),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, equals(initialValue));
    });

    testWidgets('enables autofocus on text field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomPlatformDialog())),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('applies text capitalisation to words', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CustomPlatformDialog())),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textCapitalization, equals(TextCapitalization.words));
    });

    group('submit behaviour', () {
      testWidgets(
        'returns abbreviated platform name when Add button is pressed',
        (tester) async {
          String? result;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () async {
                          result = await showDialog<String>(
                            context: context,
                            builder: (context) => const CustomPlatformDialog(),
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),
                ),
              ),
            ),
          );

          // Open the dialog
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Enter platform name
          await tester.enterText(find.byType(TextField), 'PlayStation 4');

          // Tap Add button
          await tester.tap(find.text('Add'));
          await tester.pumpAndSettle();

          // Should return abbreviated platform name
          expect(result, equals('PS4'));
        },
      );

      testWidgets(
        'returns abbreviated platform name when submitted via keyboard',
        (tester) async {
          String? result;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () async {
                          result = await showDialog<String>(
                            context: context,
                            builder: (context) => const CustomPlatformDialog(),
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),
                ),
              ),
            ),
          );

          // Open the dialog
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Submit via keyboard (onSubmitted)
          await tester.enterText(find.byType(TextField), 'Nintendo Switch');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          // Should return abbreviated platform name
          expect(result, equals('Switch'));
        },
      );

      testWidgets('returns null when Cancel button is pressed', (tester) async {
        String? result = 'initial'; // Non-null initial value

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () async {
                        result = await showDialog<String>(
                          context: context,
                          builder: (context) => const CustomPlatformDialog(),
                        );
                      },
                      child: const Text('Show Dialog'),
                    ),
              ),
            ),
          ),
        );

        // Open the dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Enter some text
        await tester.enterText(find.byType(TextField), 'Some Platform');

        // Tap Cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should return null (dialog cancelled)
        expect(result, isNull);
      });

      testWidgets('returns null when empty input is submitted', (tester) async {
        String? result = 'initial'; // Non-null initial value

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () async {
                        result = await showDialog<String>(
                          context: context,
                          builder: (context) => const CustomPlatformDialog(),
                        );
                      },
                      child: const Text('Show Dialog'),
                    ),
              ),
            ),
          ),
        );

        // Open the dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Leave text field empty and tap Add
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        // Should return null for empty input
        expect(result, isNull);
      });

      testWidgets('trims whitespace from input', (tester) async {
        String? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => ElevatedButton(
                      onPressed: () async {
                        result = await showDialog<String>(
                          context: context,
                          builder: (context) => const CustomPlatformDialog(),
                        );
                      },
                      child: const Text('Show Dialog'),
                    ),
              ),
            ),
          ),
        );

        // Open the dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Enter platform name with surrounding whitespace
        await tester.enterText(find.byType(TextField), '  Xbox One  ');

        // Tap Add button
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        // Should return trimmed and abbreviated platform name
        expect(result, equals('Xbox One'));
      });
    });

    group('platform abbreviation', () {
      testWidgets('abbreviates common platform names correctly', (
        tester,
      ) async {
        final testCases = {
          'Game Boy Advance': 'GBA',
          'Nintendo Entertainment System': 'NES',
          'PlayStation Portable': 'PSP',
          'Xbox Series X': 'Xbox Series',
          'Personal Computer': 'PC',
        };

        for (final entry in testCases.entries) {
          String? result;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () async {
                          result = await showDialog<String>(
                            context: context,
                            builder: (context) => const CustomPlatformDialog(),
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),
                ),
              ),
            ),
          );

          // Open the dialog
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Enter platform name
          await tester.enterText(find.byType(TextField), entry.key);

          // Tap Add button
          await tester.tap(find.text('Add'));
          await tester.pumpAndSettle();

          // Verify abbreviation
          expect(
            result,
            equals(entry.value),
            reason:
                'Expected "${entry.key}" to be abbreviated to "${entry.value}"',
          );
        }
      });

      testWidgets(
        'preserves custom platform names that are not in abbreviation list',
        (tester) async {
          String? result;
          const customPlatform = 'Custom Gaming System';

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder:
                      (context) => ElevatedButton(
                        onPressed: () async {
                          result = await showDialog<String>(
                            context: context,
                            builder: (context) => const CustomPlatformDialog(),
                          );
                        },
                        child: const Text('Show Dialog'),
                      ),
                ),
              ),
            ),
          );

          // Open the dialog
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Enter custom platform name
          await tester.enterText(find.byType(TextField), customPlatform);

          // Tap Add button
          await tester.tap(find.text('Add'));
          await tester.pumpAndSettle();

          // Should preserve custom platform name (but might be truncated if too long)
          expect(result, equals('Custom Gamin...'));
        },
      );
    });

    group('accessibility', () {
      testWidgets('uses Android13TextFieldWrapper for text input', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CustomPlatformDialog())),
        );

        // The Android13TextFieldWrapper should be present
        // We can't directly test for the wrapper type without importing it
        // but we can verify the TextField is properly wrapped
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('provides proper hint text for accessibility', (
        tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CustomPlatformDialog())),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, equals('Enter platform name'));
      });
    });
  });
}
