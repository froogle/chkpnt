import 'package:flutter/material.dart';
import '../styles/styles.dart';

class PlatformFilterDropdown extends StatelessWidget {
  final String selectedPlatform;
  final List<String> platforms;
  final ValueChanged<String> onPlatformChanged;

  const PlatformFilterDropdown({
    super.key,
    required this.selectedPlatform,
    required this.platforms,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterDropdown(context),
      child: Container(
        height: MainScreenStyles.compactSearchHeight,
        padding: MainScreenStyles.filterDropdownButtonPadding,
        decoration: _buildButtonDecoration(),
        child: _buildButtonContent(),
      ),
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: MainScreenStyles.primaryAccentColor,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: MainScreenStyles.subtleShadowColor,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(selectedPlatform, style: MainScreenStyles.filterButtonTextStyle),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
      ],
    );
  }

  void _showFilterDropdown(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: _calculateMenuPosition(button, overlay),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: MainScreenStyles.subtleShadowColor,
      elevation: 12,
      shape: _buildMenuShape(),
      items: _buildMenuItems(),
    ).then(_handleMenuSelection);
  }

  RelativeRect _calculateMenuPosition(RenderBox button, RenderBox overlay) {
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 50), ancestor: overlay),
        button.localToGlobal(const Offset(200, 60), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  RoundedRectangleBorder _buildMenuShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE0D5C7), width: 1),
    );
  }

  List<PopupMenuItem<String>> _buildMenuItems() {
    return platforms.map((String platform) {
      final isSelected = platform == selectedPlatform;
      return PopupMenuItem<String>(
        value: platform,
        child: _buildMenuItem(platform, isSelected),
      );
    }).toList();
  }

  Widget _buildMenuItem(String platform, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: MainScreenStyles.filterDropdownItemPadding,
      decoration:
          isSelected
              ? MainScreenStyles.filterDropdownSelectedItemDecoration
              : const BoxDecoration(),
      child: Text(
        platform,
        style:
            isSelected
                ? MainScreenStyles.filterDropdownSelectedTextStyle
                : MainScreenStyles.filterDropdownUnselectedTextStyle,
      ),
    );
  }

  void _handleMenuSelection(String? selectedPlatform) {
    if (selectedPlatform != null && selectedPlatform != this.selectedPlatform) {
      onPlatformChanged(selectedPlatform);
    }
  }
}
