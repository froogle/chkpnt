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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withAlpha(0xB3), Colors.white],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 28,
                  spreadRadius: 4,
                  offset: Offset(0, -4),
                ),
              ],
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
                    child: _OnboardingContent(
                      onStartPressed: widget.onStartPressed,
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

class _OnboardingContent extends StatelessWidget {
  final VoidCallback onStartPressed;
  const _OnboardingContent({required this.onStartPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const _OnboardingDescription(),
        const SizedBox(height: 18),
        _OnboardingButton(onPressed: onStartPressed),
      ],
    );
  }
}

class _OnboardingDescription extends StatelessWidget {
  const _OnboardingDescription();

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final boldStyle = defaultStyle?.copyWith(fontWeight: FontWeight.bold);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(
            text: 'Take control of your gaming backlog!\n\n',
            style: boldStyle,
          ),
          const TextSpan(
            text:
                'Enjoy features like progress tracking, wishlists, and order tracking.\n\n',
          ),
          const TextSpan(text: 'Start now with a free 7 day trial.\n\n'),
          TextSpan(text: 'No strings attached!', style: boldStyle),
        ],
      ),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _OnboardingButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.25),
        ),
        child: const Text("Let's Go"),
      ),
    );
  }
}
