import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/shared/widgets/layout/empty_state_widget.dart';
import 'package:chkpnt/shared/widgets/cards/game_card.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/utils/ui_utils.dart';

class GameSection extends ConsumerWidget {
  final String title;
  final GameStatus status;
  final GameItem? animatingGame;
  final bool isAnimating;
  final Function(GameItem) onGameTap;
  final Function(GameItem)? onPlayPressed;

  const GameSection({
    super.key,
    required this.title,
    required this.status,
    required this.onGameTap,
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

    final filtersActive = selectedPlatform != 'All' || searchQuery.isNotEmpty;
    final isExpanded = filtersActive
        ? games.isNotEmpty
        : (sectionExpansion[title] ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlimSectionHeader(
          title: title,
          isExpanded: isExpanded,
          onToggle:
              () => ref
                  .read(sectionExpansionProvider.notifier)
                  .toggleSection(title),
          isEmpty: games.isEmpty,
          gameCount: games.length,
        ),
        if (isExpanded) _buildContent(games),
      ],
    );
  }

  Widget _buildContent(List<GameItem> games) {
    if (games.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _buildGrid(games),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: EmptyStateWidget(
        icon: Icons.gamepad_outlined,
        message: 'No games in ${title.toLowerCase()}',
        actionButton: null,
      ),
    );
  }

  Widget _buildGrid(List<GameItem> games) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: UIUtils.getResponsiveGridDelegate(),
      itemCount: games.length,
      itemBuilder: (context, index) => _buildAnimatedGameTile(games[index]),
    );
  }

  Widget _buildAnimatedGameTile(GameItem game) {
    if (status == GameStatus.backlog &&
        isAnimating &&
        animatingGame?.id == game.id) {
      return AnimatedOpacity(
        opacity: 0.0,
        duration: const Duration(milliseconds: 200),
        child: GameCard(
          game: game,
          onTap: () => onGameTap(game),
          onPlayPressed: () => onPlayPressed?.call(game),
        ),
      );
    }

    if (status == GameStatus.playing &&
        isAnimating &&
        animatingGame?.id == game.id) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity,
            child: GameCard(
              game: game,
              onTap: () => onGameTap(game),
              onPlayPressed: null,
            ),
          );
        },
      );
    }

    return GameCard(
      game: game,
      onTap: () => onGameTap(game),
      onPlayPressed:
          game.status == GameStatus.backlog
              ? () => onPlayPressed?.call(game)
              : null,
    );
  }
}
