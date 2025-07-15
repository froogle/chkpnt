import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/screens/edit/widgets/game_edit_info_section.dart';
import 'package:chkpnt/screens/edit/widgets/game_edit_actions.dart';
import 'package:chkpnt/screens/edit/widgets/image_selection_bottom_sheet.dart';
import 'package:chkpnt/screens/image_search/image_search_screen.dart';

class GameEditScreen extends ConsumerStatefulWidget {
  final GameItem? game;
  final bool isAddMode;
  final List<GameStatus>? availableStatuses;
  final GameStatus? defaultStatus;

  const GameEditScreen._({
    super.key,
    this.game,
    required this.isAddMode,
    this.availableStatuses,
    this.defaultStatus,
  });

  // Factory constructor for editing existing games
  factory GameEditScreen.edit({Key? key, required GameItem game}) {
    return GameEditScreen._(key: key, game: game, isAddMode: false);
  }

  // Factory constructor for adding new games
  factory GameEditScreen.add({
    Key? key,
    List<GameStatus>? availableStatuses,
    GameStatus? defaultStatus,
  }) {
    return GameEditScreen._(
      key: key,
      game: null,
      isAddMode: true,
      availableStatuses: availableStatuses,
      defaultStatus: defaultStatus,
    );
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
      availableStatuses: widget.availableStatuses,
      defaultStatus: widget.defaultStatus,
    );

    // Set up title controller with initial value from provider
    final initialState = ref.read(gameEditStateProvider(_editContext));
    _titleController = TextEditingController(text: initialState.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: false, // Prevent resize issues on Android
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
    return Padding(
      padding: GameDetailSheetStyles.contentPadding,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPortraitLayout(),
                  const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
                  _buildStatusSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
          _buildActionButtons(),
        ],
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
              child: Column(
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
    // Use ref.read to avoid rebuilds that interfere with focus
    final editState = ref.read(gameEditStateProvider(_editContext));

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
    // Use ref.read to avoid rebuilds that interfere with focus
    final editState = ref.read(gameEditStateProvider(_editContext));

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
    // Use ref.read to avoid rebuilds that interfere with focus
    final editState = ref.read(gameEditStateProvider(_editContext));

    return GameEditInfoSection(
      titleController: _titleController,
      selectedPlatform: editState.platform,
      onPlatformChanged: _handlePlatformChange,
      editContext: _editContext,
      isPortrait: isPortrait,
      showPlatformAndStatus: showPlatformAndStatus,
      showTitle: showTitle,
      isAddMode: widget.isAddMode,
    );
  }

  Widget _buildStatusSelector() {
    // Use ref.read to avoid rebuilds that interfere with focus
    final editState = ref.read(gameEditStateProvider(_editContext));

    return GameStatusSelector(
      selectedStatus: editState.status,
      onStatusChanged: _handleStatusChange,
      isAddMode: widget.isAddMode,
      availableStatuses: widget.availableStatuses,
      defaultStatus: widget.defaultStatus,
    );
  }

  Widget _buildActionButtons() {
    return GameEditActions(
      onSavePressed: _saveChanges,
      hasChanges: true,
      buttonText: widget.isAddMode ? 'Add Game' : 'Save Changes',
    );
  }

  // Business logic methods

  Future<void> _handleImageTap() async {
    // Store context before async operations
    final currentContext = context;

    // Add a small delay to ensure any focus changes are processed
    await Future.delayed(const Duration(milliseconds: 50));

    final editState = ref.read(gameEditStateProvider(_editContext));

    final result = await ImageSelectionBottomSheet.show(
      context: currentContext,
      hasExistingImage: editState.imagePath != null,
    );

    if (result != null) {
      if (result == 'remove') {
        _removeImage();
      } else if (result is GameImageSource) {
        await _selectImage(result);
      } else if (result == 'search') {
        final selectedImageUrl = await Navigator.of(
          currentContext,
        ).push<String>(
          MaterialPageRoute(
            builder:
                (context) =>
                    ImageSearchScreen(initialQuery: _titleController.text),
          ),
        );
        if (selectedImageUrl != null) {
          await _selectImageFromUrl(selectedImageUrl);
        }
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

  Future<void> _selectImageFromUrl(String imageUrl) async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final imagePath = await gameImageService.downloadAndSaveImageFromUrl(
      imageUrl,
    );
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
    Navigator.of(context).pop();
  }

  Future<void> _saveChanges() async {
    final gameActionsService = ref.read(gameActionsServiceProvider);

    if (widget.isAddMode) {
      // Adding a new game - use GameItem.create for automatic timestamp handling
      final newGame = GameItem.create(
        title: _titleController.text.trim(),
        platform: ref.read(gameEditStateProvider(_editContext)).platform,
        status: ref.read(gameEditStateProvider(_editContext)).status,
        imagePath: ref.read(gameEditStateProvider(_editContext)).imagePath,
      );

      // Check if we're adding a backlog game that should be handled by the backlog screen
      final isBacklogGame = newGame.status == GameStatus.backlog;

      if (isBacklogGame) {
        // For backlog games, add and let the calling screen handle feedback
        await gameActionsService.addGame(newGame, context);

        // Return the game to the calling screen for custom handling
        if (mounted) {
          Navigator.of(context).pop(newGame);
        }
        return;
      } else {
        // For non-backlog games, use the normal flow
        await gameActionsService.addGame(newGame, context);
      }
    } else {
      // Editing existing game
      final updatedGame = widget.game!.copyWith(
        title: _titleController.text.trim(),
        platform: ref.read(gameEditStateProvider(_editContext)).platform,
        status: ref.read(gameEditStateProvider(_editContext)).status,
        imagePath: ref.read(gameEditStateProvider(_editContext)).imagePath,
      );

      await gameActionsService.updateGame(widget.game!, updatedGame, context);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
