import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/main_screen_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

class MainScreenBottomNav extends ConsumerWidget {
  final Function(int)? onNavItemPressed;

  const MainScreenBottomNav({super.key, this.onNavItemPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final currentScreen = _getScreenIndexFromRoute(currentRoute);

    return Container(
      height: MainScreenStyles.bottomNavHeight,
      decoration: MainScreenStyles.bottomNavDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildNavButton(Icons.home_outlined, 0, currentScreen == 0),
          ),
          Expanded(
            child: _buildNavButton(
              Icons.list_alt_outlined,
              1,
              currentScreen == 1,
            ),
          ),
          Expanded(
            child: _buildNavButton(
              Icons.sd_card_outlined,
              2,
              currentScreen == 2,
            ),
          ),
          Expanded(
            child: _buildNavButton(
              Icons.favorite_outline,
              3,
              currentScreen == 3,
            ),
          ),
          Expanded(
            child: _buildNavButton(
              Icons.person_outline,
              4,
              currentScreen == 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, int index, bool isActive) {
    return IconButton(
      onPressed: () => onNavItemPressed?.call(index),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 40),
      icon: Icon(
        icon,
        color:
            isActive
                ? AppColors.primaryPurple
                : AppColors.primaryPurple.withValues(alpha: 0.5),
        size: isActive ? 24 : 22,
      ),
    );
  }

  int _getScreenIndexFromRoute(String? route) {
    switch (route) {
      case '/main':
        return 0;
      case '/backlog':
        return 1;
      case '/physical':
        return 2;
      case '/wishlist':
        return 3;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }
}
