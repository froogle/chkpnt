import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class WelcomeEmptyState extends StatelessWidget {
  final VoidCallback onAddGamePressed;

  const WelcomeEmptyState({super.key, required this.onAddGamePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            _buildMessage(),
            const SizedBox(height: 32),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.1),
            AppColors.secondaryPurple.withValues(alpha: 0.05),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.videogame_asset_outlined,
        size: 64,
        color: AppColors.primaryPurple,
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      'Add your first game to start tracking your collection',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryText,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAddButton() {
    return InputStyles.gradientButton(
      onPressed: onAddGamePressed,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_rounded, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            'Add Game',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
