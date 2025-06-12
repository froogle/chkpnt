import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/main_screen_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'widgets/profile_subscription_section.dart';
import 'widgets/profile_visualisation_section.dart';
import 'widgets/profile_incoming_games_section.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Set current screen for nav indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentScreenProvider.notifier).setScreen(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildContent()),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
        );
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileHeader(),
        const SizedBox(height: 24),
        const ProfileSubscriptionSection(),
        SizedBox(height: ProfileStyles.getSectionSpacing(false)),
        const ProfileVisualisationSection(),
        SizedBox(height: ProfileStyles.getSectionSpacing(false)),
        const ProfileIncomingGamesSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileHeader(),
        const SizedBox(height: 12),
        const ProfileSubscriptionSection(),
        SizedBox(height: ProfileStyles.getSectionSpacing(true)),
        // In landscape, show visualisation and incoming games side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 2, child: ProfileVisualisationSection()),
            const SizedBox(width: 24),
            const Expanded(flex: 1, child: ProfileIncomingGamesSection()),
          ],
        ),
        SizedBox(height: ProfileStyles.getSectionSpacing(true)),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return MainScreenBottomNav(onNavItemPressed: _handleNavigation);
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/main', (route) => false);
        break;
      case 1: // Backlog
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/backlog', (route) => false);
        break;
      case 2: // Wishlist
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/wishlist', (route) => false);
        break;
      case 3: // Profile - current screen, do nothing
        break;
    }
  }
}
