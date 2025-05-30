import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'shared/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Future.delayed(SplashScreenStyles.splashDuration, () {
      if (!mounted) return;
      _navigateToOnboarding();
    });
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashScreenStyles.backgroundColor,
      body: Center(child: _buildResponsiveLogo()),
    );
  }

  Widget _buildResponsiveLogo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final logoSize = _calculateLogoSize(constraints);
        return _buildLogoImage(logoSize);
      },
    );
  }

  double _calculateLogoSize(BoxConstraints constraints) {
    final availableSize =
        constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
    return availableSize * SplashScreenStyles.logoSizeRatio;
  }

  Widget _buildLogoImage(double size) {
    return Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
