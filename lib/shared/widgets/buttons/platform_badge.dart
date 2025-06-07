import 'package:flutter/material.dart';
import '../../../styles/styles.dart';

class PlatformBadge extends StatelessWidget {
  final String platform;

  const PlatformBadge({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: GameDetailSheetStyles.platformBadgePadding,
      decoration: GameDetailSheetStyles.platformBadgeDecoration,
      child: Text(
        platform,
        style: GameDetailSheetStyles.platformBadgeTextStyle,
      ),
    );
  }
}
