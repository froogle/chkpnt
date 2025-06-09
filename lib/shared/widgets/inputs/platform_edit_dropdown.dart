import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class PlatformEditDropdown extends StatefulWidget {
  final String selectedPlatform;
  final List<String> platforms;
  final ValueChanged<String> onPlatformChanged;

  const PlatformEditDropdown({
    super.key,
    required this.selectedPlatform,
    required this.platforms,
    required this.onPlatformChanged,
  });

  @override
  State<PlatformEditDropdown> createState() => _PlatformEditDropdownState();
}

class _PlatformEditDropdownState extends State<PlatformEditDropdown> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.selectedPlatform);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPlatformOptions,
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
                widget.selectedPlatform,
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

  void _showPlatformOptions() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;
    final maxSheetHeight =
        availableHeight * EditScreenStyles.bottomSheetMaxHeightFactor;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: EditScreenStyles.bottomSheetPadding.copyWith(
        bottom: keyboardHeight + 20,
      ),
      decoration: EditScreenStyles.bottomSheetDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBottomSheetHeader(),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCustomPlatformInput(),
                  const SizedBox(height: 20),
                  _buildPlatformList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
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

  Widget _buildCustomPlatformInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Or enter custom platform:',
          style: EditScreenStyles.customPlatformLabelStyle,
        ),
        const SizedBox(height: EditScreenStyles.customPlatformSpacing),
        TextField(
          controller: _textController,
          decoration: EditScreenStyles.customPlatformInputDecoration,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) {
            _handlePlatformSelection(value.trim());
          },
        ),
        const SizedBox(height: EditScreenStyles.customPlatformSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _handlePlatformSelection(_textController.text.trim());
            },
            style: EditScreenStyles.customPlatformButtonStyle,
            child: const Text(EditScreenStyles.customPlatformButtonText),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformList() {
    if (widget.platforms.isEmpty) return const SizedBox.shrink();

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
          itemCount: widget.platforms.length,
          itemBuilder: (context, index) {
            final platform = widget.platforms[index];
            final isSelected = platform == widget.selectedPlatform;

            return ListTile(
              leading: const Icon(
                Icons.gamepad_outlined,
                size: EditScreenStyles.platformListIconSize,
              ),
              title: Text(platform),
              trailing:
                  isSelected
                      ? const Icon(
                        Icons.check,
                        color: EditScreenStyles.platformListCheckColour,
                      )
                      : null,
              onTap: () => _handlePlatformSelection(platform),
              tileColor:
                  isSelected
                      ? EditScreenStyles.platformListSelectedColour
                      : null,
              shape: EditScreenStyles.platformListTileShape,
            );
          },
        ),
      ],
    );
  }

  void _handlePlatformSelection(String platform) {
    if (platform.isNotEmpty && platform != widget.selectedPlatform) {
      final abbreviatedPlatform = _getAbbreviatedPlatformName(platform);
      widget.onPlatformChanged(abbreviatedPlatform);
      _textController.text = abbreviatedPlatform;
    }
    Navigator.of(context).pop();
  }

  String _getAbbreviatedPlatformName(String platform) {
    final normalised = platform.trim();

    // Convert common long platform names to abbreviations
    switch (normalised.toLowerCase()) {
      case 'game boy advance':
      case 'gameboy advance':
        return 'GBA';
      case 'game boy color':
      case 'gameboy color':
        return 'GBC';
      case 'game boy':
      case 'gameboy':
        return 'GB';
      case 'nintendo switch':
        return 'Switch';
      case 'nintendo 3ds':
        return '3DS';
      case 'nintendo ds':
        return 'DS';
      case 'nintendo entertainment system':
      case 'nes':
        return 'NES';
      case 'super nintendo':
      case 'super nintendo entertainment system':
      case 'snes':
        return 'SNES';
      case 'nintendo 64':
        return 'N64';
      case 'nintendo gamecube':
      case 'gamecube':
        return 'GameCube';
      case 'nintendo wii':
        return 'Wii';
      case 'nintendo wii u':
        return 'Wii U';
      case 'playstation':
      case 'playstation 1':
        return 'PS1';
      case 'playstation 2':
        return 'PS2';
      case 'playstation 3':
        return 'PS3';
      case 'playstation 4':
        return 'PS4';
      case 'playstation 5':
        return 'PS5';
      case 'playstation portable':
        return 'PSP';
      case 'playstation vita':
        return 'PS Vita';
      case 'xbox':
      case 'original xbox':
        return 'Xbox';
      case 'xbox 360':
        return 'Xbox 360';
      case 'xbox one':
        return 'Xbox One';
      case 'xbox series x':
      case 'xbox series s':
      case 'xbox series x/s':
        return 'Xbox Series';
      case 'steam deck':
        return 'Steam Deck';
      case 'personal computer':
        return 'PC';
      case 'mobile':
      case 'ios':
      case 'android':
        return normalised; // Keep mobile platforms as-is
      default:
        // For unknown platforms, keep original if reasonable length
        // or truncate if too long
        return normalised.length > 12
            ? '${normalised.substring(0, 12)}...'
            : normalised;
    }
  }
}
