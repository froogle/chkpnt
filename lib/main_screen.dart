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

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for platform filter changes and update section expansion
    ref.listen(selectedPlatformProvider, (previous, current) {
      _updateSectionExpansionForFilters(ref);
    });

    // Listen for search query changes and update section expansion
    ref.listen(searchQueryProvider, (previous, current) {
      _updateSectionExpansionForFilters(ref);
    });

    return Scaffold(
      backgroundColor: MainScreenStyles.backgroundColor,
      body: SafeArea(
        child: OrientationBuilder(
          builder:
              (context, orientation) =>
                  _buildResponsiveLayout(context, orientation, ref),
        ),
      ),
    );
  }

  void _updateSectionExpansionForFilters(WidgetRef ref) {
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

  Widget _buildResponsiveLayout(
    BuildContext context,
    Orientation orientation,
    WidgetRef ref,
  ) {
    final isLandscape = orientation == Orientation.landscape;
    return isLandscape
        ? _buildLandscapeLayout(context, ref)
        : _buildPortraitLayout(context, ref);
  }

  Widget _buildPortraitLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildCompactHeader(ref),
        Expanded(child: _buildPortraitContent(ref)),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildCompactHeader(ref),
        Expanded(child: _buildLandscapeContent(context, ref)),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildPortraitContent(WidgetRef ref) {
    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPortraitSection('Playing', GameStatus.playing, ref),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Backlog', GameStatus.backlog, ref),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Completed', GameStatus.completed, ref),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildPortraitSection('Abandoned', GameStatus.abandoned, ref),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(BuildContext context, WidgetRef ref) {
    final crossAxisCount = _calculateGridColumns(context);

    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLandscapeSection(
            'Playing',
            GameStatus.playing,
            crossAxisCount,
            ref,
          ),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection(
            'Backlog',
            GameStatus.backlog,
            crossAxisCount,
            ref,
          ),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection(
            'Completed',
            GameStatus.completed,
            crossAxisCount,
            ref,
          ),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildLandscapeSection(
            'Abandoned',
            GameStatus.abandoned,
            crossAxisCount,
            ref,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader(WidgetRef ref) {
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

  Widget _buildPortraitSection(String title, GameStatus status, WidgetRef ref) {
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
      content: _buildPortraitGamesList(games, ref),
    );
  }

  Widget _buildLandscapeSection(
    String title,
    GameStatus status,
    int crossAxisCount,
    WidgetRef ref,
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
      content: _buildLandscapeGamesGrid(games, crossAxisCount, ref),
    );
  }

  Widget _buildPortraitGamesList(List<GameItem> games, WidgetRef ref) {
    return Column(
      children:
          games
              .map(
                (game) => Padding(
                  padding: MainScreenStyles.gameCardMargin,
                  child: PortraitGameCard(
                    game: game,
                    onTap: () => _showGameDetails(game),
                    onPlayPressed:
                        game.status == GameStatus.backlog
                            ? () => _handleStartPlaying(game, ref)
                            : null,
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildLandscapeGamesGrid(
    List<GameItem> games,
    int crossAxisCount,
    WidgetRef ref,
  ) {
    final gridHeight = _calculateGridHeight(games.length, crossAxisCount);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _buildGridDelegate(crossAxisCount),
        itemCount: games.length,
        itemBuilder:
            (context, index) => LandscapeGameCard(
              game: games[index],
              onTap: () => _showGameDetails(games[index]),
              onPlayPressed:
                  games[index].status == GameStatus.backlog
                      ? () => _handleStartPlaying(games[index], ref)
                      : null,
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

  void _handleStartPlaying(GameItem game, WidgetRef ref) {
    ref.read(gameListProvider.notifier).startPlaying(game.id);
    // Show a snack bar or navigation feedback
  }

  void _showGameDetails(GameItem game) {
    // Navigate to game details or show details dialog
    // This will be implemented when you add game details functionality
  }
}
