import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'widgets/main_screen_header.dart';
import 'widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/shared/widgets/layout/universal_scroll_handler.dart';
import 'widgets/game_section.dart';
import 'widgets/animations/game_transition_animation.dart';
import 'widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/utils/ui_utils.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  GameItem? _animatingGame;
  bool _isAnimating = false;
  late ScrollController _scrollController;
  late Map<String, GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _setupScrollingComponents();
    _setupProviderListeners();
    // Set current screen for nav indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentScreenProvider.notifier).setScreen(0);
    });
  }

  void _setupScrollingComponents() {
    _scrollController = ScrollController();
    _sectionKeys = {
      'Playing': GlobalKey(),
      'Backlog': GlobalKey(),
      'Completed': GlobalKey(),
      'Abandoned': GlobalKey(),
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    return UniversalScrollHandler(
      scrollController: _scrollController,
      sectionKeys: _sectionKeys,
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
      controller: _scrollController,
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameSection('Playing', GameStatus.playing, isLandscape),
          const SizedBox(height: 20),
          _buildGameSection('Backlog', GameStatus.backlog, isLandscape),
          const SizedBox(height: 20),
          _buildGameSection('Completed', GameStatus.completed, isLandscape),
          const SizedBox(height: 20),
          _buildGameSection('Abandoned', GameStatus.abandoned, isLandscape),
          const SizedBox(height: 24), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildGameSection(String title, GameStatus status, bool isLandscape) {
    return Container(
      key: _sectionKeys[title],
      child: GameSection(
        title: title,
        status: status,
        isLandscape: isLandscape,
        crossAxisCount:
            isLandscape ? UIUtils.calculateGridColumns(context) : null,
        animatingGame: _animatingGame,
        isAnimating: _isAnimating,
        onGameTap: _handleGameTap,
        onPlayPressed: _handleStartPlaying,
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
      case 0: // Home - current screen, do nothing
        break;
      case 1: // Backlog
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/backlog', (route) => false);
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
