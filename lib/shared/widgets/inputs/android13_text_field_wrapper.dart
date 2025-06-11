import 'package:flutter/material.dart';
import '../../../utils/platform_utils.dart';
import '../../../styles/styles.dart';

/// Wrapper widget that adds Android 13 full screen text editor support
///
/// Android 13 introduces a full screen text editor that lacks a "Done" button
/// This wrapper adds a floating "Done" button when needed without interfering
/// with keyboard input or text field functionality
class Android13TextFieldWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDone;
  final bool enabled;

  const Android13TextFieldWrapper({
    super.key,
    required this.child,
    this.onDone,
    this.enabled = true,
  });

  @override
  State<Android13TextFieldWrapper> createState() =>
      _Android13TextFieldWrapperState();
}

class _Android13TextFieldWrapperState extends State<Android13TextFieldWrapper>
    with WidgetsBindingObserver {
  bool _showDoneButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Check if keyboard is visible by looking at bottom insets using MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = bottomInset > 0;

        setState(() {
          _showDoneButton = isKeyboardVisible;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show the wrapper on Android 13 when enabled
    if (!PlatformUtils.needsTextInputDoneButton || !widget.enabled) {
      return widget.child;
    }

    return _buildWrappedTextField();
  }

  Widget _buildWrappedTextField() {
    return Stack(
      children: [
        // The original text field - this ensures full keyboard functionality
        widget.child,
        // Positioned "Done" button that appears when keyboard is visible
        if (_showDoneButton) _buildDoneButton(),
      ],
    );
  }

  Widget _buildDoneButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: Android13TextFieldStyles.doneButtonMargin,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleDonePressed,
              borderRadius: Android13TextFieldStyles.doneButtonBorderRadius,
              child: Container(
                padding: Android13TextFieldStyles.doneButtonPadding,
                decoration: Android13TextFieldStyles.doneButtonDecoration,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      size: Android13TextFieldStyles.doneButtonIconSize,
                      color: Android13TextFieldStyles.doneButtonIconColour,
                    ),
                    const SizedBox(
                      width: Android13TextFieldStyles.doneButtonSpacing,
                    ),
                    Text(
                      'Done',
                      style: Android13TextFieldStyles.doneButtonTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDonePressed() {
    // Hide the button first
    if (mounted) {
      setState(() {
        _showDoneButton = false;
      });
    }

    // Unfocus the text field to dismiss the keyboard
    FocusScope.of(context).unfocus();

    // Call the callback if provided
    widget.onDone?.call();
  }
}
