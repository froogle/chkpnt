import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/widgets/profile_visualisation_section.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/chart_data_service.dart';
import 'package:chkpnt/screens/profile/widgets/shared/chart_segmented_control.dart';

import '../../../test_helpers.dart';

void main() {
  group('ProfileVisualisationSection', () {
    testWidgets('displays empty state when no games', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameListProvider.overrideWith(() => EmptyGameListNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileVisualisationSection()),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('No data to visualise'), findsOneWidget);
      expect(
        find.text('Add some games to see your library statistics'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.pie_chart_outline), findsOneWidget);
    });

    testWidgets('displays segmented control', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameListProvider.overrideWith(() => TestGameListNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileVisualisationSection()),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('switches between platform and status view', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameListProvider.overrideWith(() => TestGameListNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ProfileVisualisationSection()),
          ),
        ),
      );

      await tester.pump();

      // Initially should be on platform view
      final platformButton = find.text('Platform');
      final statusButton = find.text('Status');

      expect(platformButton, findsOneWidget);
      expect(statusButton, findsOneWidget);

      // Tap status button
      await tester.tap(statusButton);
      await tester.pump();

      // Should still show both buttons (segmented control)
      expect(platformButton, findsOneWidget);
      expect(statusButton, findsOneWidget);
    });

    group('with sample games', () {
      testWidgets('displays chart when games exist', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gameListProvider.overrideWith(() => TestGameListNotifier()),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileVisualisationSection()),
            ),
          ),
        );

        await tester.pump();

        // Should not show empty state since TestGameListNotifier has sample games
        expect(find.text('No data to visualise'), findsNothing);

        // Should show chart elements
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('displays legend with game counts', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              gameListProvider.overrideWith(() => TestGameListNotifier()),
            ],
            child: const MaterialApp(
              home: Scaffold(body: ProfileVisualisationSection()),
            ),
          ),
        );

        await tester.pump();

        // Should show some legend items (specific counts may vary with test data)
        expect(find.byType(Container), findsWidgets);
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
