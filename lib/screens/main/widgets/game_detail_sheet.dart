import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/shared/widgets/cards/game_image.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_info.dart';
import 'package:chkpnt/shared/widgets/inputs/game_status_selector.dart';
import 'package:chkpnt/screens/main/widgets/game_detail_sheet_actions.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/providers/guide_provider.dart';
import 'package:chkpnt/screens/guide_browser/guide_browser_screen.dart';
import 'package:chkpnt/screens/guide_browser/widgets/guide_browser_page_route.dart';
import 'package:chkpnt/screens/guide_reader/guide_reader_screen.dart';
import 'package:chkpnt/screens/guide_reader/guide_web_reader_screen.dart';
import 'package:chkpnt/screens/guide_reader/widgets/guide_reader_page_route.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/shared/widgets/dialogs/confirm_delete_dialog.dart';

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
                    _buildGuides(),
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

  Widget _buildGuides() {
    final guides = ref.watch(guidesForGameProvider(widget.game.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text(
          'Guides',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        if (guides.isEmpty)
          _buildNoGuidesMessage()
        else
          _buildGuidesList(guides),
        const SizedBox(height: 12),
        _buildFindGuideButton(),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildNoGuidesMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'No guides saved',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.expandIcon,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildGuidesList(List<GuideItem> guides) {
    return Column(
      children: guides.map((guide) => _buildGuideListItem(guide)).toList(),
    );
  }

  Widget _buildGuideListItem(GuideItem guide) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _openGuide(guide),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.collapsibleSection,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                guide.format == GuideFormat.html
                    ? Icons.language
                    : Icons.menu_book,
                size: 18,
                color: AppColors.primaryPurple,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  guide.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.expandIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindGuideButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _openGuideBrowser,
        icon: Icon(Icons.search, size: 18),
        label: Text('Find a Guide'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _openGuideBrowser() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      GuideBrowserPageRoute(
        child: GuideBrowserScreen(
          gameId: widget.game.id,
          gameTitle: widget.game.title,
        ),
      ),
    );
  }

  void _openGuide(GuideItem guide) {
    final screen = switch (guide) {
      GuideItem(format: GuideFormat.html, sourceUrl: final url?) =>
        GuideWebReaderScreen(guide: guide, url: url),
      _ => GuideReaderScreen(guide: guide),
    };
    Navigator.of(context).pop();
    Navigator.of(context).push(GuideReaderPageRoute(child: screen));
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
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Delete Game',
      itemName: widget.game.title,
    );

    if (confirmed && mounted) {
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
