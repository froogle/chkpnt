import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/styles/styles.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class CompactSearchBar extends ConsumerStatefulWidget {
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
  ConsumerState<CompactSearchBar> createState() => _CompactSearchBarState();
}

class _CompactSearchBarState extends ConsumerState<CompactSearchBar>
    with WidgetsBindingObserver {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _keyboardWasVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Listen for keyboard visibility changes
    WidgetsBinding.instance.addObserver(this);

    // Sync controller with provider state
    final currentQuery = ref.read(searchQueryProvider);
    _controller.text = currentQuery;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // Check if keyboard visibility changed
    final bottomInset =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .viewInsets
            .bottom;
    final isKeyboardVisible = bottomInset > 0;

    if (_keyboardWasVisible && !isKeyboardVisible && _focusNode.hasFocus) {
      // Keyboard was visible, now it's gone, and we still have focus - unfocus
      _focusNode.unfocus();
    }

    // Update keyboard visibility state
    _keyboardWasVisible = isKeyboardVisible;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to search query changes to sync with controller
    final searchQuery = ref.watch(searchQueryProvider);

    // Update controller if provider state changes externally
    if (_controller.text != searchQuery) {
      _controller.text = searchQuery;
    }

    return Container(
      height: InputStyles.compactSearchHeight,
      decoration: InputStyles.compactSearchBarDecoration,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryText,
        ),
        decoration: _buildInputDecoration(searchQuery),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String currentQuery) {
    return InputStyles.compactSearchInputDecoration.copyWith(
      hintText: widget.hintText ?? 'Search games...',
      suffixIcon:
          currentQuery.isNotEmpty
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
    );
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clearQuery();
  }
}
