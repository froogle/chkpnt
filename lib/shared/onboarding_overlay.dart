import 'package:flutter/material.dart';
import 'styles.dart';

class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({super.key, required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class _OnboardingOverlayState extends State<OnboardingOverlay> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final maxPortraitHeight = MediaQuery.of(context).size.height * 0.7;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      bottom: _isVisible ? 0 : -MediaQuery.of(context).size.height,
      left: 0,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // For landscape mode, use 70% of screen height
          // For portrait mode, use the intrinsic height of the content, up to 70% of the screen height
          final double overlayHeight =
              isPortrait
                  ? maxPortraitHeight
                  : (constraints.maxHeight * 0.7).clamp(
                    0.0,
                    constraints.maxHeight,
                  );

          return Container(
            constraints: BoxConstraints(maxHeight: overlayHeight),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(0xB3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to ChkPnt',
                          style: onboardingWelcomeTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Take control of your gaming backlog!\n\nWith ChkPnt, you can easily track, organise, and complete your games. Enjoy features like progress tracking, wishlists, and personalised recommendations.\n\nStart your journey with a completely free 7 day trial—no strings attached!',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: widget.onStartPressed,
                            child: const Text("Let's Go"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
