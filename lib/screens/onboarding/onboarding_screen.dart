import 'package:flutter/material.dart';
import 'widgets/onboarding_overlay.dart';
import 'widgets/onboarding_subscription_overlay.dart';

class OnboardingScreen extends StatelessWidget {
  static const String _backgroundImagePath = 'assets/onboarding1.png';

  final bool showCloseButton;

  const OnboardingScreen({super.key, this.showCloseButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildOverlay(context),
          if (showCloseButton) _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(_backgroundImagePath, fit: BoxFit.cover),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return OnboardingOverlay(
      onStartPressed: () => _navigateToSubscription(context),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 8,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(false),
        icon: const Icon(Icons.close, color: Colors.white, size: 28),
      ),
    );
  }

  Future<void> _navigateToSubscription(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            const OnboardingSubscriptionScreen(showCloseButton: true),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      Navigator.of(context).pop(true);
    }
  }
}

class OnboardingSubscriptionScreen extends StatelessWidget {
  static const String _backgroundImagePath = 'assets/onboarding2.png';

  final bool showCloseButton;

  const OnboardingSubscriptionScreen({super.key, this.showCloseButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildOverlay(),
          if (showCloseButton) _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(_backgroundImagePath, fit: BoxFit.cover),
    );
  }

  Widget _buildOverlay() {
    return const OnboardingSubscriptionOverlay();
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 8,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(false),
        icon: const Icon(Icons.close, color: Colors.white, size: 28),
      ),
    );
  }
}
