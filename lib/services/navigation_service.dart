import 'package:flutter/material.dart';

/// Service for handling bottom navigation across main screens
///
/// This centralises the navigation logic that was previously duplicated
/// across MainScreen, BacklogScreen, WishlistScreen, and ProfileScreen
class NavigationService {
  static const int homeIndex = 0;
  static const int backlogIndex = 1;
  static const int wishlistIndex = 2;
  static const int profileIndex = 3;

  /// Handles navigation from any main screen to another
  ///
  /// Uses the current route to determine if navigation is needed,
  /// avoiding unnecessary navigation when already on the target screen
  ///
  /// [context] - BuildContext for navigation
  /// [targetIndex] - Index of the target screen (0-3)
  static void handleNavigation(BuildContext context, int targetIndex) {
    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '/main';
    final String targetRoute = _getRouteNameForIndex(targetIndex);

    // Don't navigate if already on the target screen
    if (currentRoute == targetRoute) {
      return;
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(targetRoute, (route) => false);
  }

  /// Maps navigation index to route name
  static String _getRouteNameForIndex(int index) {
    switch (index) {
      case homeIndex:
        return '/main';
      case backlogIndex:
        return '/backlog';
      case wishlistIndex:
        return '/wishlist';
      case profileIndex:
        return '/profile';
      default:
        return '/main'; // Default to home
    }
  }
}
