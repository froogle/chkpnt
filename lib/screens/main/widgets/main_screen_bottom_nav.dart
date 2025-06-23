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
          _buildNavButton(Icons.home_outlined, 0, currentScreen == 0),
          _buildNavButton(Icons.list_alt_outlined, 1, currentScreen == 1),
          _buildNavButton(Icons.favorite_outline, 2, currentScreen == 2),
          _buildNavButton(Icons.person_outline, 3, currentScreen == 3),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, int index, bool isActive) {
    return IconButton(
      onPressed: () => onNavItemPressed?.call(index),
      icon: Icon(
        icon,
        color:
            isActive
                ? AppColors.primaryPurple
                : AppColors.primaryPurple.withValues(alpha: 0.5),
        size: isActive ? 26 : 24,
      ),
    );
  }

  int _getScreenIndexFromRoute(String? route) {
    switch (route) {
      case '/main':
        return 0;
      case '/backlog':
        return 1;
      case '/wishlist':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }
}
