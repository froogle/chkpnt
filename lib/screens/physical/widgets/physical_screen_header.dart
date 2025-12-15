import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_filter_dropdown.dart';
import 'package:chkpnt/shared/widgets/inputs/compact_search_bar.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/styles.dart';

class PhysicalScreenHeader extends ConsumerWidget {
  const PhysicalScreenHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Row(
        children: [
          _buildTitle(),
          const SizedBox(width: 12),
          _buildPlatformFilter(ref),
          const SizedBox(width: 12),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.sd_card, size: 20, color: AppColors.primaryPurple),
        const SizedBox(width: 6),
        Text(
          'Physical',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformFilter(WidgetRef ref) {
    final selectedPlatform = ref.watch(physicalSelectedPlatformProvider);
    final availablePlatforms = ref.watch(physicalPlatformsProvider);

    return PlatformFilterDropdown(
      selectedPlatform: selectedPlatform,
      platforms: availablePlatforms,
      onPlatformChanged: (platform) {
        ref
            .read(physicalSelectedPlatformProvider.notifier)
            .selectPlatform(platform);
      },
    );
  }

  Widget _buildSearchBar() {
    return const Expanded(child: CompactSearchBar());
  }
}
