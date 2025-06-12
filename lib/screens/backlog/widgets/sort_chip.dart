import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/backlog_styles.dart';

/// A reusable sorting chip widget for backlog screen
class SortChip extends ConsumerWidget {
  final String label;
  final BacklogSortType sortType;
  final bool isActive;
  final SortDirection currentDirection;

  const SortChip({
    super.key,
    required this.label,
    required this.sortType,
    required this.isActive,
    required this.currentDirection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _handleTap(ref),
      child: Container(
        padding: BacklogStyles.sortingChipPadding,
        decoration:
            isActive
                ? BacklogStyles.activeSortingChipDecoration
                : BacklogStyles.inactiveSortingChipDecoration,
        child: _buildChipContent(),
      ),
    );
  }

  Widget _buildChipContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildChipText(),
        if (isActive) ...[
          SizedBox(width: BacklogStyles.sortingChipIconSpacing),
          _buildDirectionIcon(),
        ],
      ],
    );
  }

  Widget _buildChipText() {
    return Text(
      label,
      style:
          isActive
              ? BacklogStyles.activeSortingChipTextStyle
              : BacklogStyles.inactiveSortingChipTextStyle,
    );
  }

  Widget _buildDirectionIcon() {
    final isAscending = currentDirection == SortDirection.ascending;
    return Icon(
      isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      size: BacklogStyles.sortingChipIconSize,
      color: BacklogStyles.activeSortingChipIconColor,
    );
  }

  void _handleTap(WidgetRef ref) {
    if (isActive) {
      // Toggle direction if already active
      ref.read(backlogSortDirectionStateProvider.notifier).toggleDirection();
    } else {
      // Switch to this sort type and reset to ascending
      ref.read(backlogSortProvider.notifier).setSortType(sortType);
      ref
          .read(backlogSortDirectionStateProvider.notifier)
          .setSortDirection(SortDirection.ascending);
    }
  }
}
