import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'styles/styles.dart';
import 'shared/landscape_game_card.dart';
import 'shared/portrait_game_card.dart';
import 'shared/collapsible_section.dart';
import 'shared/platform_filter_dropdown.dart';
import 'shared/compact_search_bar.dart';
import 'models/game_models.dart';
import 'shared/empty_state_widget.dart';
import 'providers/game_provider.dart';
import 'providers/ui_state_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  GameItem? _animatingGame;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for platform filter changes and update section expansion
    ref.listen(selectedPlatformProvider, (previous, current) {
      _updateSectionExpansionForFilters();
    });

    // Listen for search query changes and update section expansion
    ref.listen(searchQueryProvider, (previous, current) {
      _updateSectionExpansionForFilters();
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: MainScreenStyles.backgroundColor,
          body: SafeArea(
            child: OrientationBuilder(
              builder:
                  (context, orientation) =>
                      _buildResponsiveLayout(context, orientation),
            ),
          ),
        ),
        if (_isAnimating && _animatingGame != null) _buildAnimationOverlay(),
      ],
    );
  }

  void _updateSectionExpansionForFilters() {
    final platform = ref.read(selectedPlatformProvider);
    final searchQuery = ref.read(searchQueryProvider);

    // Only auto-expand/collapse when filters are active (not on "All" and empty search)
    final hasActiveFilters = platform != 'All' || searchQuery.isNotEmpty;

    if (hasActiveFilters) {
      // Get filtered games for each section
      final playingGames = ref.read(
        fullyFilteredGamesProvider(GameStatus.playing, platform, searchQuery),
      );
      final backlogGames = ref.read(
        fullyFilteredGamesProvider(GameStatus.backlog, platform, searchQuery),
      );
      final completedGames = ref.read(
        fullyFilteredGamesProvider(GameStatus.completed, platform, searchQuery),
      );
      final abandonedGames = ref.read(
        fullyFilteredGamesProvider(GameStatus.abandoned, platform, searchQuery),
      );

      // Update section expansion based on results
      ref
          .read(sectionExpansionProvider.notifier)
          .updateExpansionBasedOnResults(
            playingGames: playingGames,
            backlogGames: backlogGames,
            completedGames: completedGames,
            abandonedGames: abandonedGames,
          );
    }
  }

  Widget _buildResponsiveLayout(BuildContext context, Orientation orientation) {
    final isLandscape = orientation == Orientation.landscape;
    return isLandscape
        ? _buildLandscapeLayout(context)
        : _buildPortraitLayout(context);
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        _buildCompactHeader(),
        Expanded(child: _buildPortraitContent()),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        _buildCompactHeader(),
        Expanded(child: _buildLandscapeContent(context)),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildPortraitContent() {
    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPortraitSection('Playing', GameStatus.playing),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Backlog', GameStatus.backlog),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Completed', GameStatus.completed),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Abandoned', GameStatus.abandoned),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(BuildContext context) {
    final crossAxisCount = _calculateGridColumns(context);

    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLandscapeSection('Playing', GameStatus.playing, crossAxisCount),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection('Backlog', GameStatus.backlog, crossAxisCount),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection(
            'Completed',
            GameStatus.completed,
            crossAxisCount,
          ),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection(
            'Abandoned',
            GameStatus.abandoned,
            crossAxisCount,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final availablePlatforms = ref.watch(availablePlatformsProvider);

    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Row(
        children: [
          PlatformFilterDropdown(
            selectedPlatform: selectedPlatform,
            platforms: availablePlatforms,
            onPlatformChanged: (platform) {
              ref
                  .read(selectedPlatformProvider.notifier)
                  .selectPlatform(platform);
            },
          ),
          const SizedBox(width: 12),
          const Expanded(child: CompactSearchBar()),
          const SizedBox(width: 12),
          _buildAddGameIconButton(),
        ],
      ),
    );
  }

  Widget _buildAddGameIconButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add, color: Colors.white, size: 24),
      tooltip: 'Add New Game',
      style: _buildAddGameIconButtonStyle(),
    );
  }

  ButtonStyle _buildAddGameIconButtonStyle() {
    return IconButton.styleFrom(
      backgroundColor: MainScreenStyles.secondaryButtonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: MainScreenStyles.addGameIconButtonPadding,
    );
  }

  Widget _buildPortraitSection(String title, GameStatus status) {
    final sectionExpansion = ref.watch(sectionExpansionProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final games = ref.watch(
      fullyFilteredGamesProvider(status, selectedPlatform, searchQuery),
    );
    final isExpanded = sectionExpansion[title] ?? false;

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle:
          () =>
              ref.read(sectionExpansionProvider.notifier).toggleSection(title),
      isEmpty: games.isEmpty,
      emptyStateWidget: games.isEmpty ? _buildEmptyState(title) : null,
      content: _buildPortraitGamesList(games),
    );
  }

  Widget _buildLandscapeSection(
    String title,
    GameStatus status,
    int crossAxisCount,
  ) {
    final sectionExpansion = ref.watch(sectionExpansionProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final games = ref.watch(
      fullyFilteredGamesProvider(status, selectedPlatform, searchQuery),
    );
    final isExpanded = sectionExpansion[title] ?? false;

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle:
          () =>
              ref.read(sectionExpansionProvider.notifier).toggleSection(title),
      isEmpty: games.isEmpty,
      emptyStateWidget: games.isEmpty ? _buildEmptyState(title) : null,
      content: _buildLandscapeGamesGrid(games, crossAxisCount),
    );
  }

  Widget _buildPortraitGamesList(List<GameItem> games) {
    return Column(
      children:
          games
              .map(
                (game) => AnimatedOpacity(
                  opacity:
                      _isAnimating && _animatingGame?.id == game.id ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: MainScreenStyles.gameCardMargin,
                    child: PortraitGameCard(
                      game: game,
                      onTap: () => _showGameDetails(game),
                      onPlayPressed:
                          game.status == GameStatus.backlog
                              ? () => _handleStartPlaying(game)
                              : null,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildLandscapeGamesGrid(List<GameItem> games, int crossAxisCount) {
    final gridHeight = _calculateGridHeight(games.length, crossAxisCount);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _buildGridDelegate(crossAxisCount),
        itemCount: games.length,
        itemBuilder:
            (context, index) => AnimatedOpacity(
              opacity:
                  _isAnimating && _animatingGame?.id == games[index].id
                      ? 0.0
                      : 1.0,
              duration: const Duration(milliseconds: 200),
              child: LandscapeGameCard(
                game: games[index],
                onTap: () => _showGameDetails(games[index]),
                onPlayPressed:
                    games[index].status == GameStatus.backlog
                        ? () => _handleStartPlaying(games[index])
                        : null,
              ),
            ),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
    int crossAxisCount,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: MainScreenStyles.landscapeGridSpacing,
      mainAxisSpacing: MainScreenStyles.landscapeGridSpacing,
      childAspectRatio: MainScreenStyles.landscapeGameCardAspectRatio,
    );
  }

  Widget _buildEmptyState(String sectionName) {
    return EmptyStateWidget(
      icon: Icons.gamepad_outlined,
      message: 'No games in ${sectionName.toLowerCase()}',
      actionButton: null,
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: MainScreenStyles.bottomNavHeight,
      decoration: MainScreenStyles.bottomNavDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIconButton(Icons.bookmark_outline),
          _buildNavIconButton(Icons.grid_view_outlined),
          _buildNavIconButton(Icons.person_outline),
          _buildNavIconButton(Icons.circle_outlined),
        ],
      ),
    );
  }

  Widget _buildNavIconButton(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: const Color(0xFFDFB268)),
    );
  }

  // Business logic methods

  int _calculateGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 5;
    if (screenWidth > 700) return 4;
    return 3;
  }

  double _calculateGridHeight(int itemCount, int crossAxisCount) {
    const cardHeight = 180.0;
    final rowCount = (itemCount / crossAxisCount).ceil();
    final spacing = MainScreenStyles.landscapeGridSpacing;
    return (rowCount * cardHeight) + ((rowCount - 1) * spacing);
  }

  void _handleStartPlaying(GameItem game) {
    _startGameTransitionAnimation(game);
  }

  Future<void> _startGameTransitionAnimation(GameItem game) async {
    if (_isAnimating) return;

    setState(() {
      _animatingGame = game;
      _isAnimating = true;
    });

    // Ensure playing section is expanded for better visual feedback
    ref.read(sectionExpansionProvider.notifier).expandSection('Playing');

    // Start the animation
    await _animationController.forward();

    // Small delay before making the actual change for better visual effect
    await Future.delayed(const Duration(milliseconds: 100));

    // After animation completes, actually move the game and reset animation state
    ref.read(gameListProvider.notifier).startPlaying(game.id);

    setState(() {
      _animatingGame = null;
      _isAnimating = false;
    });

    // Reset animation for next use
    _animationController.reset();

    // Small delay before showing feedback
    await Future.delayed(const Duration(milliseconds: 200));

    // Show feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.play_circle_fill, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('${game.title} moved to Playing!')),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showGameDetails(GameItem game) {
    // Navigate to game details or show details dialog
    // This will be implemented when you add game details functionality
  }

  Widget _buildAnimationOverlay() {
    if (_animatingGame == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Calculate the movement from backlog section to playing section
        final screenHeight = MediaQuery.of(context).size.height;
        final startY =
            screenHeight * 0.6; // Approximate position of backlog section
        final endY =
            screenHeight * 0.25; // Approximate position of playing section
        final currentY = startY - ((startY - endY) * _slideAnimation.value);

        return Positioned.fill(
          child: IgnorePointer(
            child: Stack(
              children: [
                // Main animated game card
                Positioned(
                  left: 20,
                  right: 20,
                  top: currentY,
                  child: Transform.scale(
                    scale:
                        1.0 +
                        (0.05 * _slideAnimation.value), // Subtle scale effect
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(
                              alpha: 0.4 * _slideAnimation.value,
                            ),
                            blurRadius: 20 * _slideAnimation.value,
                            spreadRadius: 2 * _slideAnimation.value,
                          ),
                        ],
                      ),
                      child: PortraitGameCard(
                        game: _animatingGame!,
                        onTap: () {},
                        onPlayPressed: null,
                      ),
                    ),
                  ),
                ),
                // Trail effect
                if (_slideAnimation.value > 0.2)
                  ...List.generate(3, (index) {
                    final delay = 0.15 * index;
                    final trailProgress = (_slideAnimation.value - delay).clamp(
                      0.0,
                      1.0,
                    );
                    final trailY =
                        startY - ((startY - endY) * trailProgress * 0.8);

                    return Positioned(
                      left: 20,
                      right: 20,
                      top: trailY,
                      child: Opacity(
                        opacity:
                            (0.3 - (0.1 * index)) *
                            trailProgress *
                            (1 - _slideAnimation.value),
                        child: Transform.scale(
                          scale: 0.95 - (0.05 * index),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.orange.withValues(alpha: 0.2),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                // Success indicator at destination
                if (_slideAnimation.value > 0.8)
                  Positioned(
                    left: 20,
                    right: 20,
                    top: endY - 10,
                    child: Opacity(
                      opacity:
                          (_slideAnimation.value - 0.8) * 5, // Fade in quickly
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: RadialGradient(
                            colors: [
                              Colors.green.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                            radius: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.green,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
