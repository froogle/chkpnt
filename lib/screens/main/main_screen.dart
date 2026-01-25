import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_header.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/screens/main/widgets/game_section.dart';
import 'package:chkpnt/screens/main/widgets/welcome_empty_state.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_transition_animation.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/services/navigation_service.dart';
import 'package:chkpnt/services/paywall_service.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return MainScreenHeader(onAddGamePressed: _handleAddGame);
  }

  Widget _buildContent() {
    final games = ref.watch(gameListProvider);

    if (games.isEmpty) {
      return WelcomeEmptyState(onAddGamePressed: _handleAddGame);
    }

    return SingleChildScrollView(
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGameSection('Playing', GameStatus.playing),
          const SizedBox(height: 20),
          _buildGameSection('Ongoing/Frequently Played', GameStatus.ongoing),
          const SizedBox(height: 20),
          _buildGameSection('Backlog', GameStatus.backlog),
          const SizedBox(height: 20),
          _buildGameSection('Completed', GameStatus.completed),
          const SizedBox(height: 20),
          _buildGameSection('Abandoned', GameStatus.abandoned),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGameSection(String title, GameStatus status) {
    return GameSection(
      title: title,
      status: status,
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

  Future<void> _handleAddGame() async {
    final paywallService = ref.read(paywallServiceProvider);
    final canProceed = await paywallService.checkAndShowPaywall(context);
    if (!canProceed || !mounted) return;

    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.add()));
  }

  void _handleNavigation(int index) {
    NavigationService.handleNavigation(context, index);
  }
}
