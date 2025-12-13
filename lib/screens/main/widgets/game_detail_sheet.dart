import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_info.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_actions.dart';
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
    return _buildContent();
  }

  Widget _buildContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 12, 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildGameHeader(),
                    _buildSpacing(),
                    _buildStatusSelector(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGameImage(),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildGameInfo()),
      ],
    );
  }

  Widget _buildGameImage() {
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

  Widget _buildGameInfo() {
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

  Widget _buildSpacing() {
    return const SizedBox(height: 12);
  }

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
      Navigator.of(context).pop();

      final gameActionsService = ref.read(gameActionsServiceProvider);
      await gameActionsService.deleteGame(widget.game, context);
    } catch (e) {
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
