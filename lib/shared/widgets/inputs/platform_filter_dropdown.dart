import 'package:flutter/material.dart';
import 'package:chkpnt/styles/styles.dart';

class PlatformFilterDropdown extends StatelessWidget {
  static const String _allPlatformsLabel = 'All';

  final String? selectedPlatform;
  final List<String> platforms;
  final ValueChanged<String?> onPlatformChanged;

  const PlatformFilterDropdown({
    super.key,
    required this.selectedPlatform,
    required this.platforms,
    required this.onPlatformChanged,
  });

  List<String?> get _choices => [null, ...platforms];

  String _labelFor(String? platform) => platform ?? _allPlatformsLabel;

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
        Text(
          _labelFor(selectedPlatform),
          style: MainScreenStyles.filterButtonTextStyle,
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
      ],
    );
  }

  void _showFilterDropdown(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<int>(
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

  List<PopupMenuItem<int>> _buildMenuItems() {
    final choices = _choices;
    return [
      for (var index = 0; index < choices.length; index++)
        PopupMenuItem<int>(
          value: index,
          child: _buildMenuItem(
            _labelFor(choices[index]),
            choices[index] == selectedPlatform,
          ),
        ),
    ];
  }

  Widget _buildMenuItem(String label, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: MainScreenStyles.filterDropdownItemPadding,
      decoration:
          isSelected
              ? MainScreenStyles.filterDropdownSelectedItemDecoration
              : const BoxDecoration(),
      child: Text(
        label,
        style:
            isSelected
                ? MainScreenStyles.filterDropdownSelectedTextStyle
                : MainScreenStyles.filterDropdownUnselectedTextStyle,
      ),
    );
  }

  void _handleMenuSelection(int? index) {
    if (index == null) return;

    final platform = _choices[index];
    if (platform != selectedPlatform) {
      onPlatformChanged(platform);
    }
  }
}
