import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/backlog_styles.dart';

enum StatusFilterType { backlog, ongoing }

class StatusFilterChip extends ConsumerWidget {
  final String label;
  final StatusFilterType filterType;

  static const Color _activeColor = Colors.orange;
  static final Color _inactiveColor = Colors.orange.withValues(alpha: 0.1);
  static final Color _inactiveBorderColor = Colors.orange.withValues(alpha: 0.3);
  static final Color _inactiveTextColor = Colors.orange.withValues(alpha: 0.8);

  const StatusFilterChip({
    super.key,
    required this.label,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = _isActive(ref);

    return GestureDetector(
      onTap: () => _handleTap(ref),
      child: Container(
        padding: BacklogStyles.sortingChipPadding,
        decoration: BoxDecoration(
          color: isActive ? _activeColor : _inactiveColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? _activeColor : _inactiveBorderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : _inactiveTextColor,
          ),
        ),
      ),
    );
  }

  bool _isActive(WidgetRef ref) {
    switch (filterType) {
      case StatusFilterType.backlog:
        return ref.watch(backlogShowBacklogFilterProvider);
      case StatusFilterType.ongoing:
        return ref.watch(backlogShowOngoingFilterProvider);
    }
  }

  void _handleTap(WidgetRef ref) {
    final showBacklog = ref.read(backlogShowBacklogFilterProvider);
    final showOngoing = ref.read(backlogShowOngoingFilterProvider);

    switch (filterType) {
      case StatusFilterType.backlog:
        if (showBacklog && !showOngoing) {
          ref.read(backlogShowOngoingFilterProvider.notifier).setValue(true);
        }
        ref.read(backlogShowBacklogFilterProvider.notifier).toggle();
        break;
      case StatusFilterType.ongoing:
        if (showOngoing && !showBacklog) {
          ref.read(backlogShowBacklogFilterProvider.notifier).setValue(true);
        }
        ref.read(backlogShowOngoingFilterProvider.notifier).toggle();
        break;
    }
  }
}
