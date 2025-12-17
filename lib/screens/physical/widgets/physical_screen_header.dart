import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/shared/widgets/inputs/platform_filter_dropdown.dart';
import 'package:chkpnt/shared/widgets/inputs/compact_search_bar.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/styles.dart';

class PhysicalScreenHeader extends ConsumerStatefulWidget {
  final VoidCallback? onAddGamePressed;

  const PhysicalScreenHeader({super.key, this.onAddGamePressed});

  @override
  ConsumerState<PhysicalScreenHeader> createState() =>
      _PhysicalScreenHeaderState();
}

class _PhysicalScreenHeaderState extends ConsumerState<PhysicalScreenHeader> {
  bool _showTitle = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MainScreenStyles.headerPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedTitleRow(),
          _buildControlsRow(),
        ],
      ),
    );
  }

  Widget _buildAnimatedTitleRow() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _showTitle ? 1.0 : 0.0,
        child:
            _showTitle
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildTitleRow(),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sd_card_outlined, size: 20, color: AppColors.primaryPurple),
        const SizedBox(width: 8),
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

  Widget _buildControlsRow() {
    return Row(
      children: [
        _buildPlatformFilter(),
        const SizedBox(width: 12),
        _buildSearchBar(),
        const SizedBox(width: 12),
        _buildAddGameButton(),
      ],
    );
  }

  Widget _buildAddGameButton() {
    return InputStyles.gradientButton(
      onPressed: widget.onAddGamePressed ?? () {},
      padding: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(16),
      child: Icon(Icons.add_rounded, color: Colors.white, size: 24),
    );
  }

  Widget _buildPlatformFilter() {
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
