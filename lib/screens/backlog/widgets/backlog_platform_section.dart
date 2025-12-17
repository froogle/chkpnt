import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/shared/widgets/cards/game_card.dart';
import 'package:chkpnt/styles/backlog_styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/utils/ui_utils.dart';

class BacklogPlatformSection extends ConsumerWidget {
  final String platform;
  final List<GameItem> games;
  final GameItem? animatingGame;
  final bool isAnimating;
  final Function(GameItem) onGameTap;
  final Function(GameItem)? onPlayPressed;

  const BacklogPlatformSection({
    super.key,
    required this.platform,
    required this.games,
    required this.onGameTap,
    this.animatingGame,
    this.isAnimating = false,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (games.isEmpty) {
      return const SizedBox.shrink();
    }

    final sectionExpansion = ref.watch(sectionExpansionProvider);
    final isExpanded = sectionExpansion[platform] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlimSectionHeader(
          title: platform,
          isExpanded: isExpanded,
          onToggle:
              () => ref
                  .read(sectionExpansionProvider.notifier)
                  .toggleSection(platform),
          isEmpty: false,
          gameCount: games.length,
        ),
        if (isExpanded) ...[
          SizedBox(height: BacklogStyles.platformSectionHeaderSpacing),
          _buildGrid(games),
        ],
      ],
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
    if (isAnimating && animatingGame?.id == game.id) {
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

    return GameCard(
      game: game,
      onTap: () => onGameTap(game),
      onPlayPressed: () => onPlayPressed?.call(game),
    );
  }
}
