import 'package:flutter/material.dart';
import 'package:chkpnt/styles/global_styles.dart';

class GuideWebReaderToolbar extends StatelessWidget {
  final String title;
  final String author;
  final bool canGoBack;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final VoidCallback? onDelete;

  const GuideWebReaderToolbar({
    super.key,
    required this.title,
    required this.author,
    required this.canGoBack,
    required this.onBack,
    required this.onClose,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBackButton(),
          Expanded(child: _buildTitleSection()),
          const SizedBox(width: 8),
          if (onDelete != null) _buildDeleteButton(),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: canGoBack ? onBack : null,
      icon: Icon(
        Icons.arrow_back,
        color: canGoBack ? AppColors.primaryText : AppColors.expandIcon,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'by $author',
          style: TextStyle(fontSize: 12, color: AppColors.expandIcon),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: onDelete,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      tooltip: 'Delete guide',
    );
  }

  Widget _buildCloseButton() {
    return IconButton(
      onPressed: onClose,
      icon: Icon(Icons.close, color: AppColors.primaryText),
    );
  }
}
