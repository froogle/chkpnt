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

class _GameEditInfoSectionState extends ConsumerState<GameEditInfoSection>
    with WidgetsBindingObserver {
  late FocusNode _titleFocusNode;
  bool _keyboardWasVisible = false;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();

    // Listen for keyboard visibility changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // Check if keyboard visibility changed
    final bottomInset =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .viewInsets
            .bottom;
    final isKeyboardVisible = bottomInset > 0;

    if (_keyboardWasVisible && !isKeyboardVisible && _titleFocusNode.hasFocus) {
      // Keyboard was visible, now it's gone, and we still have focus - unfocus
      _titleFocusNode.unfocus();
    }

    // Update keyboard visibility state
    _keyboardWasVisible = isKeyboardVisible;
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
    );
  }

  Widget _buildPlatformSection() {
    final availablePlatforms = ref.watch(availablePlatformsProvider);
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
