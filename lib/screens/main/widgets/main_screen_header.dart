import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_filter_dropdown.dart';
import 'package:chkpnt/shared/widgets/inputs/compact_search_bar.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/main_screen_styles.dart';
import 'package:chkpnt/styles/input_styles.dart';

class MainScreenHeader extends ConsumerWidget {
  final VoidCallback? onAddGamePressed;

  const MainScreenHeader({super.key, this.onAddGamePressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Row(
        children: [
          _buildPlatformFilter(ref),
          const SizedBox(width: 12),
          _buildSearchBar(),
          const SizedBox(width: 12),
          _buildAddGameButton(),
        ],
      ),
    );
  }

  Widget _buildPlatformFilter(WidgetRef ref) {
    final selectedPlatform = ref.watch(selectedPlatformProvider);
    final availablePlatforms = ref.watch(availablePlatformsProvider);

    return PlatformFilterDropdown(
      selectedPlatform: selectedPlatform,
      platforms: availablePlatforms,
      onPlatformChanged: (platform) {
        ref.read(selectedPlatformProvider.notifier).selectPlatform(platform);
      },
    );
  }

  Widget _buildSearchBar() {
    return const Expanded(child: CompactSearchBar());
  }

  Widget _buildAddGameButton() {
    return InputStyles.gradientButton(
      onPressed: onAddGamePressed ?? () {},
      padding: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(16),
      child: Icon(Icons.add_rounded, color: Colors.white, size: 24),
    );
  }
}
