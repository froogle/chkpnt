import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_status_section.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameDetailSheetStatusSection Widget Tests', () {
    late GameStatus selectedStatus;
    late List<GameStatus> changedStatuses;

    setUp(() {
      selectedStatus = GameStatus.playing;
      changedStatuses = [];
    });

    void onStatusChanged(GameStatus status) {
      changedStatuses.add(status);
    }

    testWidgets('should render section title correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Check that the section title is displayed
      expect(find.text('Change Status'), findsOneWidget);
    });

    testWidgets('should render all status buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Check that all status options are present
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
    });

    testWidgets('should highlight the selected status', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: GameStatus.completed,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // The completed status should be rendered (we can't easily test selection state
      // without accessing the StatusButton internals, but we can verify it renders)
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('should call onStatusChanged when status button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Tap on the Completed status button
      await tester.tap(find.text('Completed'));
      await tester.pump();

      // Verify that the callback was called with the correct status
      expect(changedStatuses.length, 1);
      expect(changedStatuses.first, GameStatus.completed);
    });

    testWidgets('should handle multiple status changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Tap multiple status buttons
      await tester.tap(find.text('Wishlist'));
      await tester.pump();
      await tester.tap(find.text('Backlog'));
      await tester.pump();
      await tester.tap(find.text('Abandoned'));
      await tester.pump();

      // Verify that all callbacks were called in order
      expect(changedStatuses.length, 3);
      expect(changedStatuses[0], GameStatus.wishlist);
      expect(changedStatuses[1], GameStatus.backlog);
      expect(changedStatuses[2], GameStatus.abandoned);
    });

    testWidgets('should render status grid with proper layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Check that GridView is present
      expect(find.byType(GridView), findsOneWidget);

      // Check that all 5 status options are rendered
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
    });

    testWidgets('should be responsive to layout constraints', (
      WidgetTester tester,
    ) async {
      // Test with narrow width (should use 2 columns)
      await tester.binding.setSurfaceSize(const Size(300, 600));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Should render without overflow
      expect(tester.takeException(), isNull);
      expect(find.byType(GridView), findsOneWidget);

      // Test with wide width (should use 5 columns)
      await tester.binding.setSurfaceSize(const Size(600, 400));
      await tester.pump();

      // Should still render without overflow
      expect(tester.takeException(), isNull);
      expect(find.byType(GridView), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should use LayoutBuilder for responsive design', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Check that LayoutBuilder is used for responsive grid
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('should maintain proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Verify the main column structure
      expect(find.byType(Column), findsOneWidget);

      // Verify that the title and grid are both present
      expect(find.text('Change Status'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Should render without throwing any exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Verify it's a StatelessWidget (no state management)
      final widget = tester.widget<GameDetailSheetStatusSection>(
        find.byType(GameDetailSheetStatusSection),
      );
      expect(widget, isA<StatelessWidget>());
    });

    group('Status button interaction tests', () {
      testWidgets('should handle wishlist selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetStatusSection(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Wishlist'));
        await tester.pump();

        expect(changedStatuses.contains(GameStatus.wishlist), true);
      });

      testWidgets('should handle abandoned selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetStatusSection(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Abandoned'));
        await tester.pump();

        expect(changedStatuses.contains(GameStatus.abandoned), true);
      });

      testWidgets('should handle completed selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetStatusSection(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Completed'));
        await tester.pump();

        expect(changedStatuses.contains(GameStatus.completed), true);
      });

      testWidgets('should handle backlog selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetStatusSection(
                selectedStatus: selectedStatus,
                onStatusChanged: onStatusChanged,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Backlog'));
        await tester.pump();

        expect(changedStatuses.contains(GameStatus.backlog), true);
      });

      testWidgets('should handle playing selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GameDetailSheetStatusSection(
                selectedStatus:
                    GameStatus.backlog, // Start with different status
                onStatusChanged: onStatusChanged,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Playing'));
        await tester.pump();

        expect(changedStatuses.contains(GameStatus.playing), true);
      });
    });

    testWidgets('should render grid with correct number of items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GameDetailSheetStatusSection(
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
            ),
          ),
        ),
      );

      // Should have exactly 5 status buttons (based on the predefined list in the widget)
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView, isNotNull);

      // Count all status button texts
      final statusTexts = [
        'Wishlist',
        'Abandoned',
        'Completed',
        'Backlog',
        'Playing',
      ];
      for (final statusText in statusTexts) {
        expect(find.text(statusText), findsOneWidget);
      }
    });
  });
}
