import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/global_styles.dart';

class ProfileSubscriptionSection extends ConsumerWidget {
  const ProfileSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      height:
          isLandscape ? 100.0 : 160.0, // Fixed heights instead of percentage
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.cardElevation,
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLandscape ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppHeadingStyles.gradientHeading(
              'Subscription Plan',
              fontSize: isLandscape ? 14 : 16,
            ),
            SizedBox(height: isLandscape ? 4 : 12),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: isLandscape ? 16 : 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText.withOpacity(0.4),
              ),
            ),
            SizedBox(height: isLandscape ? 2 : 8),
            Text(
              'Subscription management and premium features will be available here.',
              style: TextStyle(
                fontSize: isLandscape ? 11 : 14,
                color: AppColors.primaryText.withOpacity(0.6),
              ),
              maxLines: isLandscape ? 2 : null,
              overflow: isLandscape ? TextOverflow.ellipsis : null,
            ),
          ],
        ),
      ),
    );
  }
}
