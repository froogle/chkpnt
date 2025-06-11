import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'game_detail_sheet_info.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'game_detail_sheet_actions.dart';
import 'package:chkpnt/services/game_actions_service.dart';

class GameDetailSheet extends ConsumerStatefulWidget {
  final GameItem game;
  final VoidCallback? onEditPressed;

  const GameDetailSheet({super.key, required this.game, this.onEditPressed});

  @override
  ConsumerState<GameDetailSheet> createState() => _GameDetailSheetState();
}

class _GameDetailSheetState extends ConsumerState<GameDetailSheet> {
  late GameStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.game.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppLayout.sheetDecoration,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) => _buildResponsiveContent(orientation),
      ),
    );
  }

  Widget _buildResponsiveContent(Orientation orientation) {
    final isLandscape = orientation == Orientation.landscape;
    return isLandscape ? _buildLandscapeContent() : _buildPortraitContent();
  }

  Widget _buildPortraitContent() {
    return Padding(
      padding: AppLayout.sheetContentPadding,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildPortraitScrollableContent(),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildPortraitScrollableContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPortraitLayout(),
        _buildSectionSpacing(),
        _buildStatusSelector(),
        const SizedBox(height: 16), // Spacing before bottom action area
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        _buildPortraitGameRow(),
        const SizedBox(height: 16),
        _buildPortraitPlatformInfo(),
      ],
    );
  }

  Widget _buildPortraitGameRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPortraitGameImage(),
        const SizedBox(width: 20),
        Expanded(child: _buildPortraitGameInfo()),
      ],
    );
  }

  Widget _buildPortraitGameImage() {
    return SizedBox(
      width: GameDetailSheetStyles.gameImageWidthPortrait,
      child: GestureDetector(
        onTap: widget.onEditPressed,
        child: GameImage(
          heroTag: 'game_image_${widget.game.id}',
          imagePath: widget.game.imagePath,
        ),
      ),
    );
  }

  Widget _buildPortraitGameInfo() {
    return GameDetailSheetInfo(
      game: widget.game,
      isPortrait: true,
      showPlatformAndStatus: false,
      onEditPressed: widget.onEditPressed,
    );
  }

  Widget _buildPortraitPlatformInfo() {
    return GameDetailSheetInfo(
      game: widget.game,
      isPortrait: true,
      showPlatformAndStatus: true,
      showTitle: false,
      onEditPressed: widget.onEditPressed,
    );
  }

  Widget _buildLandscapeContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        12,
        20,
      ), // Reduced top and bottom padding
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: _buildLandscapeScrollableContent(),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildLandscapeScrollableContent() {
    return Column(
      children: [
        _buildLandscapeLayout(),
        _buildLandscapeSpacing(),
        _buildStatusSelector(),
        const SizedBox(
          height: 8,
        ), // Further reduced spacing before bottom action area
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLandscapeGameImage(),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildLandscapeGameInfo()),
      ],
    );
  }

  Widget _buildLandscapeGameImage() {
    return SizedBox(
      width: 120,
      child: GestureDetector(
        onTap: widget.onEditPressed,
        child: GameImage(
          heroTag: 'game_image_${widget.game.id}',
          imagePath: widget.game.imagePath,
        ),
      ),
    );
  }

  Widget _buildLandscapeGameInfo() {
    return GameDetailSheetInfo(
      game: widget.game,
      isPortrait: false,
      showPlatformAndStatus: true,
      onEditPressed: widget.onEditPressed,
    );
  }

  Widget _buildStatusSelector() {
    return GameStatusSelector(
      selectedStatus: _selectedStatus,
      onStatusChanged: _handleStatusChange,
    );
  }

  Widget _buildActions() {
    return GameDetailSheetActions(
      onEditPressed: widget.onEditPressed,
      onSavePressed: _saveChanges,
      onDeletePressed: _showDeleteConfirmation,
      hasChanges: _hasStatusChanged(),
    );
  }

  Widget _buildSectionSpacing() {
    return const SizedBox(height: AppLayout.sheetSectionSpacing);
  }

  Widget _buildLandscapeSpacing() {
    return const SizedBox(height: 12); // Further reduced from 16px
  }

  // Business logic methods
  bool _hasStatusChanged() {
    return _selectedStatus != widget.game.status;
  }

  void _handleStatusChange(GameStatus status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  Future<void> _saveChanges() async {
    if (!_hasStatusChanged()) return;

    final updatedGame = widget.game.copyWith(status: _selectedStatus);

    // Use the game actions service to update the game and show notification
    final gameActionsService = ref.read(gameActionsServiceProvider);
    await gameActionsService.updateGame(widget.game, updatedGame, context);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Game'),
            content: Text(
              'Are you sure you want to delete "${widget.game.title}"?\n\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true && mounted) {
      await _deleteGame();
    }
  }

  Future<void> _deleteGame() async {
    try {
      // Close the detail sheet first
      Navigator.of(context).pop();

      // Then delete the game with feedback
      final gameActionsService = ref.read(gameActionsServiceProvider);
      await gameActionsService.deleteGame(widget.game, context);
    } catch (e) {
      // If there's an error, show a simple error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete ${widget.game.title}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
