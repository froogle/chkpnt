import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/screens/main/widgets/animations/game_detail_sheet_animation.dart';
import 'package:chkpnt/screens/backlog/widgets/backlog_platform_section.dart';
import 'package:chkpnt/screens/collection/widgets/collection_screen_header.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/screens/edit/widgets/edit_screen_page_route.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/services/navigation_service.dart';
import 'package:chkpnt/services/paywall_service.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  static const String _physicalGroup = 'Physical';
  static const String _digitalGroup = 'Digital';

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

  Widget _buildContent() {
    final groupedGames = ref.watch(collectionGamesByPlatformProvider);

    if (groupedGames.isEmpty) {
      return _buildEmptyState();
    }

    final physicalSections = _sectionsForFormat(groupedGames, true);
    final digitalSections = _sectionsForFormat(groupedGames, false);

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: MainScreenStyles.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormatGroup(_physicalGroup, physicalSections),
          _buildFormatGroup(_digitalGroup, digitalSections),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Map<String, List<GameItem>> _sectionsForFormat(
    Map<String, List<GameItem>> groupedGames,
    bool isPhysical,
  ) {
    final sections = <String, List<GameItem>>{};

    for (final entry in groupedGames.entries) {
      final games =
          entry.value.where((game) => game.isPhysical == isPhysical).toList();
      if (games.isNotEmpty) {
        sections[entry.key] = games;
      }
    }

    return sections;
  }

  Widget _buildFormatGroup(String group, Map<String, List<GameItem>> sections) {
    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    final sectionExpansion = ref.watch(sectionExpansionProvider);
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final filtersActive = selectedPlatform != 'All' || searchQuery.isNotEmpty;
    final isExpanded =
        filtersActive
            ? sections.isNotEmpty
            : (sectionExpansion[group] ?? true);
    final gameCount = sections.values.fold<int>(
      0,
      (total, games) => total + games.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlimSectionHeader(
          title: group,
          isExpanded: isExpanded,
          onToggle:
              () => ref
                  .read(sectionExpansionProvider.notifier)
                  .toggleSection(group),
          gameCount: gameCount,
        ),
        if (isExpanded)
          ...sections.entries.map(
            (entry) => _buildPlatformSection(group, entry.key, entry.value),
          ),
        SizedBox(height: BacklogStyles.platformSectionSpacing),
      ],
    );
  }

  Widget _buildPlatformSection(
    String group,
    String platform,
    List<GameItem> games,
  ) {
    return Column(
      children: [
        BacklogPlatformSection(
          platform: platform,
          games: games,
          expansionKey: '$group/$platform',
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

  Future<void> _handleAddGame() async {
    final paywallService = ref.read(paywallServiceProvider);
    final canProceed = await paywallService.checkAndShowPaywall(context);
    if (!canProceed || !mounted) return;

    Navigator.of(context).push(
      EditScreenPageRoute(
        child: GameEditScreen.add(defaultIsPhysical: true),
      ),
    );
  }
}
