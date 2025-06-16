import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'shared/profile_empty_state.dart';

class ProfileIncomingGamesSection extends ConsumerWidget {
  const ProfileIncomingGamesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: const EdgeInsets.all(ProfileStyles.sectionPadding),
        child: _buildSectionContent(context, ref),
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, WidgetRef ref) {
    final orderedGames = ref.watch(gamesByStatusProvider(GameStatus.ordered));
    final isLandscape = _isLandscapeOrientation(context);
    final sortedGames = _getSortedGames(orderedGames);
    final displayGames = _getDisplayGames(sortedGames, isLandscape);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          isLandscape,
          sortedGames.length,
          displayGames.length,
        ),
        SizedBox(height: _getHeaderSpacing(isLandscape)),
        _buildGamesContent(displayGames, isLandscape, context),
      ],
    );
  }

  Widget _buildSectionHeader(
    bool isLandscape,
    int totalGames,
    int displayedGames,
  ) {
    return _ProfileIncomingGamesHeader(
      isLandscape: isLandscape,
      totalGames: totalGames,
      displayedGames: displayedGames,
    );
  }

  Widget _buildGamesContent(
    List<GameItem> displayGames,
    bool isLandscape,
    BuildContext context,
  ) {
    if (_isEmptyState(displayGames)) {
      return _buildEmptyState(isLandscape);
    }

    return _buildGamesList(displayGames, isLandscape, context);
  }

  Widget _buildEmptyState(bool isLandscape) {
    return ProfileEmptyState(
      icon: Icons.local_shipping_outlined,
      title: 'No games on the way',
      subtitle: 'Games you mark as "ordered" will appear here',
      isLandscape: isLandscape,
    );
  }

  Widget _buildGamesList(
    List<GameItem> games,
    bool isLandscape,
    BuildContext context,
  ) {
    return Column(
      children:
          games
              .map((game) => _buildGameListItem(game, isLandscape, context))
              .toList(),
    );
  }

  Widget _buildGameListItem(
    GameItem game,
    bool isLandscape,
    BuildContext context,
  ) {
    return _ProfileIncomingGameItem(
      game: game,
      isLandscape: isLandscape,
      onTap: () => _handleGameItemTap(game, context),
    );
  }

  // Business Logic Methods
  bool _isLandscapeOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  List<GameItem> _getSortedGames(List<GameItem> games) {
    return [...games]
      ..sort((a, b) => a.lastStatusChange.compareTo(b.lastStatusChange));
  }

  List<GameItem> _getDisplayGames(
    List<GameItem> sortedGames,
    bool isLandscape,
  ) {
    const maxLandscapeGames = 3;
    return isLandscape && sortedGames.length > maxLandscapeGames
        ? sortedGames.take(maxLandscapeGames).toList()
        : sortedGames;
  }

  double _getHeaderSpacing(bool isLandscape) {
    return isLandscape ? 12.0 : 16.0;
  }

  bool _isEmptyState(List<GameItem> games) {
    return games.isEmpty;
  }

  void _handleGameItemTap(GameItem game, BuildContext context) {
    GameDetailSheetAnimation.show(
      context,
      game,
      onEditPressed: () => _navigateToEditGame(game, context),
    );
  }

  void _navigateToEditGame(GameItem game, BuildContext context) {
    Navigator.of(context).pop(); // Close the detail sheet first
    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.edit(game: game)));
  }
}

/// Header widget for the incoming games section
class _ProfileIncomingGamesHeader extends StatelessWidget {
  const _ProfileIncomingGamesHeader({
    required this.isLandscape,
    required this.totalGames,
    required this.displayedGames,
  });

  final bool isLandscape;
  final int totalGames;
  final int displayedGames;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTitle()),
        if (_shouldShowGameCounter()) _buildGameCounter(),
      ],
    );
  }

  Widget _buildTitle() {
    return AppHeadingStyles.gradientHeading('Incoming Games', fontSize: 16);
  }

  Widget _buildGameCounter() {
    return Text(
      '($displayedGames of $totalGames)',
      style: TextStyle(
        fontSize: 12,
        color: AppColors.primaryText.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  bool _shouldShowGameCounter() {
    return isLandscape && totalGames > 3;
  }
}

/// Individual game item widget for the incoming games list
class _ProfileIncomingGameItem extends StatelessWidget {
  const _ProfileIncomingGameItem({
    required this.game,
    required this.isLandscape,
    required this.onTap,
  });

  final GameItem game;
  final bool isLandscape;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _getItemSpacing()),
      child: _buildTappableContainer(),
    );
  }

  Widget _buildTappableContainer() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProfileStyles.gameItemBorderRadius),
        child: _buildItemContainer(),
      ),
    );
  }

  Widget _buildItemContainer() {
    return Container(
      padding: EdgeInsets.all(_getItemPadding()),
      decoration: ProfileStyles.gameItemDecoration,
      child: _buildItemContent(),
    );
  }

  Widget _buildItemContent() {
    return Row(
      children: [
        _buildStatusIndicator(),
        const SizedBox(width: 12),
        Expanded(child: _buildGameInformation()),
        _buildNavigationArrow(),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: ProfileStyles.gameStatusIndicatorSize,
      height: ProfileStyles.gameStatusIndicatorSize,
      decoration: ProfileStyles.gameStatusIndicatorDecoration,
    );
  }

  Widget _buildGameInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGameTitle(),
        SizedBox(height: _getTitlePlatformSpacing()),
        _buildGamePlatform(),
      ],
    );
  }

  Widget _buildGameTitle() {
    return Text(
      game.title,
      style: ProfileStyles.gameItemTitleStyle(isLandscape),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildGamePlatform() {
    return Text(
      game.platform,
      style: ProfileStyles.gameItemPlatformStyle(isLandscape),
    );
  }

  Widget _buildNavigationArrow() {
    return Icon(
      Icons.arrow_forward_ios,
      size: _getArrowSize(),
      color: AppColors.primaryText.withValues(alpha: 0.3),
    );
  }

  // Style Helper Methods
  double _getItemSpacing() {
    return ProfileStyles.getGameItemSpacing(isLandscape);
  }

  double _getItemPadding() {
    return ProfileStyles.getGameItemPadding(isLandscape);
  }

  double _getTitlePlatformSpacing() {
    return isLandscape ? 1.0 : 2.0;
  }

  double _getArrowSize() {
    return isLandscape ? 10.0 : 12.0;
  }
}
