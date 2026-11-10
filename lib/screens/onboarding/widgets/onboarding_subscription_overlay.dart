import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/services/subscription_service.dart';

class OnboardingSubscriptionOverlay extends ConsumerStatefulWidget {
  const OnboardingSubscriptionOverlay({super.key});

  @override
  ConsumerState<OnboardingSubscriptionOverlay> createState() =>
      _OnboardingSubscriptionOverlayState();
}

class _OnboardingSubscriptionOverlayState
    extends ConsumerState<OnboardingSubscriptionOverlay> {
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
    final maxPortraitHeight = MediaQuery.of(context).size.height * 0.85;

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
              child: _buildScrollableContent(context, isPortrait),
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

  Widget _buildScrollableContent(BuildContext context, bool isPortrait) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildMessage(),
            _buildSubscriptionOptions(isPortrait),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Choose your subscription',
          style: onboardingWelcomeTextStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: OnboardingOverlayStyles.titleSpacing),
      ],
    );
  }

  Widget _buildMessage() {
    return Column(
      children: [
        _SubscriptionMessage(),
        const SizedBox(height: OnboardingOverlayStyles.messageSpacing),
      ],
    );
  }

  Widget _buildSubscriptionOptions(bool isPortrait) {
    return Column(
      children: [
        if (isPortrait) _buildPortraitOptions() else _buildLandscapeOptions(),
        const SizedBox(height: OnboardingOverlayStyles.buttonTopSpacing),
      ],
    );
  }

  Widget _buildPortraitOptions() {
    return Column(
      children: List.generate(
        _options.length,
        (i) => _SubscriptionTile(
          option: _options[i],
          selected: _selectedOption == i,
          onTap: () => _selectOption(i),
          isLandscape: false,
        ),
      ),
    );
  }

  Widget _buildLandscapeOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_options.length, (i) => _buildLandscapeTile(i)),
      ),
    );
  }

  Widget _buildLandscapeTile(int index) {
    return Container(
      width: OnboardingOverlayStyles.landscapeTileWidth,
      margin: OnboardingOverlayStyles.landscapeTileMargin,
      child: _SubscriptionTile(
        option: _options[index],
        selected: _selectedOption == index,
        onTap: () => _selectOption(index),
        isLandscape: true,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: OnboardingOverlayStyles.subscribeButtonHeight,
      child: ElevatedButton(
        onPressed: _selectedOption != null ? _handleSubscribe : null,
        style: OnboardingOverlayStyles.subscribeButtonStyle,
        child: const Text('Subscribe'),
      ),
    );
  }

  void _selectOption(int index) {
    setState(() {
      _selectedOption = index;
    });
  }

  Future<void> _handleSubscribe() async {
    await ref.read(subscriptionStateProvider.notifier).purchaseSubscription();

    if (!mounted) return;

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(true);
    } else {
      navigator.pushReplacementNamed('/main');
    }
  }
}

class _SubscriptionMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use explicit colours instead of theme for Android 13 compatibility
    const defaultStyle = TextStyle(
      fontSize: 16,
      color: AppColors.primaryText, // Explicit dark color
      height: 1.4,
    );
    const boldStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryText, // Explicit dark color
      height: 1.4,
    );
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
      elevation: selected
          ? OnboardingOverlayStyles.tileElevationSelected
          : OnboardingOverlayStyles.tileElevationUnselected,
      color: selected
          ? const Color(0xFFF3F4F6)
          : Colors.white, // Explicit background colours for Android 13
      shape: _buildCardShape(context),
      margin: OnboardingOverlayStyles.tileMargin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          OnboardingOverlayStyles.tileBorderRadius,
        ),
        child: Padding(
          padding: OnboardingOverlayStyles.tilePadding,
          child: isLandscape
              ? _buildLandscapeLayout(context)
              : _buildPortraitLayout(context),
        ),
      ),
    );
  }

  RoundedRectangleBorder _buildCardShape(BuildContext context) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        OnboardingOverlayStyles.tileBorderRadius,
      ),
      side: BorderSide(
        color: selected
            ? const Color(0xFF8B5CF6)
            : Colors.transparent, // Explicit purple border for Android 13
        width: OnboardingOverlayStyles.tileBorderWidth,
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(option.title, style: OnboardingOverlayStyles.tileTitleStyle),
        const SizedBox(height: OnboardingOverlayStyles.landscapeSpacing),
        Text(
          option.subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.primaryText,
          ), // Explicit colour
        ),
        const SizedBox(height: OnboardingOverlayStyles.landscapeBottomSpacing),
        Text(
          option.price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText, // Explicit colour
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(option.title, style: OnboardingOverlayStyles.tileTitleStyle),
              Text(
                option.subtitle,
                style: const TextStyle(
                  color: AppColors.primaryText,
                ), // Explicit colour
              ),
            ],
          ),
        ),
        Text(
          option.price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText, // Explicit colour
          ),
        ),
      ],
    );
  }
}
