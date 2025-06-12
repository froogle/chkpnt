import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/services/chart_data_service.dart';

/// Dedicated pie chart widget for profile screen
class ProfilePieChart extends StatelessWidget {
  const ProfilePieChart({
    super.key,
    required this.data,
    this.isLandscape = false,
  });

  final List<ChartData> data;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ProfileStyles.getChartHeight(isLandscape),
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _buildChartSections(),
                borderData: FlBorderData(show: false),
                centerSpaceRadius: ProfileStyles.getChartCenterSpace(
                  isLandscape,
                ),
                sectionsSpace: ProfileStyles.chartSectionSpace,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    return data.map((chartData) {
      return PieChartSectionData(
        color: chartData.color,
        value: chartData.count.toDouble(),
        title: '${chartData.count}',
        radius: ProfileStyles.getChartRadius(isLandscape),
        titleStyle: ProfileStyles.chartTitleStyle,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: ProfileStyles.legendSpacing,
      runSpacing: ProfileStyles.legendRunSpacing,
      alignment: WrapAlignment.center,
      children: data.map((item) => _buildLegendItem(item)).toList(),
    );
  }

  Widget _buildLegendItem(ChartData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ProfileStyles.legendIndicatorSize,
          height: ProfileStyles.legendIndicatorSize,
          decoration: ProfileStyles.legendIndicatorDecoration(data.color),
        ),
        const SizedBox(width: ProfileStyles.legendIndicatorSpacing),
        Text(
          '${data.label} (${data.count})',
          style: ProfileStyles.legendItemStyle,
        ),
      ],
    );
  }
}
