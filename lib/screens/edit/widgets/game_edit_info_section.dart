import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_edit_dropdown.dart';

class GameEditInfoSection extends ConsumerStatefulWidget {
  final TextEditingController titleController;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformChanged;
  final bool isPortrait;
  final bool showPlatformAndStatus;
  final bool showTitle;
  final bool isAddMode;
  final GameEditContext editContext;

  const GameEditInfoSection({
    super.key,
    required this.titleController,
    required this.selectedPlatform,
    required this.onPlatformChanged,
    required this.editContext,
    this.isPortrait = true,
    this.showPlatformAndStatus = true,
    this.showTitle = true,
    this.isAddMode = false,
  });

  @override
  ConsumerState<GameEditInfoSection> createState() =>
      _GameEditInfoSectionState();
}

class _GameEditInfoSectionState extends ConsumerState<GameEditInfoSection> {
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) _buildTitleField(),
        if (widget.showTitle && widget.showPlatformAndStatus)
          const SizedBox(height: EditScreenStyles.sectionSpacing),
        if (widget.showPlatformAndStatus) _buildPlatformSection(),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: widget.titleController,
      focusNode: _titleFocusNode,
      style: EditScreenStyles.titleFieldTextStyle,
      decoration: EditScreenStyles.titleFieldDecoration,
      maxLines: 1,
      textCapitalization: TextCapitalization.words,
      onTap: () {
        // Ensure focus is maintained on tap
        if (!_titleFocusNode.hasFocus) {
          _titleFocusNode.requestFocus();
        }
      },
    );
  }

  Widget _buildPlatformSection() {
    // Use ref.read instead of ref.watch to avoid unnecessary rebuilds
    final availablePlatforms = ref.read(availablePlatformsProvider);
    // Remove 'All' from platforms list for editing
    final editablePlatforms =
        availablePlatforms.where((p) => p != 'All').toList();

    if (widget.isPortrait) {
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
            selectedPlatform: widget.selectedPlatform,
            platforms: platforms,
            onPlatformChanged: widget.onPlatformChanged,
            isAddMode: widget.isAddMode,
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
          selectedPlatform: widget.selectedPlatform,
          platforms: platforms,
          onPlatformChanged: widget.onPlatformChanged,
          isAddMode: widget.isAddMode,
        ),
      ],
    );
  }
}
