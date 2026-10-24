import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';

class StatusButton extends StatelessWidget {
  final GameStatus status;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;

  const StatusButton({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: InputStyles.statusButtonDecoration(isSelected),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: InputStyles.statusButtonContentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          SizedBox(width: InputStyles.statusButtonVerticalSpacing),
          Flexible(child: _buildLabel()),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      StatusStyles.of(status).icon,
      size: InputStyles.statusButtonIconSize,
      color: _getIconColor(),
    );
  }

  Widget _buildLabel() {
    return Text(
      StatusStyles.of(status).label,
      style: InputStyles.statusButtonTextStyle(isSelected),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Color _getIconColor() {
    return isSelected ? AppColors.primaryPurple : AppColors.expandIcon;
  }
}
