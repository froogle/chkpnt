import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';

class ProfileIncomingGamesSection extends ConsumerWidget {
  const ProfileIncomingGamesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderedGames = ref.watch(gamesByStatusProvider(GameStatus.ordered));

    // Sort by oldest status change first (likely to arrive first)
    final sortedOrderedGames = [...orderedGames]
      ..sort((a, b) => a.lastStatusChange.compareTo(b.lastStatusChange));

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // In landscape, limit to first 3 games to prevent overflow
    final displayGames =
        isLandscape && sortedOrderedGames.length > 3
            ? sortedOrderedGames.take(3).toList()
            : sortedOrderedGames;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardElevation,
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppHeadingStyles.gradientHeading(
                    'Incoming Games',
                    fontSize: 16,
                  ),
                ),
                if (isLandscape && sortedOrderedGames.length > 3)
                  Text(
                    '(${displayGames.length} of ${sortedOrderedGames.length})',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryText.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isLandscape ? 12 : 16),
            if (displayGames.isEmpty)
              _buildEmptyState(isLandscape)
            else
              _buildGamesList(displayGames, isLandscape, context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isLandscape) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isLandscape ? 12 : 20),
      child: Column(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: isLandscape ? 36 : 48,
            color: AppColors.emptyStateIcon,
          ),
          SizedBox(height: isLandscape ? 8 : 12),
          Text(
            'No games on the way',
            style: TextStyle(
              fontSize: isLandscape ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.emptyStateText,
            ),
          ),
          SizedBox(height: isLandscape ? 2 : 4),
          Text(
            'Games you mark as "ordered" will appear here',
            style: TextStyle(
              fontSize: isLandscape ? 12 : 14,
              color: AppColors.emptyStateText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
    return Container(
      margin: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleGameTap(game, context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 12 : 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.divider.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: TextStyle(
                          fontSize: isLandscape ? 13 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isLandscape ? 1 : 2),
                      Text(
                        game.platform,
                        style: TextStyle(
                          fontSize: isLandscape ? 11 : 12,
                          color: AppColors.primaryText.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: isLandscape ? 10 : 12,
                  color: AppColors.primaryText.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
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
