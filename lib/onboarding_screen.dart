import 'package:flutter/material.dart';
import 'shared/onboarding_overlay.dart';
import 'shared/onboarding_subscription_overlay.dart';

class OnboardingScreen extends StatelessWidget {
  static const String _backgroundImagePath = 'assets/onboarding1.png';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildBackgroundImage(), _buildOverlay(context)]),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(_backgroundImagePath, fit: BoxFit.cover),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return OnboardingOverlay(
      onStartPressed: () => _navigateToSubscriptionScreen(context),
    );
  }

  void _navigateToSubscriptionScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnboardingSubscriptionScreen()),
    );
  }
}

class OnboardingSubscriptionScreen extends StatelessWidget {
  static const String _backgroundImagePath = 'assets/onboarding2.png';

  const OnboardingSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_buildBackgroundImage(), _buildOverlay()]),
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
}
