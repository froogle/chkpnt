import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class CompactSearchBar extends ConsumerStatefulWidget {
  final String? hintText;

  const CompactSearchBar({
    super.key,
    this.hintText,
  });

  @override
  ConsumerState<CompactSearchBar> createState() => _CompactSearchBarState();
}

class _CompactSearchBarState extends ConsumerState<CompactSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final hasText = searchQuery.isNotEmpty;

    return Container(
      height: InputStyles.compactSearchHeight,
      decoration: InputStyles.compactSearchBarDecoration,
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
        onSubmitted: (_) {
          FocusScope.of(context).unfocus();
        },
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        decoration: InputStyles.compactSearchInputDecoration.copyWith(
          hintText: widget.hintText ?? 'Search games...',
          suffixIcon: hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: AppColors.primaryPurple.withValues(alpha: 0.7),
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                )
              : null,
        ),
      ),
    );
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clearQuery();
    FocusScope.of(context).unfocus();
  }
}
