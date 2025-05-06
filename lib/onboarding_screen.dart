import 'package:flutter/material.dart';
import 'shared/onboarding_overlay.dart';
import 'shared/onboarding_subscription_overlay.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/onboarding1.png', fit: BoxFit.cover),
          ),
          OnboardingOverlay(
            onStartPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OnboardingSubscriptionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingSubscriptionScreen extends StatelessWidget {
  const OnboardingSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/onboarding2.png', fit: BoxFit.cover),
          ),
          OnboardingSubscriptionOverlay(),
        ],
      ),
    );
  }
}
