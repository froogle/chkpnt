import 'package:flutter/material.dart';
import 'package:chkpnt/styles/edit_screen_styles.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_selection_bottom_sheet.dart';
import 'package:chkpnt/shared/widgets/inputs/custom_platform_dialog.dart';

class PlatformEditDropdown extends StatelessWidget {
  final String selectedPlatform;
  final List<String> platforms;
  final ValueChanged<String> onPlatformChanged;
  final bool isAddMode;

  const PlatformEditDropdown({
    super.key,
    required this.selectedPlatform,
    required this.platforms,
    required this.onPlatformChanged,
    this.isAddMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPlatformOptions(context),
      child: Container(
        padding: EditScreenStyles.platformDropdownPadding,
        decoration: EditScreenStyles.platformDropdownDecoration,
        child: Row(
          children: [
            const Icon(
              Icons.gamepad_outlined,
              size: EditScreenStyles.platformDropdownIconSize,
              color: EditScreenStyles.platformDropdownIconColour,
            ),
            const SizedBox(width: EditScreenStyles.platformDropdownSpacing),
            Expanded(
              child: Text(
                selectedPlatform,
                style: EditScreenStyles.platformDropdownTextStyle,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: EditScreenStyles.platformDropdownArrowColour,
              size: EditScreenStyles.platformDropdownArrowSize,
            ),
          ],
        ),
      ),
    );
  }

  void _showPlatformOptions(BuildContext context) {
    // Only unfocus when actually showing platform options
    if (platforms.isEmpty && isAddMode) {
      _showCustomPlatformDialog(context);
    } else {
      _showPlatformSelectionBottomSheet(context);
    }
  }

  void _showCustomPlatformDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (context) =>
          CustomPlatformDialog(initialValue: selectedPlatform),
    ).then((result) {
      if (result != null && result != selectedPlatform) {
        onPlatformChanged(result);
      }
    });
  }

  void _showPlatformSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => PlatformSelectionBottomSheet(
        platforms: platforms,
        selectedPlatform: selectedPlatform,
        onPlatformSelected: onPlatformChanged,
      ),
    );
  }
}
