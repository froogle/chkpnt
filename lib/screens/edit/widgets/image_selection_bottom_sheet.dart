import 'package:flutter/material.dart';
import 'package:chkpnt/services/game_image_service.dart';

class ImageSelectionBottomSheet extends StatelessWidget {
  final bool hasExistingImage;
  final VoidCallback? onRemoveImage;

  const ImageSelectionBottomSheet({
    super.key,
    required this.hasExistingImage,
    this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildSheetDecoration(),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildOptions(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildSheetDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildOptionTile(
            context: context,
            icon: Icons.photo_library,
            title: 'Photo Gallery',
            subtitle: 'Choose from your photos',
            onTap:
                () => _handleSourceSelection(context, GameImageSource.gallery),
          ),
          const SizedBox(height: 8),
          _buildOptionTile(
            context: context,
            icon: Icons.folder,
            title: 'File Browser',
            subtitle: 'Choose from files',
            onTap: () => _handleSourceSelection(context, GameImageSource.files),
          ),
          if (hasExistingImage) ...[
            const SizedBox(height: 8),
            _buildOptionTile(
              context: context,
              icon: Icons.delete_outline,
              title: 'Remove Image',
              subtitle: 'Use placeholder instead',
              onTap: () => _handleRemoveImage(context),
              isDestructive: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red[600] : Colors.blue[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red[700] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _handleSourceSelection(BuildContext context, GameImageSource source) {
    Navigator.of(context).pop(source);
  }

  void _handleRemoveImage(BuildContext context) {
    Navigator.of(context).pop('remove');
  }

  /// Shows the image selection bottom sheet
  static Future<dynamic> show({
    required BuildContext context,
    required bool hasExistingImage,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) =>
              ImageSelectionBottomSheet(hasExistingImage: hasExistingImage),
    );
  }
}
