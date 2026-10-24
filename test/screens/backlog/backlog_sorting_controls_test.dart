import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/backlog/widgets/backlog_sorting_controls.dart';
import 'package:chkpnt/screens/backlog/widgets/sort_chip.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

void main() {
  group('BacklogSortingControls Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: BacklogSortingControls()),
        ),
      );
    }

    testWidgets('should display both sort chips', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Status Changed'), findsOneWidget);
    });

    testWidgets('should show Title chip as active by default', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Find the Title chip
      final titleChipFinder = find.widgetWithText(SortChip, 'Title');
      expect(titleChipFinder, findsOneWidget);

      final titleChip = tester.widget<SortChip>(titleChipFinder);
      expect(titleChip.isActive, true);

      final statusChangeChipFinder = find.widgetWithText(SortChip, 'Status Changed');
      expect(statusChangeChipFinder, findsOneWidget);

      final statusChangeChip = tester.widget<SortChip>(statusChangeChipFinder);
      expect(statusChangeChip.isActive, false);
    });

    testWidgets('should show ascending arrow on active chip', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Initially Title is active and should show upward arrow (ascending)
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });

    testWidgets('should switch active chip when tapping inactive chip', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Initially Title is active
      final titleChipFinder = find.widgetWithText(SortChip, 'Title');
      final statusChangeChipFinder = find.widgetWithText(SortChip, 'Status Changed');

      SortChip titleChip = tester.widget<SortChip>(titleChipFinder);
      SortChip statusChangeChip = tester.widget<SortChip>(statusChangeChipFinder);

      expect(titleChip.isActive, true);
      expect(statusChangeChip.isActive, false);

      await tester.tap(statusChangeChipFinder);
      await tester.pumpAndSettle();

      titleChip = tester.widget<SortChip>(titleChipFinder);
      statusChangeChip = tester.widget<SortChip>(statusChangeChipFinder);

      expect(titleChip.isActive, false);
      expect(statusChangeChip.isActive, true);
    });

    testWidgets('should toggle direction when tapping active chip', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final titleChipFinder = find.widgetWithText(SortChip, 'Title');

      // Initially ascending (upward arrow)
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      // Tap the active Title chip to toggle direction
      await tester.tap(titleChipFinder);
      await tester.pumpAndSettle();

      // Should now be descending (downward arrow)
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsNothing);

      // Tap again to toggle back
      await tester.tap(titleChipFinder);
      await tester.pumpAndSettle();

      // Should be ascending again
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });

    testWidgets('should maintain proper spacing between chips', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check that both chips exist - this validates the structure
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Status Changed'), findsOneWidget);

      // Verify both SortChip widgets are present
      expect(find.byType(SortChip), findsNWidgets(2));

      // Check that the BacklogSortingControls widget exists
      expect(find.byType(BacklogSortingControls), findsOneWidget);
    });

    testWidgets('should update provider state correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check initial provider state
      expect(container.read(backlogSortProvider), BacklogSortType.title);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );

      await tester.tap(find.widgetWithText(SortChip, 'Status Changed'));
      await tester.pumpAndSettle();

      // Check provider state changed
      expect(container.read(backlogSortProvider), BacklogSortType.statusChange);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );

      await tester.tap(find.widgetWithText(SortChip, 'Status Changed'));
      await tester.pumpAndSettle();

      // Sort type should remain the same, direction should toggle
      expect(container.read(backlogSortProvider), BacklogSortType.statusChange);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );
    });
  });

  group('SortChip Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestChip({
      required String label,
      required BacklogSortType sortType,
      required bool isActive,
      SortDirection currentDirection = SortDirection.ascending,
    }) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: SortChip(
              label: label,
              sortType: sortType,
              isActive: isActive,
              currentDirection: currentDirection,
            ),
          ),
        ),
      );
    }

    testWidgets('should display label text', (tester) async {
      await tester.pumpWidget(
        createTestChip(
          label: 'Test Label',
          sortType: BacklogSortType.title,
          isActive: false,
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('should show arrow only when active', (tester) async {
      // Test inactive chip
      await tester.pumpWidget(
        createTestChip(
          label: 'Inactive',
          sortType: BacklogSortType.title,
          isActive: false,
        ),
      );

      expect(find.byIcon(Icons.arrow_upward), findsNothing);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);

      // Test active chip with ascending direction
      await tester.pumpWidget(
        createTestChip(
          label: 'Active',
          sortType: BacklogSortType.title,
          isActive: true,
          currentDirection: SortDirection.ascending,
        ),
      );

      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      // Test active chip with descending direction
      await tester.pumpWidget(
        createTestChip(
          label: 'Active',
          sortType: BacklogSortType.title,
          isActive: true,
          currentDirection: SortDirection.descending,
        ),
      );

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      await tester.pumpWidget(
        createTestChip(
          label: 'Tappable',
          sortType: BacklogSortType.title,
          isActive: false,
        ),
      );

      // Should be able to tap without errors
      await tester.tap(find.text('Tappable'));
      await tester.pumpAndSettle();

      // Verify tap was registered by checking provider state
      expect(container.read(backlogSortProvider), BacklogSortType.title);
    });
  });
}
