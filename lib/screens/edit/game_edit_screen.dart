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
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: EditScreenStyles.appBarBackgroundColour,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: EditScreenStyles.appBarIconColour,
        ),
        onPressed: _handleBackPressed,
      ),
      title: Text(
        widget.isAddMode ? 'Add Game' : 'Edit Game',
        style: EditScreenStyles.appBarTitleStyle,
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: GameDetailSheetStyles.contentPaddingLandscape,
      child: Column(
        children: [
          Expanded(child: _buildScrollableContent()),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacingLandscape),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMainLayout(),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacingLandscape),
          _buildStatusSelector(),
        ],
      ),
    );
  }

  Widget _buildMainLayout() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGameImage(editState),
        const SizedBox(width: EditScreenStyles.horizontalSpacingLandscape),
        Expanded(
          flex: 2,
          child: _buildInfoSection(),
        ),
      ],
    );
  }

  Widget _buildGameImage(GameEditFormState editState) {
    return SizedBox(
      width: EditScreenStyles.gameImageWidthLandscape,
      child: GameImage(
        heroTag: 'game_image_${widget.game?.id ?? ''}',
        imagePath: editState.imagePath,
        onTap: _handleImageTap,
      ),
    );
  }

  Widget _buildInfoSection() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

    return GameEditInfoSection(
      titleController: _titleController,
      selectedPlatform: editState.platform,
      onPlatformChanged: _handlePlatformChange,
      editContext: _editContext,
      isAddMode: widget.isAddMode,
    );
  }

  Widget _buildStatusSelector() {
    final editState = ref.watch(gameEditStateProvider(_editContext));

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
    final currentContext = context;

    await Future.delayed(const Duration(milliseconds: 50));

    final editState = ref.read(gameEditStateProvider(_editContext));

    if (!mounted) return;
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
        if (!mounted) return;
        final selectedImageUrl = await Navigator.of(
          currentContext,
        ).push<String>(
          MaterialPageRoute(
            builder:
                (context) =>
                    ImageSearchScreen(initialQuery: _titleController.text),
          ),
        );
        if (selectedImageUrl != null && mounted) {
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
      final newGame = GameItem.create(
        title: _titleController.text.trim(),
        platform: ref.read(gameEditStateProvider(_editContext)).platform,
        status: ref.read(gameEditStateProvider(_editContext)).status,
        imagePath: ref.read(gameEditStateProvider(_editContext)).imagePath,
      );

      final isBacklogGame = newGame.status == GameStatus.backlog;

      if (isBacklogGame) {
        await gameActionsService.addGame(newGame, context);

        if (mounted) {
          Navigator.of(context).pop(newGame);
        }
        return;
      } else {
        await gameActionsService.addGame(newGame, context);
      }
    } else {
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
