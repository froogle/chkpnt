import 'package:flutter/material.dart';
import 'shared/styles.dart';

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
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;
            return isLandscape
                ? _buildLandscapeLayout(context)
                : _buildPortraitLayout(context);
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        _buildCompactHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: MainScreenStyles.contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCollapsibleSection('Playing', GameStatus.playing),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildCollapsibleSection('Backlog', GameStatus.backlog),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildCollapsibleSection('Completed', GameStatus.completed),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildCollapsibleSection('Abandoned', GameStatus.abandoned),
              ],
            ),
          ),
        ),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateGridColumns(screenWidth);

    return Column(
      children: [
        _buildCompactHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: MainScreenStyles.contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLandscapeCollapsibleSection(
                  'Playing',
                  GameStatus.playing,
                  crossAxisCount,
                ),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildLandscapeCollapsibleSection(
                  'Backlog',
                  GameStatus.backlog,
                  crossAxisCount,
                ),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildLandscapeCollapsibleSection(
                  'Completed',
                  GameStatus.completed,
                  crossAxisCount,
                ),
                const SizedBox(height: MainScreenStyles.sectionSpacing),
                _buildLandscapeCollapsibleSection(
                  'Abandoned',
                  GameStatus.abandoned,
                  crossAxisCount,
                ),
              ],
            ),
          ),
        ),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildLandscapeCollapsibleSection(
    String title,
    GameStatus status,
    int crossAxisCount,
  ) {
    final isExpanded = _sectionExpanded[title] ?? false;
    final games = _getGamesByStatus(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: MainScreenStyles.collapsibleSectionDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with background
          Container(
            decoration:
                isExpanded
                    ? MainScreenStyles.collapsibleSectionHeaderDecoration
                    : MainScreenStyles.collapsibleSectionHeaderDecoration
                        .copyWith(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    () => setState(() => _sectionExpanded[title] = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: MainScreenStyles.sectionHeaderStyle),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFF674C3C),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content area
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MainScreenStyles.collapsibleSectionColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child:
                  games.isEmpty
                      ? _buildEmptyGridSection(title)
                      : _buildLandscapeGameGrid(games, crossAxisCount),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLandscapeGameGrid(List<GameItem> games, int crossAxisCount) {
    // Calculate the height needed for the grid
    final rowCount = (games.length / crossAxisCount).ceil();
    final cardHeight = 180.0; // Approximate card height
    final spacing = MainScreenStyles.landscapeGridSpacing;
    final gridHeight = (rowCount * cardHeight) + ((rowCount - 1) * spacing);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Disable grid scrolling since parent scrolls
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: MainScreenStyles.landscapeGridSpacing,
          mainAxisSpacing: MainScreenStyles.landscapeGridSpacing,
          childAspectRatio: MainScreenStyles.landscapeGameCardAspectRatio,
        ),
        itemCount: games.length,
        itemBuilder:
            (context, index) => _buildSimpleLandscapeGameCard(games[index]),
      ),
    );
  }

  Widget _buildSimpleLandscapeGameCard(GameItem game) {
    return Container(
      decoration: MainScreenStyles.landscapeGameCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showGameDetails(game),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Full background image
                Positioned.fill(
                  child: Container(
                    decoration: MainScreenStyles.gameImageDecoration,
                    child: const Icon(
                      Icons.gamepad,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Improved gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0x44000000), // Light overlay in middle
                          Color(0xCC000000), // Strong overlay at bottom
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                // Text content overlay
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Game title
                      Text(
                        game.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black87,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Platform
                      Text(
                        game.platform,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black87,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Status with prominent icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status text with icon
                          Expanded(
                            child: Row(
                              children: [
                                if (game.status == GameStatus.completed)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 16,
                                  ),
                                if (game.status == GameStatus.playing)
                                  const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                if (game.status == GameStatus.abandoned)
                                  const Icon(
                                    Icons.pause_circle_filled,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _getStatusText(game.status),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 6,
                                          color: Colors.black87,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action button for backlog games
                          if (game.status == GameStatus.backlog)
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Started playing! (Game moved to Playing section)',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCC7E54),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x66000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Completed badge in top-right corner
                if (game.status == GameStatus.completed)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyGridSection(String sectionName) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gamepad_outlined, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No games in ${sectionName.toLowerCase()}',
            style: MainScreenStyles.emptyStateTextStyle,
          ),
          if (sectionName == 'Backlog') ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: MainScreenStyles.addButtonStyle.copyWith(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 12),
                ),
              ),
              child: const Text('ADD GAME'),
            ),
          ],
        ],
      ),
    );
  }

  int _calculateGridColumns(double screenWidth) {
    // Responsive grid based on screen width
    if (screenWidth > 1200) return 6; // Large tablets/laptops
    if (screenWidth > 900) return 5; // Medium tablets
    if (screenWidth > 700) return 4; // Small tablets/large phones
    return 3; // Minimum for landscape phones
  }

  Widget _buildCompactHeader() {
    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Row(
        children: [
          _buildFilterButton(),
          const SizedBox(width: 12),
          Expanded(child: _buildCompactSearchBar()),
          const SizedBox(width: 12),
          _buildAddGameIconButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _showFilterDropdown(),
      child: Container(
        height: MainScreenStyles.compactSearchHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFCC7E54),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedPlatform,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterDropdown() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(const Offset(0, 50), ancestor: overlay),
          button.localToGlobal(const Offset(200, 60), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      ),
      color: Colors.white, // Clean white background
      surfaceTintColor: Colors.transparent, // Remove any tinting
      shadowColor: const Color(0x1A000000), // Subtle shadow
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE0D5C7), width: 1),
      ),
      items:
          _platforms.map((String platform) {
            final isSelected = platform == _selectedPlatform;
            return PopupMenuItem<String>(
              value: platform,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFFCC7E54).withValues(alpha: 0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  platform,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected
                            ? const Color(0xFFCC7E54)
                            : const Color(0xFF3B2E29),
                  ),
                ),
              ),
            );
          }).toList(),
    ).then((String? selectedPlatform) {
      if (selectedPlatform != null && selectedPlatform != _selectedPlatform) {
        setState(() {
          _selectedPlatform = selectedPlatform;
        });
      }
    });
  }

  Widget _buildCompactSearchBar() {
    return Container(
      height: MainScreenStyles.compactSearchHeight,
      decoration: MainScreenStyles.compactSearchBarDecoration,
      child: TextField(
        decoration: MainScreenStyles.compactSearchInputDecoration,
      ),
    );
  }

  Widget _buildAddGameIconButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add, color: Colors.white, size: 24),
      tooltip: 'Add New Game',
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF924942),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildCollapsibleSection(String title, GameStatus status) {
    final isExpanded = _sectionExpanded[title] ?? false;
    final games = _getGamesByStatus(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: MainScreenStyles.collapsibleSectionDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with background
          Container(
            decoration:
                isExpanded
                    ? MainScreenStyles.collapsibleSectionHeaderDecoration
                    : MainScreenStyles.collapsibleSectionHeaderDecoration
                        .copyWith(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap:
                    () => setState(() => _sectionExpanded[title] = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: MainScreenStyles.sectionHeaderStyle),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFF674C3C),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content area
          if (isExpanded) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MainScreenStyles.collapsibleSectionColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                children:
                    games
                        .map(
                          (game) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildGameCard(game),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameCard(GameItem game) {
    return Container(
      height: 120, // Fixed height for portrait cards
      decoration: MainScreenStyles.gameCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showGameDetails(game),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Full background image
                Positioned.fill(
                  child: Container(
                    decoration: MainScreenStyles.gameImageDecoration,
                    child: const Icon(
                      Icons.gamepad,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xCC000000), // More opaque black on left
                          Color(0x66000000), // Semi-transparent in middle
                          Colors.transparent, // Transparent on right
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Text content overlay
                Positioned(
                  left: 16,
                  top: 16,
                  bottom: 16,
                  right: 100, // Leave space for action button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section: Title and Platform
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            game.platform,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Bottom section: Status
                      Row(
                        children: [
                          if (game.status == GameStatus.completed)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                              size: 18,
                            ),
                          if (game.status == GameStatus.playing)
                            const Icon(
                              Icons.play_circle_fill,
                              color: Colors.orange,
                              size: 18,
                            ),
                          if (game.status == GameStatus.abandoned)
                            const Icon(
                              Icons.pause_circle_filled,
                              color: Colors.grey,
                              size: 18,
                            ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _getStatusText(game.status),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black87,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action button overlay (right side)
                if (game.status == GameStatus.backlog)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Started playing! (Game moved to Playing section)',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCC7E54),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x44000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (game.status == GameStatus.completed)
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x44000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.playing:
        return 'In Progress';
      case GameStatus.completed:
        return 'Completed';
      case GameStatus.backlog:
        return 'In Backlog';
      case GameStatus.abandoned:
        return 'Abandoned';
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: MainScreenStyles.bottomNavHeight,
      decoration: MainScreenStyles.bottomNavDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_outline, color: Color(0xFFDFB268)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.grid_view_outlined,
              color: Color(0xFFDFB268),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline, color: Color(0xFFDFB268)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.circle_outlined, color: Color(0xFFDFB268)),
          ),
        ],
      ),
    );
  }

  List<GameItem> _getGamesByStatus(GameStatus status) {
    return _sampleGames.where((game) => game.status == status).toList();
  }

  void _showGameDetails(GameItem game) {
    // TODO: Implement game details modal
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Show details for ${game.title}')));
  }
}

enum GameStatus { playing, completed, backlog, abandoned }

class GameItem {
  final String title;
  final String platform;
  final GameStatus status;
  final double progress;

  const GameItem({
    required this.title,
    required this.platform,
    required this.status,
    required this.progress,
  });
}
