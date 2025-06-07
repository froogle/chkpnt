import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/shared/widgets/buttons/status_button.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('StatusButton Widget Tests', () {
    testWidgets('should render status button with correct text and icon', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusButton(
              status: GameStatus.playing,
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Check that the text is displayed
      expect(find.text('Playing'), findsOneWidget);

      // Check that the icon is displayed
      expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);

      // Test tap functionality
      await tester.tap(find.byType(StatusButton));
      expect(tapped, true);
    });

    testWidgets('should show selected state styling when isSelected is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusButton(
              status: GameStatus.completed,
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the container with the button decoration
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(StatusButton),
              matching: find.byType(Container),
            )
            .first,
      );

      // Check that decoration is applied (selected state should have blue background)
      expect(container.decoration, isNotNull);
    });

    testWidgets('should show unselected state styling when isSelected is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusButton(
              status: GameStatus.backlog,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the container with the button decoration
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(StatusButton),
              matching: find.byType(Container),
            )
            .first,
      );

      // Check that decoration is applied (unselected state should have grey background)
      expect(container.decoration, isNotNull);
    });

    group('Status-specific tests', () {
      testWidgets('should render Completed status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.completed,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Completed'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });

      testWidgets('should render Playing status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.playing,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Playing'), findsOneWidget);
        expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
      });

      testWidgets('should render Abandoned status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.abandoned,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Abandoned'), findsOneWidget);
        expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
      });

      testWidgets('should render Backlog status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.backlog,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Backlog'), findsOneWidget);
        expect(find.byIcon(Icons.playlist_add), findsOneWidget);
      });

      testWidgets('should render Wishlist status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.wishlist,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Wishlist'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
      });

      testWidgets('should render Ordered status correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatusButton(
                status: GameStatus.ordered,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('Ordered'), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      });
    });

    testWidgets('should respect custom width when provided', (
      WidgetTester tester,
    ) async {
      const customWidth = 150.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusButton(
              status: GameStatus.playing,
              isSelected: false,
              onTap: () {},
              width: customWidth,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(StatusButton),
              matching: find.byType(SizedBox),
            )
            .first,
      );

      expect(sizedBox.width, customWidth);
    });

    testWidgets('should handle multiple status buttons in a list', (
      WidgetTester tester,
    ) async {
      final statuses = [
        GameStatus.wishlist,
        GameStatus.abandoned,
        GameStatus.completed,
        GameStatus.backlog,
        GameStatus.playing,
      ];

      int selectedIndex = 2; // Completed

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children:
                  statuses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final status = entry.value;
                    return StatusButton(
                      status: status,
                      isSelected: index == selectedIndex,
                      onTap: () {},
                    );
                  }).toList(),
            ),
          ),
        ),
      );

      // Check that all statuses are rendered
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);

      // Check that we have the correct number of status buttons
      expect(find.byType(StatusButton), findsNWidgets(5));
    });
  });
}
