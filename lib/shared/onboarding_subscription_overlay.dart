import 'package:flutter/material.dart';
import 'styles.dart';

class OnboardingSubscriptionOverlay extends StatefulWidget {
  const OnboardingSubscriptionOverlay({super.key});

  @override
  State<OnboardingSubscriptionOverlay> createState() =>
      _OnboardingSubscriptionOverlayState();
}

class _OnboardingSubscriptionOverlayState
    extends State<OnboardingSubscriptionOverlay> {
  int? _selectedOption;
  bool _isVisible = false;

  final List<_SubscriptionOption> _options = const [
    _SubscriptionOption('Monthly', '£2.99/month', 'Billed monthly', 2.99),
    _SubscriptionOption('Yearly', '£20/year', 'Save 44%', 20),
    _SubscriptionOption('Lifetime', '£30 one-off', 'Best value', 30),
  ];

  @override
  void initState() {
    super.initState();
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
    final maxPortraitHeight = MediaQuery.of(context).size.height * 0.85;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      bottom: _isVisible ? 0 : -MediaQuery.of(context).size.height,
      left: 0,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double overlayHeight =
              isPortrait
                  ? maxPortraitHeight
                  : (constraints.maxHeight * 0.7).clamp(
                    0.0,
                    constraints.maxHeight,
                  );

          return Container(
            constraints: BoxConstraints(maxHeight: overlayHeight),
            decoration: OnboardingOverlayStyles.overlayDecoration,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: OnboardingOverlayStyles.overlayPadding,
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Choose your subscription',
                          style: onboardingWelcomeTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: OnboardingOverlayStyles.titleSpacing,
                        ),
                        _SubscriptionMessage(),
                        const SizedBox(
                          height: OnboardingOverlayStyles.messageSpacing,
                        ),
                        if (isPortrait)
                          ...List.generate(
                            _options.length,
                            (i) => _SubscriptionTile(
                              option: _options[i],
                              selected: _selectedOption == i,
                              onTap: () => setState(() => _selectedOption = i),
                              isLandscape: false,
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _options.length,
                                (i) => Container(
                                  width:
                                      OnboardingOverlayStyles
                                          .landscapeTileWidth,
                                  margin:
                                      OnboardingOverlayStyles
                                          .landscapeTileMargin,
                                  child: _SubscriptionTile(
                                    option: _options[i],
                                    selected: _selectedOption == i,
                                    onTap:
                                        () =>
                                            setState(() => _selectedOption = i),
                                    isLandscape: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        const SizedBox(
                          height: OnboardingOverlayStyles.buttonTopSpacing,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: OnboardingOverlayStyles.subscribeButtonHeight,
                          child: ElevatedButton(
                            onPressed:
                                _selectedOption != null
                                    ? () {
                                      /* TODO: Handle subscribe */
                                    }
                                    : null,
                            style: OnboardingOverlayStyles.subscribeButtonStyle,
                            child: const Text('Subscribe'),
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

class _SubscriptionMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final boldStyle = defaultStyle?.copyWith(fontWeight: FontWeight.bold);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: [
          TextSpan(text: 'Every option comes with a '),
          TextSpan(text: '7 day free trial', style: boldStyle),
          TextSpan(
            text: '. We\'ll remind you on day 5 in case you want to cancel.',
          ),
        ],
      ),
    );
  }
}

class _SubscriptionOption {
  final String title;
  final String price;
  final String subtitle;
  final double value;
  const _SubscriptionOption(this.title, this.price, this.subtitle, this.value);
}

class _SubscriptionTile extends StatelessWidget {
  final _SubscriptionOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool isLandscape;
  const _SubscriptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:
          selected
              ? OnboardingOverlayStyles.tileElevationSelected
              : OnboardingOverlayStyles.tileElevationUnselected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          OnboardingOverlayStyles.tileBorderRadius,
        ),
        side: BorderSide(
          color: selected ? Theme.of(context).primaryColor : Colors.transparent,
          width: OnboardingOverlayStyles.tileBorderWidth,
        ),
      ),
      margin: OnboardingOverlayStyles.tileMargin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          OnboardingOverlayStyles.tileBorderRadius,
        ),
        child: Padding(
          padding: OnboardingOverlayStyles.tilePadding,
          child:
              isLandscape
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        option.title,
                        style: OnboardingOverlayStyles.tileTitleStyle,
                      ),
                      const SizedBox(
                        height: OnboardingOverlayStyles.landscapeSpacing,
                      ),
                      Text(option.subtitle, textAlign: TextAlign.center),
                      const SizedBox(
                        height: OnboardingOverlayStyles.landscapeBottomSpacing,
                      ),
                      Text(
                        option.price,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.title,
                              style: OnboardingOverlayStyles.tileTitleStyle,
                            ),
                            Text(option.subtitle),
                          ],
                        ),
                      ),
                      Text(
                        option.price,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
