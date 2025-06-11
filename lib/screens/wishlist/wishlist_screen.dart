import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import '../main/widgets/main_screen_header.dart';
import '../main/widgets/main_screen_bottom_nav.dart';
import '../main/widgets/game_section.dart';
import '../main/widgets/animations/game_transition_animation.dart';
import '../main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/utils/ui_utils.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  GameItem? _animatingGame;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _setupProviderListeners();
    // Update section expansion based on content when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateWishlistSectionExpansion();
    });
  }

  void _setupProviderListeners() {
    // Listen for platform filter changes and update section expansion
    ref.listenManual(selectedPlatformProvider, (previous, current) {
      _updateWishlistSectionExpansion();
    });

    // Listen for search query changes and update section expansion
    ref.listenManual(searchQueryProvider, (previous, current) {
      _updateWishlistSectionExpansion();
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
    final wishlistPlatforms = ref.watch(wishlistPlatformsProvider);
    return MainScreenHeader(
      onAddGamePressed: _handleAddGame,
      customPlatforms: wishlistPlatforms,
    );
  }

  Widget _buildContent(bool isLandscape) {
    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameSection('Ordered', GameStatus.ordered, isLandscape),
          const SizedBox(height: 20),
          _buildGameSection('Wish List', GameStatus.wishlist, isLandscape),
          const SizedBox(height: 24), // Bottom padding
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

  void _updateWishlistSectionExpansion() {
    final selectedPlatform = ref.read(selectedPlatformProvider);
    final searchQuery = ref.read(searchQueryProvider);

    // Get filtered games for wishlist sections
    final orderedGames = ref.read(
      fullyFilteredGamesProvider(
        GameStatus.ordered,
        selectedPlatform,
        searchQuery,
      ),
    );
    final wishlistGames = ref.read(
      fullyFilteredGamesProvider(
        GameStatus.wishlist,
        selectedPlatform,
        searchQuery,
      ),
    );

    // Update section expansion based on content
    // Only update wishlist sections - don't pass main screen sections to avoid overriding them
    ref
        .read(sectionExpansionProvider.notifier)
        .updateExpansionBasedOnResults(
          orderedGames: orderedGames,
          wishlistGames: wishlistGames,
        );
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
      case 0: // Home
        Navigator.of(context).pushReplacementNamed('/main');
        break;
      case 1: // Backlog
        // TODO: Navigate to backlog screen when implemented
        break;
      case 2: // Wish List - current screen, do nothing
        break;
      case 3: // Profile
        // TODO: Navigate to profile screen when implemented
        break;
    }
  }
}
