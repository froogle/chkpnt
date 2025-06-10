import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_edit_dropdown.dart';
import 'package:chkpnt/shared/widgets/inputs/auto_focus_text_field.dart';

class GameEditInfoSection extends ConsumerWidget {
  final TextEditingController titleController;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformChanged;
  final bool isPortrait;
  final bool showPlatformAndStatus;
  final bool showTitle;
  final bool isAddMode;

  const GameEditInfoSection({
    super.key,
    required this.titleController,
    required this.selectedPlatform,
    required this.onPlatformChanged,
    this.isPortrait = true,
    this.showPlatformAndStatus = true,
    this.showTitle = true,
    this.isAddMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) _buildTitleField(),
        if (showTitle && showPlatformAndStatus)
          const SizedBox(height: EditScreenStyles.sectionSpacing),
        if (showPlatformAndStatus) _buildPlatformSection(ref),
      ],
    );
  }

  Widget _buildTitleField() {
    return AutoFocusTextField(
      controller: titleController,
      style: GameDetailSheetStyles.gameTitleStyle,
      decoration: EditScreenStyles.titleFieldDecoration,
      maxLines: null,
      textCapitalization: TextCapitalization.words,
      isAddMode: isAddMode,
    );
  }

  Widget _buildPlatformSection(WidgetRef ref) {
    final availablePlatforms = ref.watch(availablePlatformsProvider);
    // Remove 'All' from platforms list for editing
    final editablePlatforms =
        availablePlatforms.where((p) => p != 'All').toList();

    if (isPortrait) {
      return _buildPortraitPlatformSection(editablePlatforms);
    } else {
      return _buildLandscapePlatformSection(editablePlatforms);
    }
  }

  Widget _buildPortraitPlatformSection(List<String> platforms) {
    return Row(
      crossAxisAlignment: EditScreenStyles.portraitPlatformAlignment,
      children: [
        Expanded(
          child: PlatformEditDropdown(
            selectedPlatform: selectedPlatform,
            platforms: platforms,
            onPlatformChanged: onPlatformChanged,
            isAddMode: isAddMode,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapePlatformSection(List<String> platforms) {
    return Column(
      crossAxisAlignment: EditScreenStyles.platformSectionAlignment,
      children: [
        PlatformEditDropdown(
          selectedPlatform: selectedPlatform,
          platforms: platforms,
          onPlatformChanged: onPlatformChanged,
          isAddMode: isAddMode,
        ),
      ],
    );
  }
}
