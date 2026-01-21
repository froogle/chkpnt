import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/config/feature_flags.dart';
import 'package:chkpnt/services/subscription_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialiseApp();
    });
  }

  Future<void> _initialiseApp() async {
    final futures = <Future>[];

    if (kPaywallEnabled) {
      futures.add(ref.read(subscriptionStateProvider.notifier).initialise());
    }

    futures.add(Future.delayed(SplashScreenStyles.splashDuration));

    await Future.wait(futures);

    if (!mounted) return;
    _navigateToMain();
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacementNamed('/main');
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
