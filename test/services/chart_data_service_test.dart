import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/services/chart_data_service.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/screens/profile/widgets/shared/chart_segmented_control.dart';
import 'package:chkpnt/styles/status_styles.dart';
import '../test_helpers.dart';

void main() {
  group('ChartDataService', () {
    late List<GameItem> testGames;

    setUp(() {
      testGames = [
        TestHelpers.createPlayingGame(
          title: 'Game 1',
          platform: 'PlayStation 5',
        ),
        TestHelpers.createCompletedGame(
          title: 'Game 2',
          platform: 'PlayStation 5',
        ),
        TestHelpers.createBacklogGame(
          title: 'Game 3',
          platform: 'Xbox Series X',
        ),
        TestHelpers.createPlayingGame(
          title: 'Game 4',
          platform: 'Nintendo Switch',
        ),
        TestHelpers.createTestGame(
          title: 'Game 5',
          platform: 'PlayStation 5',
          status: GameStatus.wishlist,
        ),
      ];
    });

    group('generatePlatformData', () {
      test('returns empty list for empty games list', () {
        final result = ChartDataService.generatePlatformData([]);
        expect(result, isEmpty);
      });

      test('correctly counts games by platform', () {
        final result = ChartDataService.generatePlatformData(testGames);

        expect(result.length, equals(3));

        // Should be sorted by count descending
        expect(result[0].label, equals('PlayStation 5'));
        expect(result[0].count, equals(3));

        expect(result[1].label, equals('Xbox Series X'));
        expect(result[1].count, equals(1));

        expect(result[2].label, equals('Nintendo Switch'));
        expect(result[2].count, equals(1));
      });

      test('assigns different colors to different platforms', () {
        final result = ChartDataService.generatePlatformData(testGames);

        expect(result[0].color, isNotNull);
        expect(result[1].color, isNotNull);
        expect(result[2].color, isNotNull);

        // Colors should be different
        expect(result[0].color, isNot(equals(result[1].color)));
        expect(result[1].color, isNot(equals(result[2].color)));
      });

      test('handles single platform correctly', () {
        final singlePlatformGames = [
          TestHelpers.createPlayingGame(
            title: 'Game 1',
            platform: 'PlayStation 5',
          ),
          TestHelpers.createCompletedGame(
            title: 'Game 2',
            platform: 'PlayStation 5',
          ),
        ];

        final result = ChartDataService.generatePlatformData(
          singlePlatformGames,
        );

        expect(result.length, equals(1));
        expect(result[0].label, equals('PlayStation 5'));
        expect(result[0].count, equals(2));
      });
    });

    group('generateStatusData', () {
      test('returns empty list for empty games list', () {
        final result = ChartDataService.generateStatusData([]);
        expect(result, isEmpty);
      });

      test('correctly counts games by status', () {
        final result = ChartDataService.generateStatusData(testGames);

        expect(result.length, equals(4)); // 4 different statuses

        // Find specific status counts
        final playingData = result.firstWhere(
          (data) => data.label == 'Playing',
        );
        expect(playingData.count, equals(2));

        final completedData = result.firstWhere(
          (data) => data.label == 'Completed',
        );
        expect(completedData.count, equals(1));

        final backlogData = result.firstWhere(
          (data) => data.label == 'Backlog',
        );
        expect(backlogData.count, equals(1));

        final wishlistData = result.firstWhere(
          (data) => data.label == 'Wishlist',
        );
        expect(wishlistData.count, equals(1));
      });

      test('uses correct status labels', () {
        final result = ChartDataService.generateStatusData(testGames);

        final labels = result.map((data) => data.label).toSet();
        expect(labels.contains('Playing'), isTrue);
        expect(labels.contains('Completed'), isTrue);
        expect(labels.contains('Backlog'), isTrue);
        expect(labels.contains('Wishlist'), isTrue);
      });

      test('assigns appropriate colors for statuses', () {
        final result = ChartDataService.generateStatusData(testGames);

        for (final data in result) {
          expect(data.color, isNotNull);
          expect(data.color, isA<Color>());
        }
      });

      test('handles all game statuses', () {
        final allStatusGames = [
          TestHelpers.createPlayingGame(
            title: 'Game 1',
            platform: 'PlayStation 5',
          ),
          TestHelpers.createCompletedGame(
            title: 'Game 2',
            platform: 'PlayStation 5',
          ),
          TestHelpers.createBacklogGame(
            title: 'Game 3',
            platform: 'PlayStation 5',
          ),
          TestHelpers.createAbandonedGame(
            title: 'Game 4',
            platform: 'PlayStation 5',
          ),
          TestHelpers.createTestGame(
            title: 'Game 5',
            platform: 'PlayStation 5',
            status: GameStatus.wishlist,
          ),
          TestHelpers.createTestGame(
            title: 'Game 6',
            platform: 'PlayStation 5',
            status: GameStatus.ordered,
          ),
        ];

        final result = ChartDataService.generateStatusData(allStatusGames);

        expect(result.length, equals(6));

        final labels = result.map((data) => data.label).toSet();
        expect(labels.contains('Playing'), isTrue);
        expect(labels.contains('Completed'), isTrue);
        expect(labels.contains('Backlog'), isTrue);
        expect(labels.contains('Abandoned'), isTrue);
        expect(labels.contains('Wishlist'), isTrue);
        expect(labels.contains('Ordered'), isTrue);
      });

      test('presents every Status slice as Status presentation does', () {
        final everyStatusGames =
            GameStatus.values
                .map(
                  (status) => TestHelpers.createTestGame(
                    title: 'Game ${status.index}',
                    platform: 'PlayStation 5',
                    status: status,
                  ),
                )
                .toList();

        final result = ChartDataService.generateStatusData(everyStatusGames);

        expect(result.length, GameStatus.values.length);
        for (final status in GameStatus.values) {
          final style = StatusStyles.of(status);
          final slice = result.singleWhere((data) => data.label == style.label);
          expect(slice.color, style.colour, reason: '$status slice colour');
        }
      });
    });

    group('generateChartData', () {
      test('delegates to platform data generation for platform mode', () {
        final result = ChartDataService.generateChartData(
          testGames,
          ChartViewMode.platform,
        );

        // Should match platform data generation
        final expectedResult = ChartDataService.generatePlatformData(testGames);
        expect(result.length, equals(expectedResult.length));
        expect(result[0].label, equals(expectedResult[0].label));
        expect(result[0].count, equals(expectedResult[0].count));
      });

      test('delegates to status data generation for status mode', () {
        final result = ChartDataService.generateChartData(
          testGames,
          ChartViewMode.status,
        );

        // Should match status data generation
        final expectedResult = ChartDataService.generateStatusData(testGames);
        expect(result.length, equals(expectedResult.length));
      });

      test('returns empty list for empty games in both modes', () {
        final platformResult = ChartDataService.generateChartData(
          [],
          ChartViewMode.platform,
        );
        final statusResult = ChartDataService.generateChartData(
          [],
          ChartViewMode.status,
        );

        expect(platformResult, isEmpty);
        expect(statusResult, isEmpty);
      });
    });

    group('ChartData', () {
      test('creates chart data with correct properties', () {
        const testLabel = 'Test Label';
        const testCount = 5;
        const testColor = Colors.blue;

        final chartData = ChartData(testLabel, testCount, testColor);

        expect(chartData.label, equals(testLabel));
        expect(chartData.count, equals(testCount));
        expect(chartData.color, equals(testColor));
      });
    });
  });
}
