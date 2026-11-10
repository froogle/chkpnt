import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';

void main() {
  group('GameImage Widget Tests', () {
    testWidgets('should render correctly with default placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      // Verify the widget renders
      expect(find.byType(GameImage), findsOneWidget);
    });

    testWidgets('should display game icon placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      // Verify game icon is displayed
      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('should have proper styling container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      // Find the main container
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GameImage),
          matching: find.byType(Container),
        ),
      );

      // Verify container has decoration and height constraints
      expect(container.decoration, isNotNull);
    });

    testWidgets('should render with Hero animation when heroTag is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameImage(heroTag: 'test-hero')),
          ),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);

      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, equals('test-hero'));
    });

    testWidgets('should render without Hero when heroTag is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage(heroTag: null))),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byType(Hero), findsNothing);
    });

    testWidgets('should render without Hero when enableHero is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GameImage(heroTag: 'test-hero', enableHero: false),
            ),
          ),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byType(Hero), findsNothing);
    });

    testWidgets('should handle tap when onTap is provided', (
      WidgetTester tester,
    ) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameImage(onTap: () => wasTapped = true)),
          ),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);

      // Tap the widget
      await tester.tap(find.byType(GameImage));
      expect(wasTapped, isTrue);
    });

    testWidgets('should show placeholder when imagePath is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage(imagePath: null))),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('should show placeholder when imagePath is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameImage(imagePath: '')),
          ),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);
      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('should handle imagePath gracefully when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameImage(imagePath: 'game_images/test.jpg')),
          ),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);

      // Wait for the FutureBuilder to complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Check if we can find either the placeholder icon or loading indicator
      final placeholderIcon = find.byIcon(Icons.gamepad);
      final loadingIndicator = find.byType(CircularProgressIndicator);

      // Either should be found (depending on async timing)
      expect(
        placeholderIcon.evaluate().isNotEmpty ||
            loadingIndicator.evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      expect(find.byType(GameImage), findsOneWidget);

      // Check that no exceptions occurred
      final imageWidget = find.byType(GameImage);
      expect(imageWidget, findsOneWidget);
    });

    testWidgets('should be a ConsumerWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      final widget = tester.widget<GameImage>(find.byType(GameImage));
      expect(widget, isA<ConsumerWidget>());
    });

    testWidgets('should maintain consistent appearance', (
      WidgetTester tester,
    ) async {
      // Test multiple renders to ensure consistency
      for (int i = 0; i < 3; i++) {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: Scaffold(body: GameImage())),
          ),
        );

        expect(find.byType(GameImage), findsOneWidget);
        expect(find.byIcon(Icons.gamepad), findsOneWidget);

        await tester.pump();
      }
    });

    testWidgets('should have ClipBehavior.antiAlias for image container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: GameImage())),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GameImage),
          matching: find.byType(Container),
        ),
      );

      expect(container.clipBehavior, equals(Clip.antiAlias));
    });
  });
}
