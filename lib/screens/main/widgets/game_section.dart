import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/layout/collapsible_section.dart';
import 'package:chkpnt/shared/widgets/layout/empty_state_widget.dart';
import 'package:chkpnt/shared/widgets/cards/portrait_game_card.dart';
import 'package:chkpnt/shared/widgets/cards/landscape_game_card.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/main_screen_styles.dart';

class GameSection extends ConsumerWidget {
  final String title;
  final GameStatus status;
  final bool isLandscape;
  final int? crossAxisCount;
  final GameItem? animatingGame;
  final bool isAnimating;
  final Function(GameItem) onGameTap;
  final Function(GameItem)? onPlayPressed;

  const GameSection({
    super.key,
    required this.title,
    required this.status,
    required this.isLandscape,
    required this.onGameTap,
    this.crossAxisCount,
    this.animatingGame,
    this.isAnimating = false,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionExpansion = ref.watch(sectionExpansionProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final games = ref.watch(
      fullyFilteredGamesProvider(status, selectedPlatform, searchQuery),
    );
    final isExpanded = sectionExpansion[title] ?? false;

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle:
          () =>
              ref.read(sectionExpansionProvider.notifier).toggleSection(title),
      isEmpty: games.isEmpty,
      emptyStateWidget: games.isEmpty ? _buildEmptyState() : null,
      content:
          isLandscape
              ? _buildLandscapeContent(games)
              : _buildPortraitContent(games),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.gamepad_outlined,
      message: 'No games in ${title.toLowerCase()}',
      actionButton: null,
    );
  }

  Widget _buildPortraitContent(List<GameItem> games) {
    return Column(
      children:
          games
              .map(
                (game) => _buildAnimatedGameCard(
                  child: Padding(
                    padding: MainScreenStyles.gameCardMargin,
                    child: PortraitGameCard(
                      game: game,
                      onTap: () => onGameTap(game),
                      onPlayPressed:
                          game.status == GameStatus.backlog
                              ? () => onPlayPressed?.call(game)
                              : null,
                    ),
                  ),
                  game: game,
                ),
              )
              .toList(),
    );
  }

  Widget _buildLandscapeContent(List<GameItem> games) {
    if (crossAxisCount == null) {
      throw ArgumentError('crossAxisCount is required for landscape layout');
    }

    final gridHeight = _calculateGridHeight(games.length, crossAxisCount!);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _buildGridDelegate(crossAxisCount!),
        itemCount: games.length,
        itemBuilder:
            (context, index) => _buildAnimatedGameCard(
              child: LandscapeGameCard(
                game: games[index],
                onTap: () => onGameTap(games[index]),
                onPlayPressed:
                    games[index].status == GameStatus.backlog
                        ? () => onPlayPressed?.call(games[index])
                        : null,
              ),
              game: games[index],
            ),
      ),
    );
  }

  Widget _buildAnimatedGameCard({
    required Widget child,
    required GameItem game,
  }) {
    return AnimatedOpacity(
      opacity: isAnimating && animatingGame?.id == game.id ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _buildGridDelegate(
    int crossAxisCount,
  ) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: MainScreenStyles.landscapeGridSpacing,
      mainAxisSpacing: MainScreenStyles.landscapeGridSpacing,
      childAspectRatio: MainScreenStyles.landscapeGameCardAspectRatio,
    );
  }

  double _calculateGridHeight(int itemCount, int crossAxisCount) {
    const cardHeight = 180.0;
    final rowCount = (itemCount / crossAxisCount).ceil();
    final spacing = MainScreenStyles.landscapeGridSpacing;
    return (rowCount * cardHeight) + ((rowCount - 1) * spacing);
  }
}
