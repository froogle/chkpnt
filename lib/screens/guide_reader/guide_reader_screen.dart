import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';
import 'package:chkpnt/services/guide_storage_service.dart';
import 'package:chkpnt/services/guide_reader_preferences_service.dart';
import 'package:chkpnt/providers/guide_provider.dart';

class GuideReaderScreen extends ConsumerStatefulWidget {
  final GuideItem guide;

  const GuideReaderScreen({
    super.key,
    required this.guide,
  });

  @override
  ConsumerState<GuideReaderScreen> createState() => _GuideReaderScreenState();
}

class _GuideReaderScreenState extends ConsumerState<GuideReaderScreen> {
  GuideContent? _guideContent;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showToolbar = false;
  GuideReaderPreferences _preferences = const GuideReaderPreferences();

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollDebounceTimer;
  int _currentSectionIndex = 0;
  int _currentBlockIndex = 0;
  List<_ContentItem> _flattenedContent = [];
  bool _hasRestoredPosition = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadGuideContent();
    _loadPreferences();
  }

  @override
  void dispose() {
    _scrollDebounceTimer?.cancel();
    _saveReadPosition();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _updateCurrentPosition();
    });
  }

  void _updateCurrentPosition() {
    if (_flattenedContent.isEmpty) return;

    final scrollOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll <= 0) return;

    final scrollPercentage = scrollOffset / maxScroll;
    final estimatedIndex = (scrollPercentage * (_flattenedContent.length - 1)).round();
    final clampedIndex = estimatedIndex.clamp(0, _flattenedContent.length - 1);

    final item = _flattenedContent[clampedIndex];
    _currentSectionIndex = item.sectionIndex;
    _currentBlockIndex = item.blockIndex;
  }

  Future<void> _saveReadPosition() async {
    if (_guideContent == null) return;

    try {
      await ref
          .read(guidesForGameProvider(widget.guide.gameId).notifier)
          .updateReadPosition(widget.guide.id, _currentSectionIndex, _currentBlockIndex);
    } catch (e) {
      // Silently fail - position saving is not critical
    }
  }

  void _restoreReadPosition() {
    if (_hasRestoredPosition) return;
    if (_flattenedContent.isEmpty) return;
    if (_scrollController.positions.isEmpty) return;

    _hasRestoredPosition = true;

    final targetSection = widget.guide.lastReadSection;
    final targetBlock = widget.guide.lastReadBlock;

    if (targetSection == 0 && targetBlock == 0) return;

    int targetIndex = 0;
    for (int i = 0; i < _flattenedContent.length; i++) {
      final item = _flattenedContent[i];
      if (item.sectionIndex == targetSection && item.blockIndex >= targetBlock) {
        targetIndex = i;
        break;
      }
      if (item.sectionIndex > targetSection) {
        targetIndex = i > 0 ? i - 1 : 0;
        break;
      }
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final scrollPercentage = targetIndex / (_flattenedContent.length - 1);
    final targetOffset = scrollPercentage * maxScroll;

    _scrollController.jumpTo(targetOffset.clamp(0.0, maxScroll));
    _currentSectionIndex = targetSection;
    _currentBlockIndex = targetBlock;
  }

  Future<void> _loadGuideContent() async {
    try {
      final storageService = ref.read(guideStorageServiceProvider);
      final jsonContent = await storageService.loadGuideJson(widget.guide.fileName);
      final content = GuideContent.fromJsonString(jsonContent);

      _flattenedContent = _flattenContent(content);

      if (mounted) {
        setState(() {
          _guideContent = content;
          _isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _restoreReadPosition();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load guide content';
          _isLoading = false;
        });
      }
    }
  }

  List<_ContentItem> _flattenContent(GuideContent content) {
    final items = <_ContentItem>[];

    for (int sectionIdx = 0; sectionIdx < content.sections.length; sectionIdx++) {
      final section = content.sections[sectionIdx];
      items.add(_ContentItem(
        sectionIndex: sectionIdx,
        blockIndex: -1,
        isHeader: true,
      ));

      for (int blockIdx = 0; blockIdx < section.blocks.length; blockIdx++) {
        items.add(_ContentItem(
          sectionIndex: sectionIdx,
          blockIndex: blockIdx,
          isHeader: false,
        ));
      }
    }

    return items;
  }

  Future<void> _loadPreferences() async {
    final prefsService = ref.read(guideReaderPreferencesServiceProvider);
    final prefs = await prefsService.getPreferences();
    if (mounted) {
      setState(() {
        _preferences = prefs;
      });
    }
  }

  Future<void> _savePreferences() async {
    final prefsService = ref.read(guideReaderPreferencesServiceProvider);
    await prefsService.savePreferences(_preferences);
  }

  void _handleClose() {
    _saveReadPosition();
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

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Guide'),
        content: Text(
          'Are you sure you want to delete "${widget.guide.title}"?\n\nThis action cannot be undone.',
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
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildContent()),
              ],
            ),
            if (_showToolbar) _buildToolbarOverlay(),
          ],
        ),
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
        ],
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
          child: Icon(
            Icons.close,
            color: _textColour,
            size: 24,
          ),
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
          style: TextStyle(
            fontSize: 12,
            color: _secondaryTextColour,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryPurple,
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_guideContent == null) {
      return _buildErrorState();
    }

    return GestureDetector(
      onTap: _toggleToolbar,
      child: _buildGuideContent(),
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
              _errorMessage ?? 'Unable to load guide',
              style: TextStyle(
                fontSize: 16,
                color: _textColour,
              ),
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

  Widget _buildGuideContent() {
    final content = _guideContent!;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: content.sections.length,
      itemBuilder: (context, index) => _buildSection(content.sections[index]),
    );
  }

  Widget _buildSection(ContentSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.blocks.map((block) => _buildBlock(block)),
        const SizedBox(height: 24),
      ],
    );
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
        width: double.infinity,
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

  Widget _buildToolbarOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _preferences.invertedColours
                ? Colors.black.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: _preferences.invertedColours
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFontSizeControls(),
              _buildColourToggle(),
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeControls() {
    final toolbarTextColour = _preferences.invertedColours
        ? Colors.white
        : Colors.black;

    return Row(
      children: [
        IconButton(
          onPressed: _preferences.canDecreaseFontSize ? _decreaseFontSize : null,
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
          onPressed: _preferences.canIncreaseFontSize ? _increaseFontSize : null,
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
        ? Colors.white
        : Colors.black;

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
      icon: Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
      tooltip: 'Delete guide',
    );
  }
}

class _ContentItem {
  final int sectionIndex;
  final int blockIndex;
  final bool isHeader;

  _ContentItem({
    required this.sectionIndex,
    required this.blockIndex,
    required this.isHeader,
  });
}
