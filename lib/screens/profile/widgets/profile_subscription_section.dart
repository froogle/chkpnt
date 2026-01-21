import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/config/feature_flags.dart';
import 'package:chkpnt/services/subscription_service.dart';
import 'package:chkpnt/services/paywall_service.dart';

class ProfileSubscriptionSection extends ConsumerWidget {
  const ProfileSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ProfileStyles.getSubscriptionHeight(isLandscape),
      ),
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: EdgeInsets.all(
          isLandscape ? 12 : ProfileStyles.sectionPadding,
        ),
        child: _buildContent(ref, isLandscape),
      ),
    );
  }

  Widget _buildContent(WidgetRef ref, bool isLandscape) {
    if (!kPaywallEnabled) {
      return _buildPaywallDisabledContent(isLandscape);
    }

    final subscriptionState = ref.watch(subscriptionStateProvider);
    final paywallService = ref.read(paywallServiceProvider);

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppHeadingStyles.gradientHeading(
            'Subscription Plan',
            fontSize: isLandscape ? 14 : 16,
          ),
          SizedBox(height: isLandscape ? 4 : 12),
          Text(
            _getSubscriptionTitle(subscriptionState),
            style: ProfileStyles.subscriptionComingSoonStyle(isLandscape),
          ),
          SizedBox(height: isLandscape ? 2 : 8),
          Flexible(
            child: Text(
              _getSubscriptionDescription(subscriptionState, paywallService),
              style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
              maxLines: isLandscape ? 2 : null,
              overflow: isLandscape ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaywallDisabledContent(bool isLandscape) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppHeadingStyles.gradientHeading(
            'Subscription Plan',
            fontSize: isLandscape ? 14 : 16,
          ),
          SizedBox(height: isLandscape ? 4 : 12),
          Text(
            'Premium (Dev Mode)',
            style: ProfileStyles.subscriptionComingSoonStyle(isLandscape),
          ),
          SizedBox(height: isLandscape ? 2 : 8),
          Flexible(
            child: Text(
              'Paywall is disabled. All features are unlocked.',
              style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
              maxLines: isLandscape ? 2 : null,
              overflow: isLandscape ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getSubscriptionTitle(SubscriptionState state) {
    if (state.isLoading) {
      return 'Checking...';
    }

    switch (state.status) {
      case SubscriptionStatus.active:
        return 'Premium';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.inactive:
      case SubscriptionStatus.unknown:
        return 'Free Plan';
    }
  }

  String _getSubscriptionDescription(
    SubscriptionState state,
    PaywallService paywallService,
  ) {
    if (state.isLoading) {
      return 'Verifying your subscription status...';
    }

    switch (state.status) {
      case SubscriptionStatus.active:
        return 'You have unlimited access to all features.';
      case SubscriptionStatus.expired:
        return 'Your subscription has expired. You can still access your existing games.';
      case SubscriptionStatus.inactive:
      case SubscriptionStatus.unknown:
        final remaining = paywallService.remainingFreeGames;
        final current = paywallService.currentGameCount;
        if (remaining > 0) {
          return 'You can add $remaining more game${remaining == 1 ? '' : 's'} for free ($current/$kMaxFreeGames used).';
        } else {
          return 'You\'ve reached the free limit of $kMaxFreeGames games. Subscribe to add more.';
        }
    }
  }
}
