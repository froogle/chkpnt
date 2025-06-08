import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import '../buttons/status_button.dart';

class GameStatusSelector extends StatelessWidget {
  final GameStatus selectedStatus;
  final ValueChanged<GameStatus> onStatusChanged;

  const GameStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusSectionTitle(),
        const SizedBox(height: 12),
        _buildStatusGrid(),
      ],
    );
  }

  Widget _buildStatusSectionTitle() {
    return const Text(
      'Change Status',
      style: GameDetailSheetStyles.sectionTitleStyle,
    );
  }

  Widget _buildStatusGrid() {
    const statuses = [
      GameStatus.wishlist,
      GameStatus.abandoned,
      GameStatus.completed,
      GameStatus.backlog,
      GameStatus.playing,
    ];

    return LayoutBuilder(
      builder:
          (context, constraints) =>
              _buildResponsiveStatusGrid(statuses, constraints),
    );
  }

  Widget _buildResponsiveStatusGrid(
    List<GameStatus> statuses,
    BoxConstraints constraints,
  ) {
    final isWide = constraints.maxWidth > 400;
    final crossAxisCount = isWide ? 5 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _buildStatusGridDelegate(crossAxisCount, isWide),
      itemCount: statuses.length,
      itemBuilder: (context, index) => _buildStatusGridItem(statuses[index]),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildStatusGridDelegate(
    int crossAxisCount,
    bool isWide,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio:
          isWide
              ? GameDetailSheetStyles.statusButtonAspectRatioWide
              : GameDetailSheetStyles.statusButtonAspectRatio,
      crossAxisSpacing: GameDetailSheetStyles.statusGridCrossAxisSpacing,
      mainAxisSpacing: GameDetailSheetStyles.statusGridMainAxisSpacing,
    );
  }

  Widget _buildStatusGridItem(GameStatus status) {
    final isSelected = status == selectedStatus;

    return StatusButton(
      status: status,
      isSelected: isSelected,
      onTap: () => onStatusChanged(status),
    );
  }
}
