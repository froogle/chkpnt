import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/screens/edit/widgets/platform_entry_screen.dart';
import 'package:chkpnt/utils/platform_utils.dart';

class PlatformSelectionBottomSheet extends StatelessWidget {
  final List<String> platforms;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformSelected;

  const PlatformSelectionBottomSheet({
    super.key,
    required this.platforms,
    required this.selectedPlatform,
    required this.onPlatformSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: EditScreenStyles.bottomSheetDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildCustomPlatformSection(context),
            if (platforms.isNotEmpty) ...[
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildPlatformList(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Select Platform',
          style: EditScreenStyles.bottomSheetHeaderStyle,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close,
            color: EditScreenStyles.bottomSheetCloseIconColour,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomPlatformSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Or add a new platform:',
          style: EditScreenStyles.customPlatformLabelStyle,
        ),
        const SizedBox(height: EditScreenStyles.customPlatformSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToCustomPlatformEntry(context),
            style: EditScreenStyles.customPlatformButtonStyle,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Add Custom Platform'),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformList(BuildContext context) {
    if (platforms.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Choose from existing:',
          style: EditScreenStyles.platformListLabelStyle,
        ),
        const SizedBox(height: EditScreenStyles.platformListSpacing),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: platforms.length,
          itemBuilder: (context, index) =>
              _buildPlatformTile(context, platforms[index]),
        ),
      ],
    );
  }

  Widget _buildPlatformTile(BuildContext context, String platform) {
    final isSelected = platform == selectedPlatform;

    return ListTile(
      leading: const Icon(
        Icons.gamepad_outlined,
        size: EditScreenStyles.platformListIconSize,
        color: AppColors.primaryText,
      ),
      title: Text(
        platform,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: EditScreenStyles.platformListCheckColour,
            )
          : null,
      onTap: () => _handlePlatformSelection(context, platform),
      tileColor: isSelected
          ? EditScreenStyles.platformListSelectedColour
          : null,
      shape: EditScreenStyles.platformListTileShape,
    );
  }

  Future<void> _navigateToCustomPlatformEntry(BuildContext context) async {
    Navigator.of(context).pop(); // Close the bottom sheet first

    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const PlatformEntryScreen()),
    );

    if (result != null && result.isNotEmpty) {
      final abbreviatedPlatform = PlatformUtils.abbreviatePlatformName(result);
      onPlatformSelected(abbreviatedPlatform);
    }
  }

  void _handlePlatformSelection(BuildContext context, String platform) {
    if (platform.isNotEmpty && platform != selectedPlatform) {
      final abbreviatedPlatform = PlatformUtils.abbreviatePlatformName(
        platform,
      );
      onPlatformSelected(abbreviatedPlatform);
    }
    Navigator.of(context).pop();
  }
}
