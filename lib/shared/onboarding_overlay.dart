import 'package:flutter/material.dart';
import '../styles/styles.dart';

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
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      bottom: _isVisible ? 0 : -MediaQuery.of(context).size.height,
      left: 0,
      right: 0,
      child: _buildOverlayContainer(context),
    );
  }

  Widget _buildOverlayContainer(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final maxPortraitHeight = MediaQuery.of(context).size.height * 0.7;

    return LayoutBuilder(
      builder: (context, constraints) {
        final overlayHeight = _calculateOverlayHeight(
          isPortrait,
          maxPortraitHeight,
          constraints,
        );

        return Container(
          constraints: BoxConstraints(maxHeight: overlayHeight),
          decoration: OnboardingOverlayStyles.overlayDecoration,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: OnboardingOverlayStyles.overlayPadding,
              child: _buildScrollableContent(),
            ),
          ),
        );
      },
    );
  }

  double _calculateOverlayHeight(
    bool isPortrait,
    double maxPortraitHeight,
    BoxConstraints constraints,
  ) {
    return isPortrait
        ? maxPortraitHeight
        : (constraints.maxHeight * 0.7).clamp(0.0, constraints.maxHeight);
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildHeader(), _buildDescription(), _buildActionButton()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Welcome to ChkPnt',
          style: onboardingWelcomeTextStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: OnboardingOverlayStyles.contentSpacing),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      children: [
        _OnboardingDescription(),
        const SizedBox(height: OnboardingOverlayStyles.contentSpacing),
      ],
    );
  }

  Widget _buildActionButton() {
    return _OnboardingButton(onPressed: widget.onStartPressed);
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
      height: OnboardingOverlayStyles.startButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: OnboardingOverlayStyles.startButtonStyle,
        child: const Text("Let's Go"),
      ),
    );
  }
}
