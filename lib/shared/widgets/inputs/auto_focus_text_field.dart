import 'package:flutter/material.dart';

class AutoFocusTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final bool isAddMode;

  const AutoFocusTextField({
    super.key,
    required this.controller,
    this.style,
    this.decoration,
    this.maxLines,
    this.textCapitalization = TextCapitalization.none,
    this.isAddMode = false,
  });

  @override
  State<AutoFocusTextField> createState() => _AutoFocusTextFieldState();
}

class _AutoFocusTextFieldState extends State<AutoFocusTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    if (widget.isAddMode) {
      // Request focus and select all text after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
        widget.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.controller.text.length,
        );
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      style: widget.style,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
      textCapitalization: widget.textCapitalization,
    );
  }
}
