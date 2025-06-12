import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/global_styles.dart';

class BacklogSortingControls extends ConsumerWidget {
  const BacklogSortingControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortType = ref.watch(backlogSortProvider);
    final currentSortDirection = ref.watch(backlogSortDirectionStateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildSortChip(
            context,
            ref,
            'Title',
            BacklogSortType.title,
            currentSortType,
            currentSortDirection,
          ),
          const SizedBox(width: 8),
          _buildSortChip(
            context,
            ref,
            'Date Added',
            BacklogSortType.dateAdded,
            currentSortType,
            currentSortDirection,
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    BacklogSortType sortType,
    BacklogSortType currentSortType,
    SortDirection currentDirection,
  ) {
    final isActive = currentSortType == sortType;
    final isAscending = currentDirection == SortDirection.ascending;

    return GestureDetector(
      onTap: () {
        if (isActive) {
          // Toggle direction if already active
          ref
              .read(backlogSortDirectionStateProvider.notifier)
              .toggleDirection();
        } else {
          // Switch to this sort type
          ref.read(backlogSortProvider.notifier).setSortType(sortType);
          // Reset to ascending when switching sort types
          ref
              .read(backlogSortDirectionStateProvider.notifier)
              .setSortDirection(SortDirection.ascending);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.lightPurple
                  : AppColors.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isActive
                    ? AppColors.lightPurple
                    : AppColors.primaryPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? Colors.white
                        : AppColors.primaryPurple.withOpacity(0.8),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 4),
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
