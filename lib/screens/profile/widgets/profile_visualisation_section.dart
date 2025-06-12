import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/chart_data_service.dart';
import 'shared/chart_segmented_control.dart';
import 'shared/profile_empty_state.dart';
import 'visualization/profile_pie_chart.dart';

class ProfileVisualisationSection extends ConsumerWidget {
  const ProfileVisualisationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(chartViewModeProvider);
    final games = ref.watch(gameListProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: const EdgeInsets.all(ProfileStyles.sectionPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadingStyles.gradientHeading(
              'Game Library Statistics',
              fontSize: 16,
            ),
            const SizedBox(height: 20),
            const ChartSegmentedControl(),
            const SizedBox(height: 24),
            _buildContent(games, viewMode, isLandscape),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    List<GameItem> games,
    ChartViewMode viewMode,
    bool isLandscape,
  ) {
    if (games.isEmpty) {
      return ProfileEmptyState(
        icon: Icons.pie_chart_outline,
        title: 'No data to visualise',
        subtitle: 'Add some games to see your library statistics',
        isLandscape: isLandscape,
      );
    }

    final chartData = ChartDataService.generateChartData(games, viewMode);

    if (chartData.isEmpty) {
      return ProfileEmptyState(
        icon: Icons.pie_chart_outline,
        title: 'No data to visualise',
        subtitle: 'Add some games to see your library statistics',
        isLandscape: isLandscape,
      );
    }

    return ProfilePieChart(data: chartData, isLandscape: isLandscape);
  }
}
