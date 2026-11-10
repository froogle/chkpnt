import 'package:flutter/material.dart';
import 'package:chkpnt/services/game_image_service.dart';
import 'package:chkpnt/styles/styles.dart';

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
      decoration: ImageSelectionStyles.sheetDecoration,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildOptions(context),
              const SizedBox(height: ImageSelectionStyles.bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: ImageSelectionStyles.headerPadding,
      child: Column(
        children: [
          _buildDragHandle(),
          const SizedBox(height: ImageSelectionStyles.dragHandleSpacing),
          _buildHeaderTitle(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: ImageSelectionStyles.dragHandleWidth,
      height: ImageSelectionStyles.dragHandleHeight,
      decoration: ImageSelectionStyles.dragHandleDecoration,
    );
  }

  Widget _buildHeaderTitle() {
    return const Text(
      'Select Image',
      style: ImageSelectionStyles.headerTitleStyle,
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Padding(
      padding: ImageSelectionStyles.optionsPadding,
      child: Column(
        children: [
          _buildCameraOption(context),
          const SizedBox(height: ImageSelectionStyles.optionTileSpacing),
          _buildGalleryOption(context),
          const SizedBox(height: ImageSelectionStyles.optionTileSpacing),
          _buildFilesOption(context),
          const SizedBox(height: ImageSelectionStyles.optionTileSpacing),
          _buildSearchOption(context),
          if (hasExistingImage) ...[
            const SizedBox(height: ImageSelectionStyles.optionTileSpacing),
            _buildRemoveOption(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCameraOption(BuildContext context) {
    return _buildOptionTile(
      context: context,
      icon: Icons.camera_alt,
      title: 'Take Photo',
      subtitle: 'Capture with your camera',
      onTap: () => _handleSourceSelection(context, GameImageSource.camera),
    );
  }

  Widget _buildGalleryOption(BuildContext context) {
    return _buildOptionTile(
      context: context,
      icon: Icons.photo_library,
      title: 'Photo Gallery',
      subtitle: 'Choose from your photos',
      onTap: () => _handleSourceSelection(context, GameImageSource.gallery),
    );
  }

  Widget _buildFilesOption(BuildContext context) {
    return _buildOptionTile(
      context: context,
      icon: Icons.folder,
      title: 'File Browser',
      subtitle: 'Choose from files',
      onTap: () => _handleSourceSelection(context, GameImageSource.files),
    );
  }

  Widget _buildSearchOption(BuildContext context) {
    return _buildOptionTile(
      context: context,
      icon: Icons.search,
      title: 'Search',
      subtitle: 'Find a cover image online',
      onTap: () => _handleSearchSelection(context),
    );
  }

  Widget _buildRemoveOption(BuildContext context) {
    return _buildOptionTile(
      context: context,
      icon: Icons.delete_outline,
      title: 'Remove Image',
      subtitle: 'Use placeholder instead',
      onTap: () => _handleRemoveImage(context),
      isDestructive: true,
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
      borderRadius: BorderRadius.circular(
        ImageSelectionStyles.optionTileBorderRadius,
      ),
      child: Container(
        padding: ImageSelectionStyles.optionTilePadding,
        decoration: ImageSelectionStyles.optionTileDecoration,
        child: Row(
          children: [
            _buildOptionIcon(icon, isDestructive),
            const SizedBox(width: ImageSelectionStyles.iconSpacing),
            Expanded(
              child: _buildOptionContent(title, subtitle, isDestructive),
            ),
            _buildArrowIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionIcon(IconData icon, bool isDestructive) {
    return Container(
      width: ImageSelectionStyles.iconContainerSize,
      height: ImageSelectionStyles.iconContainerSize,
      decoration: ImageSelectionStyles.getIconContainerDecoration(
        isDestructive: isDestructive,
      ),
      child: Icon(
        icon,
        color: ImageSelectionStyles.getIconColor(isDestructive: isDestructive),
        size: ImageSelectionStyles.iconSize,
      ),
    );
  }

  Widget _buildOptionContent(
    String title,
    String subtitle,
    bool isDestructive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ImageSelectionStyles.getOptionTitleStyle(
            isDestructive: isDestructive,
          ),
        ),
        const SizedBox(height: ImageSelectionStyles.titleSubtitleSpacing),
        Text(subtitle, style: ImageSelectionStyles.optionSubtitleStyle),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return const Icon(
      Icons.arrow_forward_ios,
      size: ImageSelectionStyles.arrowIconSize,
      color: ImageSelectionStyles.arrowIconColor,
    );
  }

  void _handleSourceSelection(BuildContext context, GameImageSource source) {
    Navigator.of(context).pop(source);
  }

  void _handleRemoveImage(BuildContext context) {
    Navigator.of(context).pop('remove');
  }

  void _handleSearchSelection(BuildContext context) {
    Navigator.of(context).pop('search');
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
      builder: (context) =>
          ImageSelectionBottomSheet(hasExistingImage: hasExistingImage),
    );
  }
}
