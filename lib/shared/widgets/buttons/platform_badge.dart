import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class PlatformBadge extends StatelessWidget {
  final String platform;
  final VoidCallback? onTap;

  const PlatformBadge({super.key, required this.platform, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: GameDetailSheetStyles.platformBadgePadding,
        decoration: GameDetailSheetStyles.platformBadgeDecoration,
        child: Text(
          platform,
          style: GameDetailSheetStyles.platformBadgeTextStyle,
        ),
      ),
    );
  }
}
