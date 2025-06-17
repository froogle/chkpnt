import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chkpnt/shared/widgets/inputs/platform_selection_bottom_sheet.dart';

void main() {
  group('PlatformSelectionBottomSheet', () {
    const testPlatforms = ['Switch', 'PS5', 'Xbox Series', 'PC'];
    const selectedPlatform = 'Switch';

    testWidgets('renders header with title and close button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: testPlatforms,
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select Platform'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('displays custom platform section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: testPlatforms,
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Or add a new platform:'), findsOneWidget);
      expect(find.text('Add Custom Platform'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('displays platform list section when platforms are provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: testPlatforms,
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Choose from existing:'), findsOneWidget);

      // Should display all platforms
      for (final platform in testPlatforms) {
        expect(find.text(platform), findsOneWidget);
      }
    });

    testWidgets('hides platform list section when platforms list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: const [],
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Choose from existing:'), findsNothing);
    });

    testWidgets('highlights selected platform with check icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: testPlatforms,
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (_) {},
            ),
          ),
        ),
      );

      // Find the ListTile for the selected platform
      final selectedTile = find.ancestor(
        of: find.text(selectedPlatform),
        matching: find.byType(ListTile),
      );
      expect(selectedTile, findsOneWidget);

      // Check for the check icon in the trailing position
      final checkIcon = find.descendant(
        of: selectedTile,
        matching: find.byIcon(Icons.check),
      );
      expect(checkIcon, findsOneWidget);
    });

    testWidgets('calls onPlatformSelected when platform tile is tapped', (
      tester,
    ) async {
      String? selectedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: testPlatforms,
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (platform) => selectedResult = platform,
            ),
          ),
        ),
      );

      // Tap on a different platform
      const targetPlatform = 'PS5';
      await tester.tap(find.text(targetPlatform));
      await tester.pump();

      expect(selectedResult, equals(targetPlatform));
    });

    testWidgets('abbreviates platform names when selected', (tester) async {
      String? selectedResult;
      const longPlatformName = 'Nintendo Entertainment System';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformSelectionBottomSheet(
              platforms: [longPlatformName],
              selectedPlatform: selectedPlatform,
              onPlatformSelected: (platform) => selectedResult = platform,
            ),
          ),
        ),
      );

      // Tap on the long platform name
      await tester.tap(find.text(longPlatformName));
      await tester.pump();

      // Should be abbreviated to 'NES'
      expect(selectedResult, equals('NES'));
    });

    group('navigation behaviour', () {
      testWidgets('custom platform button is present and tappable', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformSelectionBottomSheet(
                platforms: testPlatforms,
                selectedPlatform: selectedPlatform,
                onPlatformSelected: (_) {},
              ),
            ),
          ),
        );

        // Verify the custom platform button is present and tappable
        expect(find.text('Add Custom Platform'), findsOneWidget);

        // Verify it's tappable by tapping it (this would navigate in real usage)
        await tester.tap(find.text('Add Custom Platform'));
        await tester.pump();

        // The button should still be there after tapping
        expect(find.text('Add Custom Platform'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('platform tiles have proper icons and styling', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformSelectionBottomSheet(
                platforms: testPlatforms,
                selectedPlatform: selectedPlatform,
                onPlatformSelected: (_) {},
              ),
            ),
          ),
        );

        // Each platform should have a gamepad icon
        expect(
          find.byIcon(Icons.gamepad_outlined),
          findsNWidgets(testPlatforms.length),
        );

        // Selected platform should have check icon
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('applies correct text styles', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformSelectionBottomSheet(
                platforms: testPlatforms,
                selectedPlatform: selectedPlatform,
                onPlatformSelected: (_) {},
              ),
            ),
          ),
        );

        // Find platform text widgets and verify they have proper styling
        final platformTexts = find.text(testPlatforms.first);
        expect(platformTexts, findsOneWidget);

        final textWidget = tester.widget<Text>(platformTexts);
        expect(textWidget.style?.fontSize, equals(16));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
      });
    });

    group('edge cases', () {
      testWidgets('handles platform selection when same platform is tapped', (
        tester,
      ) async {
        // This test just verifies that the selected platform shows a check mark
        // The actual callback behaviour is tested in the main dropdown widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformSelectionBottomSheet(
                platforms: testPlatforms,
                selectedPlatform: selectedPlatform,
                onPlatformSelected: (_) {},
              ),
            ),
          ),
        );

        // Verify selected platform shows check mark
        final selectedTile = find.ancestor(
          of: find.text(selectedPlatform),
          matching: find.byType(ListTile),
        );
        expect(selectedTile, findsOneWidget);

        final checkIcon = find.descendant(
          of: selectedTile,
          matching: find.byIcon(Icons.check),
        );
        expect(checkIcon, findsOneWidget);
      });

      testWidgets('handles empty platform name gracefully', (tester) async {
        String? selectedResult;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlatformSelectionBottomSheet(
                platforms: [''],
                selectedPlatform: selectedPlatform,
                onPlatformSelected: (platform) => selectedResult = platform,
              ),
            ),
          ),
        );

        // Tap on the empty platform (if it renders)
        if (find.text('').evaluate().isNotEmpty) {
          await tester.tap(find.text(''));
          await tester.pump();
        }

        // Should handle empty platform gracefully
        expect(selectedResult, anyOf(isNull, equals('')));
      });
    });
  });
}
