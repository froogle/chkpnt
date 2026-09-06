import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/backlog_styles.dart';
import 'package:chkpnt/shared/widgets/status_filter_chip.dart';
import 'sort_chip.dart';

class BacklogSortingControls extends ConsumerWidget {
  const BacklogSortingControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortType = ref.watch(backlogSortProvider);
    final currentSortDirection = ref.watch(backlogSortDirectionStateProvider);

    return Container(
      padding: BacklogStyles.sortingControlsPadding,
      child: Row(
        children: [
          SortChip(
            label: 'Title',
            sortType: BacklogSortType.title,
            isActive: currentSortType == BacklogSortType.title,
            currentDirection: currentSortDirection,
          ),
          SizedBox(width: BacklogStyles.sortingChipSpacing),
          SortChip(
            label: 'Date Added',
            sortType: BacklogSortType.dateAdded,
            isActive: currentSortType == BacklogSortType.dateAdded,
            currentDirection: currentSortDirection,
          ),
          const Spacer(),
          const StatusFilterChip(
            label: 'Backlog',
            filterType: StatusFilterType.backlog,
          ),
          SizedBox(width: BacklogStyles.sortingChipSpacing),
          const StatusFilterChip(
            label: 'Ongoing',
            filterType: StatusFilterType.ongoing,
          ),
        ],
      ),
    );
  }
}
