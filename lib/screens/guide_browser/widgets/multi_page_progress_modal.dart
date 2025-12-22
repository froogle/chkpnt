import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';

class MultiPageProgressModal extends StatelessWidget {
  final String guideTitle;
  final int currentPage;
  final int totalPages;
  final VoidCallback? onCancel;

  const MultiPageProgressModal({
    super.key,
    required this.guideTitle,
    required this.currentPage,
    required this.totalPages,
    this.onCancel,
  });

  double get _progress => totalPages > 0 ? currentPage / totalPages : 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.cardElevation,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildContent(),
              if (onCancel != null) _buildCancelButton(),
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
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Downloading Guide',
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
        children: [
          Text(
            guideTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: AppColors.collapsibleSection,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Page $currentPage of $totalPages',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(_progress * 100).toInt()}% complete',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.expandIcon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.collapsibleSection,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.expandIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MultiPageProgressController {
  final BuildContext context;
  final String guideTitle;
  final int totalPages;
  final VoidCallback? onCancel;

  int _currentPage = 0;
  StateSetter? _setState;
  bool _isCancelled = false;

  MultiPageProgressController({
    required this.context,
    required this.guideTitle,
    required this.totalPages,
    this.onCancel,
  });

  bool get isCancelled => _isCancelled;

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            _setState = setState;
            return MultiPageProgressModal(
              guideTitle: guideTitle,
              currentPage: _currentPage,
              totalPages: totalPages,
              onCancel: onCancel != null
                  ? () {
                      _isCancelled = true;
                      onCancel!();
                    }
                  : null,
            );
          },
        );
      },
    );
  }

  void updateProgress(int currentPage) {
    _currentPage = currentPage;
    _setState?.call(() {});
  }

  void dismiss() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
