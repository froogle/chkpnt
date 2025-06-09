import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class SlimSectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool isEmpty;
  final int gameCount;

  const SlimSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.isEmpty = false,
    this.gameCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(), _buildDivider()],
    );
  }

  Widget _buildHeader() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              _buildExpandIcon(),
              const SizedBox(width: 12),
              Expanded(child: _buildTitle()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    return AnimatedRotation(
      turns: isExpanded ? 0.25 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.primaryText.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, AppColors.primaryPurple, Colors.black],
            stops: [0.2, 0.5, 0.8],
          ).createShader(bounds),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            TextSpan(
              text: ' ($gameCount)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 1,
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryAccent.withValues(alpha: isExpanded ? 0.6 : 0.3),
            Colors.transparent,
          ],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }
}
