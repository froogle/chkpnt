import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/config/feature_flags.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/services/subscription_service.dart';
import 'package:chkpnt/screens/onboarding/onboarding_screen.dart';

final paywallServiceProvider = Provider<PaywallService>((ref) {
  return PaywallService(ref);
});

class PaywallService {
  final Ref _ref;

  PaywallService(this._ref);

  bool canAddGame() {
    if (!kPaywallEnabled) {
      return true;
    }

    final subscriptionState = _ref.read(subscriptionStateProvider);
    if (subscriptionState.hasActiveSubscription) {
      return true;
    }

    final currentGameCount = _ref.read(gameListProvider).length;
    return currentGameCount < kMaxFreeGames;
  }

  Future<bool> checkAndShowPaywall(BuildContext context) async {
    if (canAddGame()) {
      return true;
    }

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(showCloseButton: true),
        fullscreenDialog: true,
      ),
    );

    return result == true;
  }

  int get currentGameCount => _ref.read(gameListProvider).length;

  int get remainingFreeGames {
    if (!kPaywallEnabled) {
      return -1;
    }

    final subscriptionState = _ref.read(subscriptionStateProvider);
    if (subscriptionState.hasActiveSubscription) {
      return -1;
    }

    final currentCount = currentGameCount;
    final remaining = kMaxFreeGames - currentCount;
    return remaining > 0 ? remaining : 0;
  }

  bool get shouldShowPaywall {
    if (!kPaywallEnabled) {
      return false;
    }

    final subscriptionState = _ref.read(subscriptionStateProvider);
    if (subscriptionState.hasActiveSubscription) {
      return false;
    }

    return currentGameCount >= kMaxFreeGames;
  }
}
