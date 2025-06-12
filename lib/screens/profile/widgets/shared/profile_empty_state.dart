import 'package:flutter/material.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

/// Reusable empty state widget used across profile screen sections
class ProfileEmptyState extends StatelessWidget {
  const ProfileEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLandscape = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: ProfileStyles.getEmptyStateHeight(isLandscape),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ProfileStyles.getEmptyStateIconSize(isLandscape),
            color: AppColors.emptyStateIcon,
          ),
          SizedBox(height: isLandscape ? 8 : 12),
          Text(
            title,
            style: ProfileStyles.emptyStateLandscapeTitleStyle(isLandscape),
          ),
          SizedBox(height: isLandscape ? 2 : 4),
          Flexible(
            child: Text(
              subtitle,
              style: ProfileStyles.emptyStateLandscapeSubtitleStyle(
                isLandscape,
              ),
              textAlign: TextAlign.center,
              maxLines: isLandscape ? 2 : null,
              overflow: isLandscape ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }
}
