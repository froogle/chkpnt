import 'package:flutter/material.dart';
import 'package:chkpnt/styles/main_screen_styles.dart';

class MainScreenBottomNav extends StatelessWidget {
  final Function(int)? onNavItemPressed;

  const MainScreenBottomNav({super.key, this.onNavItemPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MainScreenStyles.bottomNavHeight,
      decoration: MainScreenStyles.bottomNavDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(Icons.bookmark_outline, 0),
          _buildNavButton(Icons.grid_view_outlined, 1),
          _buildNavButton(Icons.person_outline, 2),
          _buildNavButton(Icons.circle_outlined, 3),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, int index) {
    return IconButton(
      onPressed: () => onNavItemPressed?.call(index),
      icon: Icon(icon, color: const Color(0xFFDFB268)),
    );
  }
}
