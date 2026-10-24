import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/status_styles.dart';
import 'package:chkpnt/screens/profile/widgets/shared/chart_segmented_control.dart';

class ChartData {
  final String label;
  final int count;
  final Color color;

  ChartData(this.label, this.count, this.color);
}

/// Service responsible for generating chart data from game lists
class ChartDataService {
  ChartDataService._();

  /// Generate platform-based chart data from a list of games
  static List<ChartData> generatePlatformData(List<GameItem> games) {
    if (games.isEmpty) return [];

    final platformCounts = <String, int>{};

    for (final game in games) {
      platformCounts[game.platform] = (platformCounts[game.platform] ?? 0) + 1;
    }

    // Sort entries by count descending
    final entries =
        platformCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final platform = entry.value.key;
      final count = entry.value.value;
      final color =
          ProfileStyles.chartColors[index % ProfileStyles.chartColors.length];

      return ChartData(platform, count, color);
    }).toList();
  }

  /// Generate status-based chart data from a list of games
  static List<ChartData> generateStatusData(List<GameItem> games) {
    if (games.isEmpty) return [];

    final statusCounts = <GameStatus, int>{};

    for (final game in games) {
      statusCounts[game.status] = (statusCounts[game.status] ?? 0) + 1;
    }

    return statusCounts.entries.map((entry) {
      final style = StatusStyles.of(entry.key);
      return ChartData(style.label, entry.value, style.colour);
    }).toList();
  }

  /// Generate chart data based on the current view mode
  static List<ChartData> generateChartData(
    List<GameItem> games,
    ChartViewMode viewMode,
  ) {
    switch (viewMode) {
      case ChartViewMode.platform:
        return generatePlatformData(games);
      case ChartViewMode.status:
        return generateStatusData(games);
    }
  }
}
