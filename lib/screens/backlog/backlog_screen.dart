import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import '../main/widgets/main_screen_header.dart';
import '../main/widgets/main_screen_bottom_nav.dart';
import '../main/widgets/animations/game_transition_animation.dart';
import '../main/widgets/animations/game_detail_sheet_animation.dart';
import 'widgets/backlog_sorting_controls.dart';
import 'widgets/backlog_platform_section.dart';
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

  @override
  void initState() {
    super.initState();
    // Set current screen for nav indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentScreenProvider.notifier).setScreen(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainScaffold(),
        if (_isAnimating && _animatingGame != null) _buildAnimationOverlay(),
      ],
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

    return SingleChildScrollView(
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
        BacklogPlatformSection(
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
        const SizedBox(height: 20),
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

  void _handleAddGame() {
    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.add()));
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
        // TODO: Navigate to profile screen when implemented
        break;
    }
  }
}
