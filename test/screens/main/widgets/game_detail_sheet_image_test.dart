import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_image.dart';

void main() {
  group('GameDetailSheetImage Widget Tests', () {
    testWidgets('should render image container with correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Check that the widget renders
      expect(find.byType(GameDetailSheetImage), findsOneWidget);

      // Check that the main container is present
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should display gamepad icon placeholder', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Check that the gamepad icon is displayed
      expect(find.byIcon(Icons.gamepad), findsOneWidget);

      // Verify the icon has the correct properties
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.gamepad));
      expect(iconWidget.icon, Icons.gamepad);
      expect(iconWidget.color, Colors.grey);
    });

    testWidgets('should have correct icon styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Find the icon widget
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.gamepad));

      // Check that the icon has the correct colour
      expect(iconWidget.color, Colors.grey);

      // The size should be set by the styles (we can't easily test the exact value
      // without importing the styles, but we can verify it's not null)
      expect(iconWidget.size, isNotNull);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Should render without throwing any exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('should maintain proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Verify the main components are present
      expect(find.byType(GameDetailSheetImage), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.gamepad), findsOneWidget);

      // Verify the icon is properly nested within the widget
      final imageWidget = find.byType(GameDetailSheetImage);
      final iconInImage = find.descendant(
        of: imageWidget,
        matching: find.byIcon(Icons.gamepad),
      );
      expect(iconInImage, findsOneWidget);
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GameDetailSheetImage())),
      );

      // Verify it's a StatelessWidget (no state management)
      final widget = tester.widget<GameDetailSheetImage>(
        find.byType(GameDetailSheetImage),
      );
      expect(widget, isA<StatelessWidget>());
    });
  });
}
