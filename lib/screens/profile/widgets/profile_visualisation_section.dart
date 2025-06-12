import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

// Provider for tracking chart view mode
final chartViewModeProvider = StateProvider<ChartViewMode>(
  (ref) => ChartViewMode.platform,
);

enum ChartViewMode { platform, status }

class ChartData {
  final String label;
  final int count;
  final Color color;

  ChartData(this.label, this.count, this.color);
}

class ProfileVisualisationSection extends ConsumerWidget {
  const ProfileVisualisationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(chartViewModeProvider);
    final games = ref.watch(gameListProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardElevation,
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadingStyles.gradientHeading(
              'Game Library Statistics',
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            _buildSegmentedControl(ref, viewMode),
            const SizedBox(height: 24),
            if (games.isEmpty)
              _buildEmptyState()
            else
              _buildChart(games, viewMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(WidgetRef ref, ChartViewMode currentMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.collapsibleSection,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoSlidingSegmentedControl<ChartViewMode>(
        groupValue: currentMode,
        onValueChanged: (ChartViewMode? value) {
          if (value != null) {
            ref.read(chartViewModeProvider.notifier).state = value;
          }
        },
        children: const {
          ChartViewMode.platform: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Platform',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          ChartViewMode.status: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Status',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        },
        backgroundColor: AppColors.collapsibleSection,
        thumbColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final emptyStateHeight = isLandscape ? 200.0 : 250.0;

        return Container(
          height: emptyStateHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 48,
                color: AppColors.emptyStateIcon,
              ),
              const SizedBox(height: 12),
              Text(
                'No data to visualise',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emptyStateText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add some games to see your library statistics',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.emptyStateText.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChart(List<GameItem> games, ChartViewMode viewMode) {
    final chartData =
        viewMode == ChartViewMode.platform
            ? _generatePlatformData(games)
            : _generateStatusData(games);

    if (chartData.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Make height responsive - smaller in landscape
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final chartHeight = isLandscape ? 280.0 : 350.0;

        return Container(
          height: chartHeight,
          child: Column(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections:
                        chartData.map((data) {
                          return PieChartSectionData(
                            color: data.color,
                            value: data.count.toDouble(),
                            title: '${data.count}',
                            radius: isLandscape ? 50 : 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: isLandscape ? 30 : 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegend(chartData),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(List<ChartData> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: data.map((item) => _buildLegendItem(item)).toList(),
    );
  }

  Widget _buildLegendItem(ChartData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '${data.label} (${data.count})',
          style: const TextStyle(fontSize: 12, color: AppColors.primaryText),
        ),
      ],
    );
  }

  List<ChartData> _generatePlatformData(List<GameItem> games) {
    final platformCounts = <String, int>{};

    for (final game in games) {
      platformCounts[game.platform] = (platformCounts[game.platform] ?? 0) + 1;
    }

    final colors = _getChartColors();
    final entries =
        platformCounts.entries.toList()..sort(
          (a, b) => b.value.compareTo(a.value),
        ); // Sort by count descending

    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final platform = entry.value.key;
      final count = entry.value.value;
      return ChartData(platform, count, colors[index % colors.length]);
    }).toList();
  }

  List<ChartData> _generateStatusData(List<GameItem> games) {
    final statusCounts = <GameStatus, int>{};

    for (final game in games) {
      statusCounts[game.status] = (statusCounts[game.status] ?? 0) + 1;
    }

    final statusLabels = {
      GameStatus.playing: 'Playing',
      GameStatus.completed: 'Completed',
      GameStatus.backlog: 'Backlog',
      GameStatus.abandoned: 'Abandoned',
      GameStatus.wishlist: 'Wishlist',
      GameStatus.ordered: 'Ordered',
    };

    final statusColors = {
      GameStatus.playing: const Color(0xFF10B981),
      GameStatus.completed: const Color(0xFF8B5CF6),
      GameStatus.backlog: const Color(0xFFF59E0B),
      GameStatus.abandoned: const Color(0xFFEF4444),
      GameStatus.wishlist: const Color(0xFF3B82F6),
      GameStatus.ordered: const Color(0xFF06B6D4),
    };

    return statusCounts.entries.map((entry) {
      final status = entry.key;
      final count = entry.value;
      return ChartData(
        statusLabels[status] ?? status.toString(),
        count,
        statusColors[status] ?? AppColors.primaryPurple,
      );
    }).toList();
  }

  List<Color> _getChartColors() {
    return [
      const Color(0xFF8B5CF6), // Primary purple
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFF97316), // Orange
      const Color(0xFF84CC16), // Lime
      const Color(0xFFEC4899), // Pink
      const Color(0xFF6366F1), // Indigo
    ];
  }
}
