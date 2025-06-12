import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/profile_styles.dart';
import 'package:chkpnt/styles/global_styles.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: ProfileStyles.profileAvatarSpacing),
              Expanded(child: _buildProfileInfo()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: ProfileStyles.profileAvatarSize,
      height: ProfileStyles.profileAvatarSize,
      decoration: ProfileStyles.profileAvatarDecoration,
      child: const Icon(Icons.person, size: 32, color: Colors.white),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadingStyles.gradientHeading(
          'Your Profile',
          fontSize: ProfileStyles.profileTitleFontSize,
        ),
        const SizedBox(height: 4),
        Text(
          'Track your gaming journey',
          style: ProfileStyles.profileSubtitleStyle,
        ),
      ],
    );
  }
}
