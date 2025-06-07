import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'widgets/game_edit_info_section.dart';
import 'widgets/game_edit_actions.dart';
import 'widgets/animations/animated_edit_form.dart';

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
  late GameStatus _selectedStatus;
  late TextEditingController _titleController;
  late String _selectedPlatform;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.isAddMode) {
      // Default values for adding new games
      _selectedStatus = GameStatus.backlog;
      _titleController = TextEditingController(text: 'New Game');
      _selectedPlatform = '';
    } else {
      // Values from existing game for editing
      _selectedStatus = widget.game!.status;
      _titleController = TextEditingController(text: widget.game!.title);
      _selectedPlatform = widget.game!.platform;
    }

    _titleController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _titleController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges = _hasChanges();
    });
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
            GameStatusSelector(
              selectedStatus: _selectedStatus,
              onStatusChanged: _handleStatusChange,
            ),
            const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
            GameEditActions(
              onSavePressed: _saveChanges,
              hasChanges: _hasChanges(),
              buttonText: widget.isAddMode ? 'Add Game' : 'Save Changes',
            ),
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
                  GameStatusSelector(
                    selectedStatus: _selectedStatus,
                    onStatusChanged: _handleStatusChange,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacingLandscape),
          GameEditActions(
            onSavePressed: _saveChanges,
            hasChanges: _hasChanges(),
            buttonText: widget.isAddMode ? 'Add Game' : 'Save Changes',
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: GameDetailSheetStyles.gameImageWidthPortrait,
              child: GameImage(heroTag: 'game_image_${widget.game?.id ?? ''}'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GameEditInfoSection(
                titleController: _titleController,
                selectedPlatform: _selectedPlatform,
                onPlatformChanged: _handlePlatformChange,
                isPortrait: true,
                showPlatformAndStatus: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GameEditInfoSection(
          titleController: _titleController,
          selectedPlatform: _selectedPlatform,
          onPlatformChanged: _handlePlatformChange,
          isPortrait: true,
          showPlatformAndStatus: true,
          showTitle: false,
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: GameImage(heroTag: 'game_image_${widget.game?.id ?? ''}'),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: GameEditInfoSection(
            titleController: _titleController,
            selectedPlatform: _selectedPlatform,
            onPlatformChanged: _handlePlatformChange,
            isPortrait: false,
            showPlatformAndStatus: true,
          ),
        ),
      ],
    );
  }

  // Business logic methods
  bool _hasChanges() {
    if (widget.isAddMode) {
      // For add mode, check if any field has been changed from defaults
      return _titleController.text != 'New Game' ||
          _selectedPlatform != '' ||
          _selectedStatus != GameStatus.backlog;
    } else {
      // For edit mode, check if any field has been changed from original
      return _titleController.text != widget.game!.title ||
          _selectedPlatform != widget.game!.platform ||
          _selectedStatus != widget.game!.status;
    }
  }

  void _handleStatusChange(GameStatus status) {
    setState(() {
      _selectedStatus = status;
      _hasUnsavedChanges = _hasChanges();
    });
  }

  void _handlePlatformChange(String platform) {
    setState(() {
      _selectedPlatform = platform;
      _hasUnsavedChanges = _hasChanges();
    });
  }

  void _handleBackPressed() {
    if (_hasUnsavedChanges) {
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
    if (!_hasChanges()) {
      Navigator.of(context).pop();
      return;
    }

    final gameActionsService = ref.read(gameActionsServiceProvider);

    if (widget.isAddMode) {
      // Adding a new game
      final newGame = GameItem(
        id: GameId.generate(), // This will be replaced in the service
        title: _titleController.text.trim(),
        platform: _selectedPlatform,
        status: _selectedStatus,
      );

      await gameActionsService.addGame(newGame, context);
    } else {
      // Editing existing game
      final updatedGame = widget.game!.copyWith(
        title: _titleController.text.trim(),
        platform: _selectedPlatform,
        status: _selectedStatus,
      );

      await gameActionsService.updateGame(widget.game!, updatedGame, context);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
