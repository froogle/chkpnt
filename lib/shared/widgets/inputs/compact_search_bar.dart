import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class CompactSearchBar extends ConsumerStatefulWidget {
  final String? hintText;

  const CompactSearchBar({super.key, this.hintText});

  @override
  ConsumerState<CompactSearchBar> createState() => _CompactSearchBarState();
}

class _CompactSearchBarState extends ConsumerState<CompactSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _hasText;

    return Container(
      height: InputStyles.compactSearchHeight,
      decoration: InputStyles.compactSearchBarDecoration,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
        onSubmitted: (_) {
          _dismissKeyboard();
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
    _dismissKeyboard();
  }
}
