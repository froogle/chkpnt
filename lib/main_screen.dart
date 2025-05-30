import 'package:flutter/material.dart';
import 'shared/styles.dart';
import 'shared/landscape_game_card.dart';
import 'shared/portrait_game_card.dart';
import 'shared/collapsible_section.dart';
import 'shared/platform_filter_dropdown.dart';
import 'shared/compact_search_bar.dart';
import 'shared/game_models.dart';
import 'shared/empty_state_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedPlatform = 'All';
  final List<String> _platforms = [
    'All',
    'PS5',
    'PS4',
    'Switch',
    'PC',
    'Xbox',
    'Xbox 360',
    'Steam Deck',
    'Nintendo DS',
    'Game Boy',
  ];

  // Collapsible section state
  final Map<String, bool> _sectionExpanded = {
    'Playing': true,
    'Backlog': false,
    'Completed': false,
    'Abandoned': false,
  };

  final List<GameItem> _sampleGames = [
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.playing,
      progress: 0.6,
    ),
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.playing,
      progress: 0.3,
    ),
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.completed,
      progress: 1.0,
    ),
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.completed,
      progress: 1.0,
    ),
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.backlog,
      progress: 0.0,
    ),
    GameItem(
      title: 'Game Title',
      platform: 'Platform',
      status: GameStatus.abandoned,
      progress: 0.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainScreenStyles.backgroundColor,
      body: SafeArea(
        child: OrientationBuilder(
          builder:
              (context, orientation) =>
                  _buildResponsiveLayout(context, orientation),
        ),
      ),
    );
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
    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Row(
        children: [
          PlatformFilterDropdown(
            selectedPlatform: _selectedPlatform,
            platforms: _platforms,
            onPlatformChanged:
                (platform) => setState(() => _selectedPlatform = platform),
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
    final isExpanded = _sectionExpanded[title] ?? false;
    final games = _getGamesByStatus(status);

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle: () => _toggleSection(title),
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
    final isExpanded = _sectionExpanded[title] ?? false;
    final games = _getGamesByStatus(status);

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle: () => _toggleSection(title),
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
                (game) => Padding(
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
            (context, index) => LandscapeGameCard(
              game: games[index],
              onTap: () => _showGameDetails(games[index]),
              onPlayPressed:
                  games[index].status == GameStatus.backlog
                      ? () => _handleStartPlaying(games[index])
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
      actionButton: sectionName == 'Backlog' ? _buildAddGameButton() : null,
    );
  }

  Widget _buildAddGameButton() {
    return ElevatedButton(
      onPressed: () {},
      style: MainScreenStyles.addButtonStyle.copyWith(
        padding: WidgetStateProperty.all(
          MainScreenStyles.addButtonSmallPadding,
        ),
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
      ),
      child: const Text('ADD GAME'),
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

  void _toggleSection(String title) {
    setState(() {
      _sectionExpanded[title] = !(_sectionExpanded[title] ?? false);
    });
  }

  void _handleStartPlaying(GameItem game) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Started playing! (Game moved to Playing section)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<GameItem> _getGamesByStatus(GameStatus status) {
    return _sampleGames.where((game) => game.status == status).toList();
  }

  void _showGameDetails(GameItem game) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Show details for ${game.title}')));
  }
}
