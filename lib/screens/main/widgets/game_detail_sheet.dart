import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/game_models.dart';
import '../../../styles/styles.dart';
import '../../../providers/game_provider.dart';
import 'game_detail_sheet_image.dart';
import 'game_detail_sheet_info.dart';
import 'game_detail_sheet_status_section.dart';
import 'game_detail_sheet_actions.dart';

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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPortraitLayout(),
            const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
            GameDetailSheetStatusSection(
              selectedStatus: _selectedStatus,
              onStatusChanged: _handleStatusChange,
            ),
            const SizedBox(height: GameDetailSheetStyles.sectionSpacing),
            GameDetailSheetActions(
              onEditPressed: widget.onEditPressed,
              onSavePressed: _saveChanges,
              hasChanges: _hasStatusChanged(),
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
              child: Column(
                children: [
                  _buildLandscapeLayout(),
                  const SizedBox(
                    height: GameDetailSheetStyles.sectionSpacingLandscape,
                  ),
                  GameDetailSheetStatusSection(
                    selectedStatus: _selectedStatus,
                    onStatusChanged: _handleStatusChange,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: GameDetailSheetStyles.sectionSpacingLandscape),
          GameDetailSheetActions(
            onEditPressed: widget.onEditPressed,
            onSavePressed: _saveChanges,
            hasChanges: _hasStatusChanged(),
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
              child: const GameDetailSheetImage(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GameDetailSheetInfo(
                game: widget.game,
                isPortrait: true,
                showPlatformAndStatus: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GameDetailSheetInfo(
          game: widget.game,
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
        const SizedBox(width: 120, child: GameDetailSheetImage()),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: GameDetailSheetInfo(
            game: widget.game,
            isPortrait: false,
            showPlatformAndStatus: true,
          ),
        ),
      ],
    );
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

    final gameProvider = ref.read(gameListProvider.notifier);
    final updatedGame = widget.game.copyWith(status: _selectedStatus);
    gameProvider.updateGame(updatedGame);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
