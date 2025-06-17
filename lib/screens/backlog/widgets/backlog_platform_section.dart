import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/shared/widgets/cards/game_card.dart';
import 'package:chkpnt/styles/backlog_styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class GridLayoutConfiguration {
  final int columns;
  final double aspectRatio;
  final double spacing;

  const GridLayoutConfiguration({
    required this.columns,
    required this.aspectRatio,
    required this.spacing,
  });
}

class BacklogPlatformSection extends ConsumerWidget {
  final String platform;
  final List<GameItem> games;
  final bool isLandscape;
  final int? crossAxisCount;
  final GameItem? animatingGame;
  final bool isAnimating;
  final Function(GameItem) onGameTap;
  final Function(GameItem)? onPlayPressed;

  const BacklogPlatformSection({
    super.key,
    required this.platform,
    required this.games,
    required this.isLandscape,
    required this.onGameTap,
    this.crossAxisCount,
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
    final isExpanded =
        sectionExpansion[platform] ?? true; // Default to expanded for platforms

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
    final layoutConfig = _getLayoutConfiguration();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutConfig.columns,
        crossAxisSpacing: layoutConfig.spacing,
        mainAxisSpacing: layoutConfig.spacing,
        childAspectRatio: layoutConfig.aspectRatio,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) => _buildAnimatedGameTile(games[index]),
    );
  }

  GridLayoutConfiguration _getLayoutConfiguration() {
    if (isLandscape) {
      final columns = crossAxisCount ?? 5;
      return GridLayoutConfiguration(
        columns: columns,
        aspectRatio: 1.0, // Square aspect ratio
        spacing: 8, // Tighter spacing in landscape to fit more games
      );
    } else {
      return GridLayoutConfiguration(
        columns: 3,
        aspectRatio: 1.0, // Square aspect ratio
        spacing: 12,
      );
    }
  }

  Widget _buildAnimatedGameTile(GameItem game) {
    // Handle fade-out for games leaving backlog
    if (isAnimating && animatingGame?.id == game.id) {
      return AnimatedOpacity(
        opacity: 0.0,
        duration: const Duration(milliseconds: 200),
        child: GameCard(
          game: game,
          layout: GameCardLayout.compact,
          size: GameCardSize.small,
          onTap: () => onGameTap(game),
          onPlayPressed: () => onPlayPressed?.call(game),
        ),
      );
    }

    // Default state - fully visible
    return GameCard(
      game: game,
      layout: GameCardLayout.compact,
      size: GameCardSize.small,
      onTap: () => onGameTap(game),
      onPlayPressed: () => onPlayPressed?.call(game),
    );
  }
}
