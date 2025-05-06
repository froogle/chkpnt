import 'package:flutter/material.dart';
import 'shared/onboarding_overlay.dart';

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
          Positioned.fill(
            child: OnboardingOverlay(
              onStartPressed: () {
                // TODO: Navigate to the next screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
