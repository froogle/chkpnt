import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/backlog/widgets/backlog_platform_section.dart';
import 'package:chkpnt/screens/collection/widgets/collection_format_controls.dart';
import 'package:chkpnt/screens/collection/widgets/collection_screen_header.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/services/navigation_service.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFormatControls(),
              Expanded(child: _buildContent()),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CollectionScreenHeader(onAddGamePressed: _handleAddGame);
  }

  Widget _buildFormatControls() {
    return const CollectionFormatControls();
  }

  Widget _buildContent() {
    final groupedGames = ref.watch(
      platformSectionsProvider(GameScreen.collection),
    );

    if (groupedGames.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...groupedGames.entries.map(
            (entry) => _buildPlatformSection(entry.key, entry.value),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlatformSection(String platform, List<GameItem> games) {
    return Column(
      children: [
        BacklogPlatformSection(
          platform: platform,
          games: games,
          screen: GameScreen.collection,
          onGameTap: _handleGameTap,
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
              Icons.collections_bookmark_outlined,
              size: 64,
              color: AppColors.primaryAccent,
            ),
            SizedBox(height: 16),
            Text(
              'No games in your collection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add games to start building your collection',
              style: TextStyle(fontSize: 14, color: AppColors.emptyStateText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return MainScreenBottomNav(onNavItemPressed: _handleNavigation);
  }

  void _handleGameTap(GameItem game) {
    GameDetailSheetAnimation.show(
      context,
      game,
      onEditPressed: () => _handleEditGame(game),
    );
  }

  void _handleEditGame(GameItem game) {
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.edit(game: game)));
  }

  void _handleNavigation(int index) {
    NavigationService.handleNavigation(context, index);
  }

  void _handleAddGame() {
    Navigator.of(context).push(
      EditScreenPageRoute(child: GameEditScreen.add(defaultIsPhysical: true)),
    );
  }
}
