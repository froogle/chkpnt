import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/styles.dart';
import '../providers/ui_state_provider.dart';

class CompactSearchBar extends ConsumerWidget {
  final String? hintText;
  final VoidCallback? onTap;
  final bool readOnly;

  const CompactSearchBar({
    super.key,
    this.hintText,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MainScreenStyles.compactSearchHeight,
      decoration: MainScreenStyles.compactSearchBarDecoration,
      child: TextField(
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
        onTap: onTap,
        readOnly: readOnly,
        decoration: _buildInputDecoration(),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hintText ?? 'Search games...',
      prefixIcon: const Icon(Icons.search, color: Color(0xFF9D8463), size: 20),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }
}
