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
    return _buildStatusGrid();
  }

  Widget _buildStatusGrid() {
    const statuses = [
      GameStatus.playing,
      GameStatus.backlog,
      GameStatus.completed,
      GameStatus.abandoned,
      GameStatus.wishlist,
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
    // Calculate button width based on available space
    const spacing = InputStyles.statusButtonSpacing;
    final availableWidth = constraints.maxWidth;

    // Determine layout based on orientation and available space
    int buttonsPerRow;

    // Landscape approach: Maximum 4-wide to prevent overflow
    if (availableWidth >= 300) {
      // Try for 4-wide with generous requirements
      final minButtonWidthFor4 = 75.0; // Reasonable size for 4-wide
      final widthNeededFor4 = (minButtonWidthFor4 * 4) + (spacing * 3);

      if (availableWidth >= widthNeededFor4) {
        buttonsPerRow = 4;
      } else {
        // Force 4-wide if buttons can be at least 65px wide
        final actualButtonWidth = (availableWidth - (spacing * 3)) / 4;
        if (actualButtonWidth >= 65.0) {
          buttonsPerRow = 4;
        } else {
          buttonsPerRow = 3;
        }
      }
    } else {
      // Smaller screens - use 3-wide
      buttonsPerRow = 3;
    }

    final buttonWidth =
        (availableWidth - (spacing * (buttonsPerRow - 1))) / buttonsPerRow;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing, // Use consistent spacing for both directions
      alignment: WrapAlignment.start, // Left-align buttons
      children:
          statuses
              .map((status) => _buildStatusButton(status, buttonWidth))
              .toList(),
    );
  }

  Widget _buildStatusButton(GameStatus status, double buttonWidth) {
    final isSelected = status == selectedStatus;

    return SizedBox(
      width: buttonWidth,
      height: InputStyles.statusButtonHeight,
      child: StatusButton(
        status: status,
        isSelected: isSelected,
        onTap: () => onStatusChanged(status),
      ),
    );
  }
}
