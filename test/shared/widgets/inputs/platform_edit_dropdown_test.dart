import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/shared/widgets/inputs/platform_edit_dropdown.dart';

void main() {
  group('PlatformEditDropdown', () {
    const testPlatforms = ['Switch', 'PS5', 'Xbox Series', 'PC'];
    const selectedPlatform = 'Switch';

    testWidgets('renders correctly with basic props', (tester) async {
      String? changedPlatform;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: selectedPlatform,
              platforms: testPlatforms,
              onPlatformChanged: (platform) => changedPlatform = platform,
            ),
          ),
        ),
      );

      expect(find.byType(PlatformEditDropdown), findsOneWidget);
      expect(find.text(selectedPlatform), findsOneWidget);
      expect(find.byIcon(Icons.gamepad_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('displays selected platform text', (tester) async {
      const customPlatform = 'Steam Deck';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: customPlatform,
              platforms: testPlatforms,
              onPlatformChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text(customPlatform), findsOneWidget);
    });

    testWidgets('shows platform selection bottom sheet when tapped', (
      tester,
    ) async {
      String? changedPlatform;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: selectedPlatform,
              platforms: testPlatforms,
              onPlatformChanged: (platform) => changedPlatform = platform,
            ),
          ),
        ),
      );

      // Tap the dropdown
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Should show bottom sheet with platform selection
      expect(find.text('Select Platform'), findsOneWidget);
      expect(find.text('Or add a new platform:'), findsOneWidget);
      expect(find.text('Add Custom Platform'), findsOneWidget);

      // Should show existing platforms if any
      if (testPlatforms.isNotEmpty) {
        expect(find.text('Choose from existing:'), findsOneWidget);
        // Should find platform text within the bottom sheet ListTile
        expect(
          find.descendant(
            of: find.byType(ListTile),
            matching: find.text(testPlatforms.first),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets(
      'calls onPlatformChanged when platform is selected from bottom sheet',
      (tester) async {
        String? changedPlatform;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: testPlatforms,
                onPlatformChanged: (platform) => changedPlatform = platform,
              ),
            ),
          ),
        );

        // Tap the dropdown to open bottom sheet
        await tester.tap(find.byType(PlatformEditDropdown));
        await tester.pumpAndSettle();

        // Select a different platform from the bottom sheet ListTile
        const targetPlatform = 'PS5';
        final platformInList = find.descendant(
          of: find.byType(ListTile),
          matching: find.text(targetPlatform),
        );
        await tester.tap(platformInList);
        await tester.pumpAndSettle();

        expect(changedPlatform, equals(targetPlatform));
      },
    );

    group('add mode behaviour', () {
      testWidgets(
        'shows custom platform dialog when platforms list is empty and isAddMode is true',
        (tester) async {
          String? changedPlatform;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PlatformEditDropdown(
                  selectedPlatform: selectedPlatform,
                  platforms: const [], // Empty platforms list
                  onPlatformChanged: (platform) => changedPlatform = platform,
                  isAddMode: true,
                ),
              ),
            ),
          );

          // Tap the dropdown
          await tester.tap(find.byType(PlatformEditDropdown));
          await tester.pumpAndSettle();

          // Should show custom platform dialog instead of bottom sheet
          expect(find.text('Enter Platform'), findsOneWidget);
          expect(find.text('Enter platform name'), findsOneWidget);
          expect(find.text('Cancel'), findsOneWidget);
          expect(find.text('Add'), findsOneWidget);
        },
      );

      testWidgets(
        'shows bottom sheet when platforms list is not empty even in add mode',
        (tester) async {
          String? changedPlatform;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: PlatformEditDropdown(
                  selectedPlatform: selectedPlatform,
                  platforms: testPlatforms, // Non-empty platforms list
                  onPlatformChanged: (platform) => changedPlatform = platform,
                  isAddMode: true,
                ),
              ),
            ),
          );

          // Tap the dropdown
          await tester.tap(find.byType(PlatformEditDropdown));
          await tester.pumpAndSettle();

          // Should show bottom sheet, not dialog
          expect(find.text('Select Platform'), findsOneWidget);
          expect(find.text('Add Custom Platform'), findsOneWidget);
        },
      );
    });

    group('custom platform dialog', () {
      testWidgets('can add custom platform through dialog', (tester) async {
        String? changedPlatform;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: const [],
                onPlatformChanged: (platform) => changedPlatform = platform,
                isAddMode: true,
              ),
            ),
          ),
        );

        // Tap to open dialog
        await tester.tap(find.byType(PlatformEditDropdown));
        await tester.pumpAndSettle();

        // Enter custom platform name
        await tester.enterText(find.byType(TextField), 'Steam Deck');
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        expect(changedPlatform, equals('Steam Deck'));
      });

      testWidgets('can cancel custom platform dialog', (tester) async {
        String? changedPlatform;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: const [],
                onPlatformChanged: (platform) => changedPlatform = platform,
                isAddMode: true,
              ),
            ),
          ),
        );

        // Tap to open dialog
        await tester.tap(find.byType(PlatformEditDropdown));
        await tester.pumpAndSettle();

        // Cancel the dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(changedPlatform, isNull);
      });

      testWidgets('handles empty input gracefully', (tester) async {
        String? changedPlatform;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: const [],
                onPlatformChanged: (platform) => changedPlatform = platform,
                isAddMode: true,
              ),
            ),
          ),
        );

        // Tap to open dialog
        await tester.tap(find.byType(PlatformEditDropdown));
        await tester.pumpAndSettle();

        // Try to add with empty input
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        expect(changedPlatform, isNull);
      });
    });

    group('styling and appearance', () {
      testWidgets('applies correct styling from EditScreenStyles', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: testPlatforms,
                onPlatformChanged: (_) {},
              ),
            ),
          ),
        );

        // Find the container and verify it has styling applied
        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(PlatformEditDropdown),
            matching: find.byType(Container),
          ),
        );

        expect(container.decoration, isNotNull);
        expect(container.padding, isNotNull);
      });

      testWidgets('displays platform icon and dropdown arrow', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformEditDropdown(
                selectedPlatform: selectedPlatform,
                platforms: testPlatforms,
                onPlatformChanged: (_) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.gamepad_outlined), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });
    });
  });
}
