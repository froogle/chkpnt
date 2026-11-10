import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/shared/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';
import 'package:chkpnt/services/guide_storage_service.dart';
import 'package:chkpnt/services/guide_reader_preferences_service.dart';
import 'package:chkpnt/providers/guide_provider.dart';
import 'package:chkpnt/providers/reading_position_provider.dart';
import 'package:chkpnt/screens/guide_reader/guide_web_reader_screen.dart';
import 'package:chkpnt/screens/guide_reader/widgets/attribution_modal.dart';

class GuideReaderScreen extends ConsumerStatefulWidget {
  final GuideItem guide;

  const GuideReaderScreen({super.key, required this.guide});

  @override
  ConsumerState<GuideReaderScreen> createState() => _GuideReaderScreenState();
}

class _GuideReaderScreenState extends ConsumerState<GuideReaderScreen> {
  bool _showToolbar = false;
  GuideReaderPreferences _preferences = const GuideReaderPreferences();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
    _loadPreferences();
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }

  void _onPositionsChanged() {
    final topIndex = _topVisibleIndex();
    if (topIndex == null) return;
    ref
        .read(readingPositionProvider(widget.guide.id).notifier)
        .moveTo(topIndex);
  }

  int? _topVisibleIndex() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return null;

    final visibleItems = positions
        .where(
          (position) =>
              position.itemLeadingEdge < 1 && position.itemTrailingEdge > 0,
        )
        .toList();

    if (visibleItems.isEmpty) return null;

    visibleItems.sort((a, b) => a.itemLeadingEdge.compareTo(b.itemLeadingEdge));
    return visibleItems.first.index;
  }

  Future<void> _loadPreferences() async {
    final prefsService = ref.read(guideReaderPreferencesServiceProvider);
    final prefs = await prefsService.getPreferences();
    if (mounted) {
      setState(() {
        _preferences = prefs;
      });

      if (!widget.guide.hasSeenAttribution) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAttributionModal();
        });
      }
    }
  }

  Future<void> _showAttributionModal() async {
    await AttributionModal.show(context, _markAttributionModalSeen);
  }

  Future<void> _markAttributionModalSeen() async {
    await ref
        .read(guidesForGameProvider(widget.guide.gameId).notifier)
        .markAttributionSeen(widget.guide.id);
  }

  Future<void> _savePreferences() async {
    final prefsService = ref.read(guideReaderPreferencesServiceProvider);
    await prefsService.savePreferences(_preferences);
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  void _toggleToolbar() {
    setState(() {
      _showToolbar = !_showToolbar;
    });
  }

  void _increaseFontSize() {
    if (_preferences.canIncreaseFontSize) {
      setState(() {
        _preferences = _preferences.increaseFontSize();
      });
      _savePreferences();
    }
  }

  void _decreaseFontSize() {
    if (_preferences.canDecreaseFontSize) {
      setState(() {
        _preferences = _preferences.decreaseFontSize();
      });
      _savePreferences();
    }
  }

  void _toggleColours() {
    setState(() {
      _preferences = _preferences.toggleInvertedColours();
    });
    _savePreferences();
  }

  void _visitOriginalGuide() {
    final sourceUrl = widget.guide.sourceUrl;
    if (sourceUrl == null || sourceUrl.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuideWebReaderScreen(
          guide: widget.guide,
          url: sourceUrl,
          canDelete: false,
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Delete Guide',
      itemName: widget.guide.title,
    );

    if (confirmed && mounted) {
      await _deleteGuide();
    }
  }

  Future<void> _deleteGuide() async {
    try {
      final storageService = ref.read(guideStorageServiceProvider);
      await storageService.deleteGuideFile(widget.guide.fileName);

      await ref
          .read(guidesForGameProvider(widget.guide.gameId).notifier)
          .deleteGuide(widget.guide.id);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted: ${widget.guide.title}'),
            backgroundColor: AppColors.primaryPurple,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete guide'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Color get _backgroundColor =>
      _preferences.invertedColours ? Colors.white : Colors.black;

  Color get _textColour =>
      _preferences.invertedColours ? Colors.black : Colors.white;

  Color get _secondaryTextColour => _preferences.invertedColours
      ? Colors.black.withValues(alpha: 0.6)
      : Colors.white.withValues(alpha: 0.6);

  Color get _preformattedBackgroundColour => _preferences.invertedColours
      ? Colors.black.withValues(alpha: 0.05)
      : Colors.white.withValues(alpha: 0.05);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildAnimatedToolbar(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedToolbar() {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: _showToolbar ? _buildToolbar() : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: _textColour.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildCloseButton(),
          const SizedBox(width: 12),
          Expanded(child: _buildTitleSection()),
          _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleToolbar,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.menu, color: _textColour, size: 24),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleClose,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close, color: _textColour, size: 24),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.guide.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColour,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'by ${widget.guide.author}',
          style: TextStyle(fontSize: 12, color: _secondaryTextColour),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ref
        .watch(readingPositionProvider(widget.guide.id))
        .when(
          data: _buildGuideContent,
          loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.primaryPurple),
          ),
          error: (error, stack) => _buildErrorState(),
        );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load guide content',
              style: TextStyle(fontSize: 16, color: _textColour),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _handleClose,
              style: OutlinedButton.styleFrom(
                foregroundColor: _textColour,
                side: BorderSide(color: _textColour.withValues(alpha: 0.5)),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideContent(TextGuideReading reading) {
    return ScrollablePositionedList.builder(
      initialScrollIndex: reading.startIndex,
      itemPositionsListener: _itemPositionsListener,
      padding: const EdgeInsets.all(16),
      itemCount: reading.items.length,
      itemBuilder: (context, index) => _buildListItem(reading.items[index]),
    );
  }

  Widget _buildListItem(GuideListItem item) {
    return switch (item) {
      SectionHeaderItem(:final title) => _buildSectionHeader(title),
      ContentBlockItem(:final block) => _buildBlock(block),
      SectionSpacerItem() => const SizedBox(height: 24),
    };
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _preferences.fontSize + 4,
          fontWeight: FontWeight.bold,
          color: _textColour,
        ),
      ),
    );
  }

  Widget _buildBlock(ContentBlock block) {
    if (block.preformatted) {
      return _buildPreformattedBlock(block.content);
    }
    return _buildTextBlock(block.content);
  }

  Widget _buildTextBlock(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        content,
        style: TextStyle(
          fontSize: _preferences.fontSize,
          color: _textColour,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildPreformattedBlock(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _preformattedBackgroundColour,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'monospace',
              color: _textColour.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    final toolbarBackgroundColour = _preferences.invertedColours
        ? Colors.white
        : Colors.black;
    final toolbarTextColour = _preferences.invertedColours
        ? Colors.black
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: toolbarBackgroundColour,
        border: Border(
          bottom: BorderSide(
            color: toolbarTextColour.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFontSizeControls(),
              _buildColourToggle(),
              _buildDeleteButton(),
            ],
          ),
          if (widget.guide.sourceUrl != null &&
              widget.guide.sourceUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _visitOriginalGuide,
                icon: Icon(Icons.open_in_browser, color: toolbarTextColour),
                label: Text(
                  'Visit Original Guide',
                  style: TextStyle(color: toolbarTextColour),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: toolbarTextColour.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFontSizeControls() {
    final toolbarTextColour = _preferences.invertedColours
        ? Colors.black
        : Colors.white;

    return Row(
      children: [
        IconButton(
          onPressed: _preferences.canDecreaseFontSize
              ? _decreaseFontSize
              : null,
          icon: Icon(
            Icons.text_decrease,
            color: _preferences.canDecreaseFontSize
                ? toolbarTextColour
                : toolbarTextColour.withValues(alpha: 0.3),
          ),
        ),
        Text(
          'A',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: toolbarTextColour,
          ),
        ),
        IconButton(
          onPressed: _preferences.canIncreaseFontSize
              ? _increaseFontSize
              : null,
          icon: Icon(
            Icons.text_increase,
            color: _preferences.canIncreaseFontSize
                ? toolbarTextColour
                : toolbarTextColour.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildColourToggle() {
    final toolbarTextColour = _preferences.invertedColours
        ? Colors.black
        : Colors.white;

    return IconButton(
      onPressed: _toggleColours,
      icon: Icon(
        _preferences.invertedColours ? Icons.light_mode : Icons.dark_mode,
        color: toolbarTextColour,
      ),
      tooltip: _preferences.invertedColours ? 'Dark mode' : 'Light mode',
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: _showDeleteConfirmation,
      icon: Icon(Icons.delete_outline, color: Colors.red),
      tooltip: 'Delete guide',
    );
  }
}
