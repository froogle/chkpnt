import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

class ProfileSubscriptionSection extends ConsumerWidget {
  const ProfileSubscriptionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ProfileStyles.getSubscriptionHeight(isLandscape),
      ),
      decoration: ProfileStyles.sectionDecoration,
      child: Padding(
        padding: EdgeInsets.all(
          isLandscape ? 12 : ProfileStyles.sectionPadding,
        ),
        child: _buildContent(isLandscape),
      ),
    );
  }

  Widget _buildContent(bool isLandscape) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppHeadingStyles.gradientHeading(
            'Subscription Plan',
            fontSize: isLandscape ? 14 : 16,
          ),
          SizedBox(height: isLandscape ? 4 : 12),
          Text(
            'Coming Soon',
            style: ProfileStyles.subscriptionComingSoonStyle(isLandscape),
          ),
          SizedBox(height: isLandscape ? 2 : 8),
          Flexible(
            child: Text(
              'Subscription management and premium features will be available here.',
              style: ProfileStyles.subscriptionDescriptionStyle(isLandscape),
              maxLines: isLandscape ? 2 : null,
              overflow: isLandscape ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }
}
