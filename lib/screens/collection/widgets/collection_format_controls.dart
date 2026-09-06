import 'package:flutter/material.dart';
import 'package:chkpnt/shared/widgets/status_filter_chip.dart';
import 'package:chkpnt/styles/backlog_styles.dart';

class CollectionFormatControls extends StatelessWidget {
  const CollectionFormatControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: BacklogStyles.sortingControlsPadding,
      child: Row(
        children: [
          const Spacer(),
          const StatusFilterChip(
            label: 'Physical',
            filterType: StatusFilterType.physical,
          ),
          SizedBox(width: BacklogStyles.sortingChipSpacing),
          const StatusFilterChip(
            label: 'Digital',
            filterType: StatusFilterType.digital,
          ),
        ],
      ),
    );
  }
}
