import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/buttons/platform_badge.dart';

void main() {
  group('PlatformBadge Widget Tests', () {
    testWidgets('should render platform text correctly', (
      WidgetTester tester,
    ) async {
      const platformName = 'Nintendo Switch';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PlatformBadge(platform: platformName)),
        ),
      );

      // Check that the platform text is displayed
      expect(find.text(platformName), findsOneWidget);
    });

    testWidgets('should render with proper ink styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PlatformBadge(platform: 'PS5'))),
      );

      // Find the ink widget with styling
      final ink = tester.widget<Ink>(
        find.descendant(
          of: find.byType(PlatformBadge),
          matching: find.byType(Ink),
        ),
      );

      // Verify that decoration is applied
      expect(ink.decoration, isNotNull);
      expect(ink.padding, isNotNull);
    });

    testWidgets(
      'should have proper Material and InkWell structure for visual feedback',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: PlatformBadge(platform: 'PS5')),
          ),
        );

        // Verify Material widget is present for ink effects
        expect(
          find.descendant(
            of: find.byType(PlatformBadge),
            matching: find.byType(Material),
          ),
          findsOneWidget,
        );

        // Verify InkWell is present for tap interactions
        expect(
          find.descendant(
            of: find.byType(PlatformBadge),
            matching: find.byType(InkWell),
          ),
          findsOneWidget,
        );

        // Verify Ink widget is present for proper decoration layering
        expect(
          find.descendant(
            of: find.byType(PlatformBadge),
            matching: find.byType(Ink),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('should handle various platform names', (
      WidgetTester tester,
    ) async {
      final platforms = ['PC', 'PS5', 'Xbox', 'Steam Deck', 'Nintendo Switch'];

      for (final platform in platforms) {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: PlatformBadge(platform: platform))),
        );

        expect(find.text(platform), findsOneWidget);
      }
    });

    testWidgets('should handle empty platform name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PlatformBadge(platform: ''))),
      );

      // Should still render but with empty text
      expect(find.byType(PlatformBadge), findsOneWidget);
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should handle long platform names', (
      WidgetTester tester,
    ) async {
      const longPlatform = 'PlayStation 5 Digital Edition';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PlatformBadge(platform: longPlatform)),
        ),
      );

      expect(find.text(longPlatform), findsOneWidget);
    });

    testWidgets('should render multiple platform badges correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PlatformBadge(platform: 'PC'),
                PlatformBadge(platform: 'PS5'),
                PlatformBadge(platform: 'Xbox'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('PC'), findsOneWidget);
      expect(find.text('PS5'), findsOneWidget);
      expect(find.text('Xbox'), findsOneWidget);
      expect(find.byType(PlatformBadge), findsNWidgets(3));
    });

    testWidgets('should call onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlatformBadge(
              platform: 'PS5',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the platform badge
      await tester.tap(find.byType(PlatformBadge));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should not crash when onTap is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PlatformBadge(platform: 'PS5'))),
      );

      // Tap the platform badge - should not crash
      await tester.tap(find.byType(PlatformBadge));
      await tester.pump();

      // Should still display the platform
      expect(find.text('PS5'), findsOneWidget);
    });
  });
}
