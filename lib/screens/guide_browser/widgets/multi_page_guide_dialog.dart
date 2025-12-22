import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';

enum MultiPageGuideAction { downloadFull, saveCurrentPage, cancel }

class MultiPageGuideDialog extends StatelessWidget {
  final String guideTitle;
  final int pageCount;

  const MultiPageGuideDialog({
    super.key,
    required this.guideTitle,
    required this.pageCount,
  });

  static Future<MultiPageGuideAction?> show(
    BuildContext context, {
    required String guideTitle,
    required int pageCount,
  }) {
    return showDialog<MultiPageGuideAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MultiPageGuideDialog(
        guideTitle: guideTitle,
        pageCount: pageCount,
      ),
    );
  }

  int get _estimatedSeconds => pageCount;

  String get _estimatedTimeText {
    if (_estimatedSeconds < 60) {
      return '~$_estimatedSeconds seconds';
    }
    final minutes = (_estimatedSeconds / 60).ceil();
    return '~$minutes minute${minutes > 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.cardElevation,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildContent(),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppGradients.buttonGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.library_books_outlined,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Multi-Page Guide',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            guideTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.pages_outlined,
            'This guide has $pageCount sections',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.timer_outlined,
            'Estimated download time: $_estimatedTimeText',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.collapsibleSection,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.expandIcon,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can save just this page or download all sections.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.expandIcon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryPurple,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPrimaryButton(
            context,
            'Download Full Guide',
            Icons.download,
            MultiPageGuideAction.downloadFull,
          ),
          const SizedBox(height: 10),
          _buildSecondaryButton(
            context,
            'Save Current Page Only',
            Icons.save_outlined,
            MultiPageGuideAction.saveCurrentPage,
          ),
          const SizedBox(height: 10),
          _buildTextButton(
            context,
            'Cancel',
            MultiPageGuideAction.cancel,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    String label,
    IconData icon,
    MultiPageGuideAction action,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(action),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          gradient: AppGradients.buttonGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.subtleElevation,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context,
    String label,
    IconData icon,
    MultiPageGuideAction action,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(action),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    String label,
    MultiPageGuideAction action,
  ) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(action),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.expandIcon,
            ),
          ),
        ),
      ),
    );
  }
}
