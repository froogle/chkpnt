import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/shared/widgets/inputs/platform_edit_dropdown.dart';

void main() {
  group('PlatformEditDropdown', () {
    const testPlatforms = ['PS5', 'Switch', 'PC', 'Xbox'];
    const selectedPlatform = 'PS5';

    testWidgets('renders correctly with selected platform', (tester) async {
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

      expect(find.byType(PlatformEditDropdown), findsOneWidget);
      expect(find.text(selectedPlatform), findsOneWidget);
      expect(find.byIcon(Icons.gamepad_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('shows bottom sheet when tapped', (tester) async {
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

      // Tap the dropdown
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Should show bottom sheet
      expect(find.text('Select Platform'), findsOneWidget);
      expect(find.text('Or add a new platform:'), findsOneWidget);
      expect(find.text('Choose from existing:'), findsOneWidget);
    });

    testWidgets('displays all available platforms in bottom sheet', (
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

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Check all platforms are displayed in the list
      for (final platform in testPlatforms) {
        final platformInList = find.descendant(
          of: find.byType(ListTile),
          matching: find.text(platform),
        );
        expect(platformInList, findsOneWidget);
      }
    });

    testWidgets('highlights selected platform in list', (tester) async {
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

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Selected platform should have a check icon
      final selectedTile = find.ancestor(
        of: find.text(selectedPlatform),
        matching: find.byType(ListTile),
      );
      expect(selectedTile, findsOneWidget);

      // Check for check icon in the selected tile
      final checkIcon = find.descendant(
        of: selectedTile,
        matching: find.byIcon(Icons.check),
      );
      expect(checkIcon, findsOneWidget);
    });

    testWidgets('calls onPlatformChanged when platform is selected', (
      tester,
    ) async {
      String? changedPlatform;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: selectedPlatform,
              platforms: testPlatforms,
              onPlatformChanged: (platform) {
                changedPlatform = platform;
              },
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Tap on a different platform in the list
      final switchInList = find.descendant(
        of: find.byType(ListTile),
        matching: find.text('Switch'),
      );
      await tester.tap(switchInList);
      await tester.pumpAndSettle();

      expect(changedPlatform, equals('Switch'));
    });

    testWidgets('allows custom platform input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: selectedPlatform,
              platforms: testPlatforms,
              onPlatformChanged: (platform) {
                // Platform changed callback
              },
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Tap the custom platform button should navigate to PlatformEntryScreen
      await tester.tap(find.text('Add Custom Platform'));
      await tester.pumpAndSettle();

      // Should navigate to the platform entry screen
      expect(find.text('Enter Platform'), findsOneWidget);
    });

    testWidgets('closes bottom sheet when close button is tapped', (
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

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      expect(find.text('Select Platform'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Bottom sheet should be closed
      expect(find.text('Select Platform'), findsNothing);
    });

    testWidgets('handles empty platforms list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformEditDropdown(
              selectedPlatform: selectedPlatform,
              platforms: const [],
              onPlatformChanged: (_) {},
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.byType(PlatformEditDropdown));
      await tester.pumpAndSettle();

      // Should still show custom input section
      expect(find.text('Or add a new platform:'), findsOneWidget);
      // But not the existing platforms section
      expect(find.text('Choose from existing:'), findsNothing);
    });
  });
}
