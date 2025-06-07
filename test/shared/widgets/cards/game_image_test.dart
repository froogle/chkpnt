import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';

void main() {
  group('GameImage Widget Tests', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameImage())),
      );

      // Verify the widget renders
      expect(find.byType(GameImage), findsOneWidget);
    });

    testWidgets('should display game icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameImage())),
      );

      // Verify game icon is displayed
      expect(find.byIcon(Icons.gamepad), findsOneWidget);
    });

    testWidgets('should have proper styling container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameImage())),
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
      expect(container.constraints, isNotNull);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameImage())),
      );

      expect(find.byType(GameImage), findsOneWidget);

      // Check that no exceptions occurred
      final imageWidget = find.byType(GameImage);
      expect(imageWidget, findsOneWidget);
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameImage())),
      );

      final widget = tester.widget<GameImage>(find.byType(GameImage));
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should maintain consistent appearance', (
      WidgetTester tester,
    ) async {
      // Test multiple renders to ensure consistency
      for (int i = 0; i < 3; i++) {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: GameImage())),
        );

        expect(find.byType(GameImage), findsOneWidget);
        expect(find.byIcon(Icons.gamepad), findsOneWidget);

        await tester.pump();
      }
    });
  });
}
