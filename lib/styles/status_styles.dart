import 'package:flutter/material.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/styles/global_styles.dart';

class StatusStyle {
  final String label;
  final IconData? icon;
  final Color colour;

  const StatusStyle({required this.label, required this.colour, this.icon});
}

class StatusStyles {
  static StatusStyle of(GameStatus status) => switch (status) {
    GameStatus.playing => const StatusStyle(
      label: 'Playing',
      icon: Icons.play_circle_fill,
      colour: Colors.orange,
    ),
    GameStatus.completed => const StatusStyle(
      label: 'Completed',
      icon: Icons.check_circle,
      colour: Colors.green,
    ),
    GameStatus.backlog => const StatusStyle(
      label: 'Backlog',
      icon: Icons.schedule,
      colour: Colors.blue,
    ),
    GameStatus.abandoned => const StatusStyle(
      label: 'Abandoned',
      icon: Icons.do_not_disturb_on,
      colour: Colors.grey,
    ),
    GameStatus.wishlist => const StatusStyle(
      label: 'Wishlist',
      icon: Icons.favorite,
      colour: Colors.pink,
    ),
    GameStatus.ordered => const StatusStyle(
      label: 'Ordered',
      icon: Icons.shopping_cart,
      colour: Colors.purple,
    ),
    GameStatus.ongoing => const StatusStyle(
      label: 'Ongoing',
      icon: Icons.replay,
      colour: Color(0xFF06B6D4),
    ),
    GameStatus.owned => const StatusStyle(
      label: 'In Collection',
      colour: AppColors.emptyStateIcon,
    ),
  };
}
