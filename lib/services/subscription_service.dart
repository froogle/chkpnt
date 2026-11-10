import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chkpnt/config/feature_flags.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

final subscriptionStateProvider =
    StateNotifierProvider<SubscriptionStateNotifier, SubscriptionState>((ref) {
      final service = ref.watch(subscriptionServiceProvider);
      return SubscriptionStateNotifier(service);
    });

enum SubscriptionStatus { unknown, active, inactive, expired }

class SubscriptionState {
  final SubscriptionStatus status;
  final bool isLoading;
  final DateTime? lastChecked;

  const SubscriptionState({
    this.status = SubscriptionStatus.unknown,
    this.isLoading = false,
    this.lastChecked,
  });

  bool get hasActiveSubscription => status == SubscriptionStatus.active;

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    bool? isLoading,
    DateTime? lastChecked,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}

class SubscriptionStateNotifier extends StateNotifier<SubscriptionState> {
  final SubscriptionService _service;

  SubscriptionStateNotifier(this._service)
    : super(const SubscriptionState(isLoading: true));

  Future<void> initialise() async {
    if (!kPaywallEnabled) {
      state = const SubscriptionState(
        status: SubscriptionStatus.active,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final hasSubscription = await _service.checkSubscriptionStatus();
      state = SubscriptionState(
        status:
            hasSubscription
                ? SubscriptionStatus.active
                : SubscriptionStatus.inactive,
        isLoading: false,
        lastChecked: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Failed to check subscription status: $e');
      final cachedStatus = await _service.getCachedSubscriptionStatus();
      state = SubscriptionState(
        status: cachedStatus,
        isLoading: false,
        lastChecked: DateTime.now(),
      );
    }
  }

  Future<void> purchaseSubscription() async {
    state = state.copyWith(isLoading: true);

    final success = await _service.purchaseSubscription();
    if (success) {
      state = SubscriptionState(
        status: SubscriptionStatus.active,
        isLoading: false,
        lastChecked: DateTime.now(),
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true);

    final hasSubscription = await _service.restorePurchases();
    state = SubscriptionState(
      status:
          hasSubscription
              ? SubscriptionStatus.active
              : SubscriptionStatus.inactive,
      isLoading: false,
      lastChecked: DateTime.now(),
    );
  }
}

class SubscriptionService {
  static const String _subscriptionCacheKey = 'cached_subscription_status';
  static const String _lastCheckKey = 'last_subscription_check';

  Future<bool> checkSubscriptionStatus() async {
    // TODO: Replace with actual Google Play Billing check
    // For now, this is a mock implementation that checks cached status
    final cachedStatus = await getCachedSubscriptionStatus();
    return cachedStatus == SubscriptionStatus.active;
  }

  Future<SubscriptionStatus> getCachedSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedValue = prefs.getString(_subscriptionCacheKey);

      if (cachedValue == null) {
        return SubscriptionStatus.inactive;
      }

      return SubscriptionStatus.values.firstWhere(
        (status) => status.name == cachedValue,
        orElse: () => SubscriptionStatus.inactive,
      );
    } catch (e) {
      debugPrint('Failed to get cached subscription status: $e');
      return SubscriptionStatus.inactive;
    }
  }

  Future<void> cacheSubscriptionStatus(SubscriptionStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_subscriptionCacheKey, status.name);
      await prefs.setString(_lastCheckKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Failed to cache subscription status: $e');
    }
  }

  Future<bool> purchaseSubscription() async {
    // TODO: Replace with actual Google Play Billing purchase flow
    // For now, this mock implementation simulates a successful purchase
    await cacheSubscriptionStatus(SubscriptionStatus.active);
    return true;
  }

  Future<bool> restorePurchases() async {
    // TODO: Replace with actual Google Play Billing restore flow
    // For now, this checks if there's a cached active subscription
    final cachedStatus = await getCachedSubscriptionStatus();
    return cachedStatus == SubscriptionStatus.active;
  }
}
