import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/widgets/profile_visualisation_section.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('ProfileVisualisationSection', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createWidget() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Scaffold(body: const ProfileVisualisationSection()),
        ),
      );
    }

    testWidgets('displays empty state when no games', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('No data to visualise'), findsOneWidget);
      expect(
        find.text('Add some games to see your library statistics'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.pie_chart_outline), findsOneWidget);
    });

    testWidgets('displays segmented control', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('switches between platform and status view', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Initially should be on platform view
      final platformButton = find.text('Platform');
      final statusButton = find.text('Status');

      expect(platformButton, findsOneWidget);
      expect(statusButton, findsOneWidget);

      // Tap status button
      await tester.tap(statusButton);
      await tester.pumpAndSettle();

      // Should still show both buttons (segmented control)
      expect(platformButton, findsOneWidget);
      expect(statusButton, findsOneWidget);
    });

    group('with sample games', () {
      late List<GameItem> sampleGames;

      setUp(() {
        sampleGames = [
          GameItem.create(
            title: 'Test Game 1',
            platform: 'PC',
            status: GameStatus.playing,
          ),
          GameItem.create(
            title: 'Test Game 2',
            platform: 'PlayStation 5',
            status: GameStatus.completed,
          ),
          GameItem.create(
            title: 'Test Game 3',
            platform: 'PC',
            status: GameStatus.backlog,
          ),
        ];

        // Override the gameListProvider for testing
        container = ProviderContainer(
          overrides: [gameListProvider.overrideWith((ref) => sampleGames)],
        );
      });

      testWidgets('displays chart when games exist', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Should not show empty state
        expect(find.text('No data to visualise'), findsNothing);

        // Should show chart elements
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('displays legend with game counts', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Should show legend items - at least PC should appear since it has 2 games
        expect(find.textContaining('PC'), findsOneWidget);
        expect(find.textContaining('PlayStation 5'), findsOneWidget);
      });

      testWidgets('legend shows correct counts', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // PC should show count of 2, PlayStation 5 should show count of 1
        expect(find.text('PC (2)'), findsOneWidget);
        expect(find.text('PlayStation 5 (1)'), findsOneWidget);
      });

      testWidgets('status view shows different data', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Switch to status view
        await tester.tap(find.text('Status'));
        await tester.pumpAndSettle();

        // Should show status-based legend
        expect(find.text('Playing (1)'), findsOneWidget);
        expect(find.text('Completed (1)'), findsOneWidget);
        expect(find.text('Backlog (1)'), findsOneWidget);
      });
    });

    group('ChartData', () {
      test('creates chart data correctly', () {
        final chartData = ChartData('Test', 5, Colors.red);

        expect(chartData.label, equals('Test'));
        expect(chartData.count, equals(5));
        expect(chartData.color, equals(Colors.red));
      });
    });

    group('ChartViewMode', () {
      test('has correct values', () {
        expect(ChartViewMode.platform, isA<ChartViewMode>());
        expect(ChartViewMode.status, isA<ChartViewMode>());
        expect(ChartViewMode.values.length, equals(2));
      });
    });
  });
}
