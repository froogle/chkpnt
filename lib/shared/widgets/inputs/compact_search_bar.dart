import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/styles.dart';
import '../../../providers/ui_state_provider.dart';

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
      height: InputStyles.compactSearchHeight,
      decoration: InputStyles.compactSearchBarDecoration,
      child: TextField(
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
        onTap: onTap,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        decoration: _buildInputDecoration(),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputStyles.compactSearchInputDecoration.copyWith(
      hintText: hintText ?? 'Search games...',
    );
  }
}
