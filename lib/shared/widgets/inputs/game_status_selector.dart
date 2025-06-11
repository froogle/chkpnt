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
    final statuses = _getAvailableStatuses();

    return LayoutBuilder(
      builder:
          (context, constraints) =>
              _buildResponsiveStatusGrid(context, statuses, constraints),
    );
  }

  /// Determines which status options to show based on the current game status
  List<GameStatus> _getAvailableStatuses() {
    // If the game is currently wishlist or ordered, show only wishlist flow options
    if (selectedStatus == GameStatus.wishlist ||
        selectedStatus == GameStatus.ordered) {
      return [GameStatus.wishlist, GameStatus.ordered, GameStatus.backlog];
    }

    // For all other statuses, show all available options
    return [
      GameStatus.playing,
      GameStatus.backlog,
      GameStatus.completed,
      GameStatus.abandoned,
      GameStatus.wishlist,
      GameStatus.ordered,
    ];
  }

  Widget _buildResponsiveStatusGrid(
    BuildContext context,
    List<GameStatus> statuses,
    BoxConstraints constraints,
  ) {
    // Calculate button width based on available space
    const spacing = InputStyles.statusButtonSpacing;
    final availableWidth = constraints.maxWidth;

    // Determine orientation to set maximum buttons per row
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    // Set maximum buttons per row based on orientation
    final maxButtonsPerRow = isPortrait ? 3 : 4;

    // Calculate minimum button width needed for content
    // Account for: horizontal padding (16) + icon (16) + spacing (4) + text (~40-60)
    final minButtonWidth = isPortrait ? 90.0 : 85.0;

    // Calculate optimal buttons per row within the limit
    int buttonsPerRow = maxButtonsPerRow;

    // Check if we can fit the maximum buttons with reasonable size
    final widthNeededForMax =
        (minButtonWidth * maxButtonsPerRow) +
        (spacing * (maxButtonsPerRow - 1));

    if (availableWidth < widthNeededForMax) {
      // If we can't fit the maximum, reduce to fit
      buttonsPerRow = maxButtonsPerRow - 1;
      if (buttonsPerRow < 2) buttonsPerRow = 2; // Minimum 2 buttons per row
    }

    // Ensure calculated button width meets minimum requirements
    final calculatedButtonWidth =
        (availableWidth - (spacing * (buttonsPerRow - 1))) / buttonsPerRow;
    final buttonWidth =
        calculatedButtonWidth < minButtonWidth
            ? minButtonWidth
            : calculatedButtonWidth;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.start,
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
