import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

enum ChartViewMode { platform, status }

/// Provider for tracking chart view mode
final chartViewModeProvider = StateProvider<ChartViewMode>(
  (ref) => ChartViewMode.platform,
);

/// Reusable segmented control for chart view mode selection
class ChartSegmentedControl extends ConsumerWidget {
  const ChartSegmentedControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(chartViewModeProvider);

    return Container(
      decoration: ProfileStyles.segmentedControlDecoration,
      child: CupertinoSlidingSegmentedControl<ChartViewMode>(
        groupValue: currentMode,
        onValueChanged: (ChartViewMode? value) {
          if (value != null) {
            ref.read(chartViewModeProvider.notifier).state = value;
          }
        },
        children: const {
          ChartViewMode.platform: Padding(
            padding: ProfileStyles.segmentedControlPadding,
            child: Text(
              'Platform',
              style: ProfileStyles.segmentedControlTextStyle,
            ),
          ),
          ChartViewMode.status: Padding(
            padding: ProfileStyles.segmentedControlPadding,
            child: Text(
              'Status',
              style: ProfileStyles.segmentedControlTextStyle,
            ),
          ),
        },
        backgroundColor: AppColors.collapsibleSection,
        thumbColor: Colors.white,
      ),
    );
  }
}
