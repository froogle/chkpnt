import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../styles/styles.dart';
import 'widgets/main_screen_header.dart';
import 'widgets/main_screen_bottom_nav.dart';
import 'widgets/game_section.dart';
import 'widgets/animations/game_transition_animation.dart';
import 'widgets/animations/game_detail_sheet_animation.dart';
import '../../models/game_models.dart';
import '../../providers/ui_state_provider.dart';
import '../../services/game_actions_service.dart';
import '../../utils/ui_utils.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  GameItem? _animatingGame;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _setupProviderListeners();
  }

  void _setupProviderListeners() {
    // Listen for platform filter changes and update section expansion
    ref.listenManual(selectedPlatformProvider, (previous, current) {
      _updateSectionExpansionForFilters();
    });

    // Listen for search query changes and update section expansion
    ref.listenManual(searchQueryProvider, (previous, current) {
      _updateSectionExpansionForFilters();
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
        Expanded(child: _buildContent(isLandscape)),
        _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildHeader() {
    return MainScreenHeader(onAddGamePressed: _handleAddGame);
  }

  Widget _buildContent(bool isLandscape) {
    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameSection('Playing', GameStatus.playing, isLandscape),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildGameSection('Backlog', GameStatus.backlog, isLandscape),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildGameSection('Completed', GameStatus.completed, isLandscape),
          const SizedBox(height: MainScreenStyles.sectionSpacing),
          _buildGameSection('Abandoned', GameStatus.abandoned, isLandscape),
        ],
      ),
    );
  }

  Widget _buildGameSection(String title, GameStatus status, bool isLandscape) {
    return GameSection(
      title: title,
      status: status,
      isLandscape: isLandscape,
      crossAxisCount:
          isLandscape ? UIUtils.calculateGridColumns(context) : null,
      animatingGame: _animatingGame,
      isAnimating: _isAnimating,
      onGameTap: _handleGameTap,
      onPlayPressed: _handleStartPlaying,
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

  void _updateSectionExpansionForFilters() {
    final gameActionsService = ref.read(gameActionsServiceProvider);
    gameActionsService.updateSectionExpansionForFilters();
  }

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
    // Handle game editing
    // This will be implemented when you add game editing functionality
    Navigator.of(context).pop(); // Close the detail sheet for now
  }

  void _handleAddGame() {
    // Handle adding new games
    // This will be implemented when you add game creation functionality
  }

  void _handleNavigation(int index) {
    // Handle bottom navigation
    // This will be implemented when you add additional screens
  }
}
