import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import '../main/widgets/main_screen_header.dart';
import '../main/widgets/main_screen_bottom_nav.dart';
import '../main/widgets/animations/game_transition_animation.dart';
import '../main/widgets/animations/game_detail_sheet_animation.dart';
import 'widgets/backlog_sorting_controls.dart';
import 'widgets/backlog_platform_section.dart';
import 'package:chkpnt/shared/widgets/layout/universal_scroll_handler.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/utils/ui_utils.dart';

class BacklogScreen extends ConsumerStatefulWidget {
  const BacklogScreen({super.key});

  @override
  ConsumerState<BacklogScreen> createState() => _BacklogScreenState();
}

class _BacklogScreenState extends ConsumerState<BacklogScreen> {
  GameItem? _animatingGame;
  bool _isAnimating = false;
  late ScrollController _scrollController;
  late Map<String, GlobalKey> _platformKeys;

  @override
  void initState() {
    super.initState();
    _setupScrollingComponents();
    _setupProviderListeners();
    // Set current screen for nav indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentScreenProvider.notifier).setScreen(1);
    });
  }

  void _setupScrollingComponents() {
    _scrollController = ScrollController();
    _platformKeys = <String, GlobalKey>{};

    // Initialize platform keys immediately with current platforms
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPlatforms = ref.read(backlogPlatformsProvider);
      _updatePlatformKeys(currentPlatforms);
    });
  }

  void _setupProviderListeners() {
    // Listen for backlog platform changes and update platform keys proactively
    ref.listenManual(backlogPlatformsProvider, (previous, current) {
      _updatePlatformKeys(current);
    });
  }

  void _updatePlatformKeys(Iterable<String> platforms) {
    // Add keys for new platforms, keep existing ones
    for (final platform in platforms) {
      if (!_platformKeys.containsKey(platform)) {
        _platformKeys[platform] = GlobalKey();
      }
    }

    // Remove keys for platforms that no longer exist
    final currentPlatforms = platforms.toSet();
    final keysToRemove =
        _platformKeys.keys
            .where((platform) => !currentPlatforms.contains(platform))
            .toList();
    for (final keyToRemove in keysToRemove) {
      _platformKeys.remove(keyToRemove);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UniversalScrollHandler(
      scrollController: _scrollController,
      sectionKeys: _platformKeys,
      child: Stack(
        children: [
          _buildMainScaffold(),
          if (_isAnimating && _animatingGame != null) _buildAnimationOverlay(),
        ],
      ),
    );
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
        child: SafeArea(
          child: OrientationBuilder(
            builder:
                (context, orientation) => _buildResponsiveLayout(orientation),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(Orientation orientation) {
    final isLandscape = orientation == Orientation.landscape;

    return Column(
      children: [
        _buildHeader(),
        _buildSortingControls(),
        Expanded(child: _buildContent(isLandscape)),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildHeader() {
    final backlogPlatforms = ref.watch(backlogPlatformsProvider);
    return MainScreenHeader(
      onAddGamePressed: _handleAddGame,
      customPlatforms: backlogPlatforms,
    );
  }

  Widget _buildSortingControls() {
    return const BacklogSortingControls();
  }

  Widget _buildContent(bool isLandscape) {
    final groupedGames = ref.watch(sortedBacklogGamesByPlatformProvider);

    if (groupedGames.isEmpty) {
      return _buildEmptyState();
    }

    // Update platform keys based on current platforms
    _updatePlatformKeys(groupedGames.keys);

    return SingleChildScrollView(
      controller: _scrollController,
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...groupedGames.entries.map(
            (entry) =>
                _buildPlatformSection(entry.key, entry.value, isLandscape),
          ),
          const SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildPlatformSection(
    String platform,
    List<GameItem> games,
    bool isLandscape,
  ) {
    return Column(
      children: [
        Container(
          key: _platformKeys[platform],
          child: BacklogPlatformSection(
            platform: platform,
            games: games,
            isLandscape: isLandscape,
            crossAxisCount:
                isLandscape ? UIUtils.calculateGridColumns(context) : null,
            animatingGame: _animatingGame,
            isAnimating: _isAnimating,
            onGameTap: _handleGameTap,
            onPlayPressed: _handleStartPlaying,
          ),
        ),
        SizedBox(height: BacklogStyles.platformSectionSpacing),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gamepad_outlined,
              size: 64,
              color: AppColors.primaryAccent,
            ),
            SizedBox(height: 16),
            Text(
              'No games in backlog',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add some games to get started!',
              style: TextStyle(fontSize: 14, color: AppColors.emptyStateText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return MainScreenBottomNav(onNavItemPressed: _handleNavigation);
  }

  Widget _buildAnimationOverlay() {
    return GameTransitionAnimation(
      game: _animatingGame!,
      onComplete: _handleAnimationComplete,
    );
  }

  // Business logic methods

  Future<void> _handleStartPlaying(GameItem game) async {
    if (_isAnimating) return;

    setState(() {
      _animatingGame = game;
      _isAnimating = true;
    });

    final gameActionsService = ref.read(gameActionsServiceProvider);
    await gameActionsService.startPlayingGame(game, context);
  }

  void _handleAnimationComplete() {
    setState(() {
      _animatingGame = null;
      _isAnimating = false;
    });
  }

  void _handleGameTap(GameItem game) {
    GameDetailSheetAnimation.show(
      context,
      game,
      onEditPressed: () => _handleEditGame(game),
    );
  }

  void _handleEditGame(GameItem game) {
    Navigator.of(context).pop(); // Close the detail sheet first
    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.edit(game: game)));
  }

  void _handleAddGame() async {
    final result = await Navigator.of(context).push<GameItem?>(
      EditScreenPageRoute(
        child: GameEditScreen.add(
          availableStatuses: [GameStatus.backlog],
          defaultStatus: GameStatus.backlog,
        ),
      ),
    );

    // If a game was added, handle the scroll
    if (result != null) {
      await _handleGameAddedWithScroll(result);
    }
  }

  /// Handle game added with custom scroll logic for backlog screen
  Future<void> _handleGameAddedWithScroll(GameItem newGame) async {
    // Force update platform keys immediately with current state
    final currentPlatforms = ref.read(backlogPlatformsProvider);
    _updatePlatformKeys(currentPlatforms);

    // Ensure the new platform key is created
    if (!_platformKeys.containsKey(newGame.platform)) {
      _platformKeys[newGame.platform] = GlobalKey();
    }

    // Wait a frame to ensure UI has been built
    await Future.delayed(const Duration(milliseconds: 50));

    // Now request the scroll
    ref
        .read(scrollToSectionProvider.notifier)
        .requestScrollTo(newGame.platform);
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/main', (route) => false);
        break;
      case 1: // Backlog - current screen, do nothing
        break;
      case 2: // Wish List
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/wishlist', (route) => false);
        break;
      case 3: // Profile
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }
}
