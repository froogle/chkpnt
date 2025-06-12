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
    final orderedGames = ref.watch(gamesByStatusProvider(GameStatus.ordered));
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Sort by oldest status change first (likely to arrive first)
    final sortedOrderedGames = [...orderedGames]
      ..sort((a, b) => a.lastStatusChange.compareTo(b.lastStatusChange));

    // In landscape, limit to first 3 games to prevent overflow
    final displayGames =
        isLandscape && sortedOrderedGames.length > 3
            ? sortedOrderedGames.take(3).toList()
            : sortedOrderedGames;

    return Container(
      width: double.infinity,
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: const EdgeInsets.all(ProfileStyles.sectionPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              isLandscape,
              sortedOrderedGames.length,
              displayGames.length,
            ),
            SizedBox(height: isLandscape ? 12 : 16),
            _buildContent(displayGames, isLandscape, context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLandscape, int totalGames, int displayedGames) {
    return Row(
      children: [
        Expanded(
          child: AppHeadingStyles.gradientHeading(
            'Incoming Games',
            fontSize: 16,
          ),
        ),
        if (isLandscape && totalGames > 3)
          Text(
            '($displayedGames of $totalGames)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primaryText.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(
    List<GameItem> displayGames,
    bool isLandscape,
    BuildContext context,
  ) {
    if (displayGames.isEmpty) {
      return ProfileEmptyState(
        icon: Icons.local_shipping_outlined,
        title: 'No games on the way',
        subtitle: 'Games you mark as "ordered" will appear here',
        isLandscape: isLandscape,
      );
    }

    return Column(
      children:
          displayGames
              .map(
                (game) => _GameListItem(
                  game: game,
                  isLandscape: isLandscape,
                  onTap: () => _handleGameTap(game, context),
                ),
              )
              .toList(),
    );
  }

  void _handleGameTap(GameItem game, BuildContext context) {
    GameDetailSheetAnimation.show(
      context,
      game,
      onEditPressed: () => _handleEditGame(game, context),
    );
  }

  void _handleEditGame(GameItem game, BuildContext context) {
    Navigator.of(context).pop(); // Close the detail sheet first
    Navigator.of(
      context,
    ).push(EditScreenPageRoute(child: GameEditScreen.edit(game: game)));
  }
}

/// Extracted game list item widget to reduce nesting
class _GameListItem extends StatelessWidget {
  const _GameListItem({
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
      margin: EdgeInsets.only(
        bottom: ProfileStyles.getGameItemSpacing(isLandscape),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ProfileStyles.gameItemBorderRadius,
          ),
          child: Container(
            padding: EdgeInsets.all(
              ProfileStyles.getGameItemPadding(isLandscape),
            ),
            decoration: ProfileStyles.gameItemDecoration,
            child: Row(
              children: [
                _buildStatusIndicator(),
                const SizedBox(width: 12),
                Expanded(child: _buildGameInfo()),
                _buildArrowIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: ProfileStyles.gameStatusIndicatorSize,
      height: ProfileStyles.gameStatusIndicatorSize,
      decoration: ProfileStyles.gameStatusIndicatorDecoration,
    );
  }

  Widget _buildGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          game.title,
          style: ProfileStyles.gameItemTitleStyle(isLandscape),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isLandscape ? 1 : 2),
        Text(
          game.platform,
          style: ProfileStyles.gameItemPlatformStyle(isLandscape),
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Icon(
      Icons.arrow_forward_ios,
      size: isLandscape ? 10 : 12,
      color: AppColors.primaryText.withOpacity(0.3),
    );
  }
}
