import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'widgets/game_edit_info_section.dart';
import 'widgets/game_edit_actions.dart';
import 'widgets/animations/animated_edit_form.dart';
import 'widgets/image_selection_bottom_sheet.dart';

class GameEditScreen extends ConsumerStatefulWidget {
  final GameItem? game;
  final bool isAddMode;

  const GameEditScreen._({super.key, this.game, required this.isAddMode});

  // Factory constructor for editing existing games
  factory GameEditScreen.edit({Key? key, required GameItem game}) {
    return GameEditScreen._(key: key, game: game, isAddMode: false);
  }

  // Factory constructor for adding new games
  factory GameEditScreen.add({Key? key}) {
    return GameEditScreen._(key: key, game: null, isAddMode: true);
  }

  @override
  ConsumerState<GameEditScreen> createState() => _GameEditScreenState();
}

class _GameEditScreenState extends ConsumerState<GameEditScreen> {
  late TextEditingController _titleController;
  late GameEditContext _editContext;

  @override
  void initState() {
    super.initState();

    // Create the edit context that will be used with the Family provider
    _editContext = GameEditContext(
      isAddMode: widget.isAddMode,
      game: widget.game,
    );

    // Set up title controller with initial value from provider
    final initialState = ref.read(gameEditStateProvider(_editContext));
    _titleController = TextEditingController(text: initialState.title);
    _titleController.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    // Only update if the widget is mounted and the text actually changed
    if (mounted) {
      final currentState = ref.read(gameEditStateProvider(_editContext));
      final newTitle = _titleController.text;

      // Only update the provider if the title actually changed from the initial state
      if (newTitle != currentState.title) {
        ref
            .read(gameEditStateProvider(_editContext).notifier)
            .updateTitle(newTitle);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: OrientationBuilder(
          builder:
              (context, orientation) => _buildResponsiveContent(orientation),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        onPressed: _handleBackPressed,
      ),
      title: Text(
        widget.isAddMode ? 'Add Game' : 'Edit Game',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(Orientation orientation) {
    final isLandscape = orientation == Orientation.landscape;

    if (isLandscape) {
      return _buildLandscapeContent();
    } else {
      return _buildPortraitContent();
    }
  }

  Widget _buildPortraitContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: GameDetailSheetStyles.contentPadding,
        child: AnimatedEditForm(
          children: [
            _buildPortraitLayout(),
            const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
            _buildStatusSelector(),
            const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeContent() {
    return Padding(
      padding: GameDetailSheetStyles.contentPaddingLandscape,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: AnimatedEditForm(
                children: [
                  _buildLandscapeLayout(),
                  const SizedBox(
                    height: GameDetailSheetStyles.sectionSpacingLandscape,
                  ),
                  _buildStatusSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacingLandscape),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: GameDetailSheetStyles.gameImageWidthPortrait,
              child: GameImage(
                heroTag: 'game_image_${widget.game?.id ?? ''}',
                imagePath: editState.imagePath,
                onTap: _handleImageTap,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInfoSection(
                isPortrait: true,
                showPlatformAndStatus: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoSection(
          isPortrait: true,
          showPlatformAndStatus: true,
          showTitle: false,
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: GameImage(
            heroTag: 'game_image_${widget.game?.id ?? ''}',
            imagePath: editState.imagePath,
            onTap: _handleImageTap,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: _buildInfoSection(
            isPortrait: false,
            showPlatformAndStatus: true,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required bool isPortrait,
    required bool showPlatformAndStatus,
    bool showTitle = true,
  }) {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return GameEditInfoSection(
      titleController: _titleController,
      selectedPlatform: editState.platform,
      onPlatformChanged: _handlePlatformChange,
      isPortrait: isPortrait,
      showPlatformAndStatus: showPlatformAndStatus,
      showTitle: showTitle,
      isAddMode: widget.isAddMode,
    );
  }

  Widget _buildStatusSelector() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return GameStatusSelector(
      selectedStatus: editState.status,
      onStatusChanged: _handleStatusChange,
    );
  }

  Widget _buildActionButtons() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return GameEditActions(
      onSavePressed: _saveChanges,
      hasChanges: editState.hasUnsavedChanges,
      buttonText: widget.isAddMode ? 'Add Game' : 'Save Changes',
    );
  }

  // Business logic methods

  Future<void> _handleImageTap() async {
    final editState = ref.read(gameEditStateProvider(_editContext));

    final result = await ImageSelectionBottomSheet.show(
      context: context,
      hasExistingImage: editState.imagePath != null,
    );

    if (result != null) {
      if (result == 'remove') {
        _removeImage();
      } else if (result is GameImageSource) {
        await _selectImage(result);
      }
    }
  }

  Future<void> _selectImage(GameImageSource source) async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final imagePath = await gameImageService.selectAndSaveImage(source);

    if (imagePath != null) {
      ref
          .read(gameEditStateProvider(_editContext).notifier)
          .updateImagePath(imagePath);
    }
  }

  void _removeImage() {
    ref
        .read(gameEditStateProvider(_editContext).notifier)
        .updateImagePath(null);
  }

  void _handleStatusChange(GameStatus status) {
    ref.read(gameEditStateProvider(_editContext).notifier).updateStatus(status);
  }

  void _handlePlatformChange(String platform) {
    ref
        .read(gameEditStateProvider(_editContext).notifier)
        .updatePlatform(platform);
  }

  void _handleBackPressed() {
    final editState = ref.read(gameEditStateProvider(_editContext));

    if (editState.hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Do you want to save them before leaving?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close edit screen
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _saveChanges(); // Save and close
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    final editState = ref.read(gameEditStateProvider(_editContext));

    if (!editState.hasUnsavedChanges) {
      Navigator.of(context).pop();
      return;
    }

    final gameActionsService = ref.read(gameActionsServiceProvider);

    if (widget.isAddMode) {
      // Adding a new game - use GameItem.create for automatic timestamp handling
      final newGame = GameItem.create(
        title: editState.title.trim(),
        platform: editState.platform,
        status: editState.status,
        imagePath: editState.imagePath,
      );

      await gameActionsService.addGame(newGame, context);
    } else {
      // Editing existing game
      final updatedGame = widget.game!.copyWith(
        title: editState.title.trim(),
        platform: editState.platform,
        status: editState.status,
        imagePath: editState.imagePath,
      );

      await gameActionsService.updateGame(widget.game!, updatedGame, context);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
