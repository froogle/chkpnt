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
  final bool isAddMode;
  final GameEditContext editContext;

  const GameEditInfoSection({
    super.key,
    required this.titleController,
    required this.selectedPlatform,
    required this.onPlatformChanged,
    required this.editContext,
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
        _buildTitleField(),
        const SizedBox(height: EditScreenStyles.sectionSpacing),
        _buildPlatformSection(),
        const SizedBox(height: EditScreenStyles.sectionSpacing),
        _buildPhysicalToggle(),
      ],
    );
  }

  Widget _buildPhysicalToggle() {
    final formState = ref.watch(gameEditStateProvider(widget.editContext));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.collapsibleSection,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.sd_card, size: 20, color: AppColors.primaryText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Physical Copy',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: formState.isPhysical,
            onChanged: (value) {
              ref
                  .read(gameEditStateProvider(widget.editContext).notifier)
                  .updateIsPhysical(value);
            },
            activeTrackColor: AppColors.primaryPurple,
          ),
        ],
      ),
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

    return Column(
      crossAxisAlignment: EditScreenStyles.platformSectionAlignment,
      children: [
        PlatformEditDropdown(
          selectedPlatform: widget.selectedPlatform,
          platforms: editablePlatforms,
          onPlatformChanged: widget.onPlatformChanged,
          isAddMode: widget.isAddMode,
        ),
      ],
    );
  }
}
