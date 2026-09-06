import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/barcode_lookup_service.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/screens/edit/widgets/game_edit_info_section.dart';
import 'package:chkpnt/screens/edit/widgets/game_edit_actions.dart';
import 'package:chkpnt/screens/edit/widgets/barcode_scanner_screen.dart';
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
  bool _isLookingUpBarcode = false;

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
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            if (_isLookingUpBarcode) _buildLookupOverlay(),
          ],
        ),
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
      padding: GameDetailSheetStyles.editContentPadding,
      child: Column(
        children: [
          Expanded(child: _buildScrollableContent()),
          const SizedBox(height: GameDetailSheetStyles.editSectionSpacing),
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
          const SizedBox(height: GameDetailSheetStyles.editSectionSpacing),
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
        const SizedBox(width: EditScreenStyles.horizontalSpacing),
        Expanded(flex: 2, child: _buildInfoSection()),
      ],
    );
  }

  Widget _buildGameImage(GameEditFormState editState) {
    return SizedBox(
      width: EditScreenStyles.gameImageWidth,
      child: Column(
        children: [
          GameImage(
            heroTag: 'game_image_${widget.game?.id ?? ''}',
            imagePath: editState.imagePath,
            onTap: _handleImageTap,
          ),
          if (widget.isAddMode) _buildScanBarcodeButton(),
        ],
      ),
    );
  }

  Widget _buildScanBarcodeButton() {
    return TextButton.icon(
      onPressed: _handleBarcodeScan,
      icon: const Icon(
        Icons.qr_code_scanner,
        size: EditScreenStyles.scanBarcodeIconSize,
        color: EditScreenStyles.scanBarcodeColour,
      ),
      label: const Text(
        'Scan Barcode',
        style: EditScreenStyles.scanBarcodeTextStyle,
      ),
      style: TextButton.styleFrom(
        foregroundColor: EditScreenStyles.scanBarcodeColour,
        padding: EditScreenStyles.scanBarcodePadding,
      ),
    );
  }

  Widget _buildLookupOverlay() {
    return const Positioned.fill(
      child: ColoredBox(
        color: EditScreenStyles.lookupOverlayColour,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
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

  Future<void> _handleBarcodeScan() async {
    final gameImageService = ref.read(gameImageServiceProvider);
    final permissionResult =
        await gameImageService.checkAndRequestCameraPermission();

    if (!mounted) return;

    switch (permissionResult) {
      case CameraPermissionResult.granted:
        await _scanAndPrefill();
      case CameraPermissionResult.denied:
      case CameraPermissionResult.openedSettings:
        await _showCameraPermissionDialog();
    }
  }

  Future<void> _scanAndPrefill() async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (buildContext) => const BarcodeScannerScreen()),
    );

    if (barcode == null || !mounted) return;

    final existingGame = _findGameWithBarcode(barcode);
    if (existingGame != null) {
      await _showDuplicateGameDialog(existingGame);
      return;
    }

    setState(() => _isLookingUpBarcode = true);
    final result = await ref.read(barcodeLookupServiceProvider).lookup(barcode);

    if (!mounted) return;
    setState(() => _isLookingUpBarcode = false);

    _applyScanResult(barcode, result);

    final message = _lookupFailureMessage(result.outcome);
    if (message != null) {
      _showScanMessage(message);
      return;
    }

    if (result.title.isNotEmpty) {
      _offerCoverArt(result);
    }
  }

  GameItem? _findGameWithBarcode(String barcode) {
    final scanned = BarcodeLookupService.normaliseBarcode(barcode);

    for (final game in ref.read(gameListProvider)) {
      final stored = game.barcode;
      if (stored != null &&
          BarcodeLookupService.normaliseBarcode(stored) == scanned) {
        return game;
      }
    }
    return null;
  }

  void _applyScanResult(String barcode, BarcodeLookupResult result) {
    if (result.title.isNotEmpty) {
      _titleController.text = result.title;
    }
    ref
        .read(gameEditStateProvider(_editContext).notifier)
        .applyBarcodeScan(
          barcode: barcode,
          title: result.title,
          platform: _matchExistingPlatform(result.platform),
        );
  }

  String _matchExistingPlatform(String? detectedPlatform) {
    if (detectedPlatform == null) return '';

    for (final platform in ref.read(availablePlatformsProvider)) {
      if (platform.toLowerCase() == detectedPlatform.toLowerCase()) {
        return platform;
      }
    }

    return '';
  }

  String? _lookupFailureMessage(BarcodeLookupOutcome outcome) {
    switch (outcome) {
      case BarcodeLookupOutcome.found:
        return null;
      case BarcodeLookupOutcome.notFound:
        return 'That barcode is not in the lookup service. Fill in the details '
            'yourself and the code will be saved with the game.';
      case BarcodeLookupOutcome.noNetwork:
        return 'The lookup could not reach the internet. Fill in the details '
            'yourself and the code will be saved with the game.';
      case BarcodeLookupOutcome.limitReached:
        return 'The daily barcode lookup limit has been reached. Try again '
            'tomorrow, or fill in the details yourself.';
      case BarcodeLookupOutcome.serverError:
        return 'The lookup service is not answering right now. Fill in the '
            'details yourself and the code will be saved with the game.';
    }
  }

  void _offerCoverArt(BarcodeLookupResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Found ${result.title}. Add cover art?',
          style: EditScreenStyles.scanMessageTextStyle,
        ),
        backgroundColor: EditScreenStyles.scanMessageBackgroundColour,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Find Cover',
          textColor: EditScreenStyles.scanBarcodeColour,
          onPressed: () => _searchCoverArt(result),
        ),
      ),
    );
  }

  Future<void> _searchCoverArt(BarcodeLookupResult result) async {
    if (!mounted) return;

    final query = '${result.title} ${result.platform ?? ''}'.trim();
    final suggestedImageUrls =
        result.imageUrl == null ? <String>[] : <String>[result.imageUrl!];

    final selectedImageUrl = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder:
            (buildContext) => ImageSearchScreen(
              initialQuery: query,
              suggestedImageUrls: suggestedImageUrls,
            ),
      ),
    );

    if (selectedImageUrl != null && mounted) {
      await _selectImageFromUrl(selectedImageUrl);
    }
  }

  Future<void> _showDuplicateGameDialog(GameItem existingGame) async {
    final shouldOpenGame = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppDialogStyles.backgroundColor,
        surfaceTintColor: AppDialogStyles.surfaceTintColor,
        elevation: AppDialogStyles.elevation,
        shape: AppDialogStyles.shape,
        title: const Text(
          'Already In Your Collection',
          style: AppDialogStyles.titleTextStyle,
        ),
        content: Text(
          '${existingGame.title} (${existingGame.platform}) already has this '
          'barcode, so it has not been added again.',
          style: AppDialogStyles.contentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: AppDialogStyles.buttonStyle(
              AppDialogStyles.cancelButtonColor,
            ),
            child: const Text('Cancel', style: AppDialogStyles.buttonTextStyle),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppDialogStyles.confirmButtonColor,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Open Game',
              style: AppDialogStyles.buttonTextStyle,
            ),
          ),
        ],
      ),
    );

    if (shouldOpenGame == true && mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (buildContext) => GameEditScreen.edit(game: existingGame),
        ),
      );
    }
  }

  void _showScanMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: EditScreenStyles.scanMessageTextStyle,
        ),
        backgroundColor: EditScreenStyles.scanMessageBackgroundColour,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

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
        backgroundColor: AppDialogStyles.backgroundColor,
        surfaceTintColor: AppDialogStyles.surfaceTintColor,
        elevation: AppDialogStyles.elevation,
        shape: AppDialogStyles.shape,
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
            style: AppDialogStyles.buttonStyle(
              AppDialogStyles.cancelButtonColor,
            ),
            child: const Text(
              'Cancel',
              style: AppDialogStyles.buttonTextStyle,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppDialogStyles.confirmButtonColor,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Open Settings',
              style: AppDialogStyles.buttonTextStyle,
            ),
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
        barcode: editState.barcode,
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
