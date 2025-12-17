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
  final bool defaultIsPhysical;

  const GameEditScreen._({
    super.key,
    this.game,
    required this.isAddMode,
    this.availableStatuses,
    this.defaultStatus,
    this.defaultIsPhysical = false,
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
    bool defaultIsPhysical = false,
  }) {
    return GameEditScreen._(
      key: key,
      game: null,
      isAddMode: true,
      availableStatuses: availableStatuses,
      defaultStatus: defaultStatus,
      defaultIsPhysical: defaultIsPhysical,
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
      defaultIsPhysical: widget.defaultIsPhysical,
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
      body: SafeArea(child: _buildContent()),
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
        Expanded(flex: 2, child: _buildInfoSection()),
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
    await Future.delayed(const Duration(milliseconds: 50));

    final editState = ref.read(gameEditStateProvider(_editContext));

    if (!mounted) return;
    final result = await ImageSelectionBottomSheet.show(
      context: context,
      hasExistingImage: editState.imagePath != null,
    );

    if (result != null) {
      if (result == 'remove') {
        _removeImage();
      } else if (result is GameImageSource) {
        if (result == GameImageSource.camera) {
          await _handleCameraSelection();
        } else {
          await _selectImage(result);
        }
      } else if (result == 'search') {
        if (!mounted) return;
        final selectedImageUrl = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder:
                (buildContext) =>
                    ImageSearchScreen(initialQuery: _titleController.text),
          ),
        );
        if (selectedImageUrl != null && mounted) {
          await _selectImageFromUrl(selectedImageUrl);
        }
      }
    }
  }

  Future<void> _handleCameraSelection() async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final permissionResult =
        await gameImageService.checkAndRequestCameraPermission();

    if (!mounted) return;

    switch (permissionResult) {
      case CameraPermissionResult.granted:
        await _selectImage(GameImageSource.camera);
      case CameraPermissionResult.denied:
      case CameraPermissionResult.openedSettings:
        await _showCameraPermissionDialog();
    }
  }

  Future<void> _showCameraPermissionDialog() async {
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Camera Permission Required',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          'To take photos of your game collection, ChkPnt needs access to your camera.\n\n'
          'Tap "Open Settings" to go to the app settings page, then enable the Camera permission.',
          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true && mounted) {
      final gameImageService = ref.read(gameImageServiceProvider);
      await gameImageService.openCameraSettings();
    }
  }

  Future<void> _selectImage(GameImageSource source) async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final imagePath = await gameImageService.selectAndSaveImage(source);

    if (imagePath != null) {
      // Always update the state, even if widget is disposed
      // The state provider is independent of widget lifecycle
      try {
        ref
            .read(gameEditStateProvider(_editContext).notifier)
            .updateImagePath(imagePath);
      } catch (e) {
        // If ref is disposed, at least the image is downloaded and saved
        debugPrint('Widget disposed but image was saved: $imagePath');
      }
    }
  }

  Future<void> _selectImageFromUrl(String imageUrl) async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final imagePath = await gameImageService.downloadAndSaveImageFromUrl(
      imageUrl,
    );
    if (imagePath != null) {
      // Always update the state, even if widget is disposed
      // The state provider is independent of widget lifecycle
      try {
        ref
            .read(gameEditStateProvider(_editContext).notifier)
            .updateImagePath(imagePath);
      } catch (e) {
        // If ref is disposed, at least the image is downloaded and saved
        debugPrint('Widget disposed but image was saved: $imagePath');
      }
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
    final editState = ref.read(gameEditStateProvider(_editContext));

    if (widget.isAddMode) {
      final newGame = GameItem.create(
        title: _titleController.text.trim(),
        platform: editState.platform,
        status: editState.status,
        imagePath: editState.imagePath,
        isPhysical: editState.isPhysical,
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
        platform: editState.platform,
        status: editState.status,
        imagePath: editState.imagePath,
        isPhysical: editState.isPhysical,
      );

      await gameActionsService.updateGame(widget.game!, updatedGame, context);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
