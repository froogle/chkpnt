import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import '../buttons/status_button.dart';

class GameStatusSelector extends StatelessWidget {
  final GameStatus selectedStatus;
  final ValueChanged<GameStatus> onStatusChanged;
  final bool isAddMode;
  final List<GameStatus>? availableStatuses;
  final GameStatus? defaultStatus;

  const GameStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.isAddMode = false,
    this.availableStatuses,
    this.defaultStatus,
  });

  @override
  Widget build(BuildContext context) {
    // Set default status if provided and current status doesn't match
    if (defaultStatus != null && selectedStatus != defaultStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onStatusChanged(defaultStatus!);
      });
    }

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
    // If availableStatuses is provided, use it (for screen-specific behaviour)
    if (availableStatuses != null) {
      return availableStatuses!;
    }

    // If this is add mode (new game), show all available statuses
    if (isAddMode) {
      return [
        GameStatus.playing,
        GameStatus.backlog,
        GameStatus.completed,
        GameStatus.abandoned,
        GameStatus.wishlist,
        GameStatus.ordered,
      ];
    }

    // If the game is currently wishlist or ordered, show only wishlist flow options
    if (selectedStatus == GameStatus.wishlist ||
        selectedStatus == GameStatus.ordered) {
      return [GameStatus.wishlist, GameStatus.ordered, GameStatus.backlog];
    }

    // If the game is in playing, backlog, completed, or abandoned states,
    // exclude wishlist and ordered options as they don't make sense in this context
    if (selectedStatus == GameStatus.playing ||
        selectedStatus == GameStatus.backlog ||
        selectedStatus == GameStatus.completed ||
        selectedStatus == GameStatus.abandoned) {
      return [
        GameStatus.playing,
        GameStatus.backlog,
        GameStatus.completed,
        GameStatus.abandoned,
      ];
    }

    // Fallback case - show all available options (should not be reached with current enum)
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
    final buttonWidth = _calculateButtonWidth(constraints, statuses.length);
    final buttonHeight = InputStyles.statusButtonHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(constraints),
        childAspectRatio: buttonWidth / buttonHeight,
        crossAxisSpacing: InputStyles.statusGridCrossAxisSpacing,
        mainAxisSpacing: InputStyles.statusGridMainAxisSpacing,
      ),
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        return _buildStatusButton(status, buttonWidth);
      },
    );
  }

  double _calculateButtonWidth(BoxConstraints constraints, int statusCount) {
    final crossAxisCount = _calculateCrossAxisCount(constraints);
    final availableWidth =
        constraints.maxWidth -
        (InputStyles.statusGridCrossAxisSpacing * (crossAxisCount - 1));
    return availableWidth / crossAxisCount;
  }

  int _calculateCrossAxisCount(BoxConstraints constraints) {
    if (constraints.maxWidth > 600) {
      return 3;
    } else if (constraints.maxWidth > 400) {
      return 2;
    }
    return 1;
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
