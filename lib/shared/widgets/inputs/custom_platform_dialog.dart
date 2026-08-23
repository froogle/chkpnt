import 'package:flutter/material.dart';
import 'package:chkpnt/styles/input_styles.dart';
import 'package:chkpnt/utils/platform_utils.dart';

class CustomPlatformDialog extends StatefulWidget {
  final String initialValue;

  const CustomPlatformDialog({super.key, this.initialValue = ''});

  @override
  State<CustomPlatformDialog> createState() => _CustomPlatformDialogState();
}

class _CustomPlatformDialogState extends State<CustomPlatformDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomPlatformDialogStyles.backgroundColor,
      surfaceTintColor: CustomPlatformDialogStyles.surfaceTintColor,
      elevation: CustomPlatformDialogStyles.elevation,
      shape: CustomPlatformDialogStyles.dialogShape,
      title: _buildTitle(),
      content: _buildTextField(),
      actions: _buildActions(),
    );
  }

  Widget _buildTitle() {
    return const Text(
      CustomPlatformDialogStyles.titleText,
      style: CustomPlatformDialogStyles.titleTextStyle,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      style: CustomPlatformDialogStyles.inputTextStyle,
      cursorColor: CustomPlatformDialogStyles.cursorColor,
      decoration: CustomPlatformDialogStyles.inputDecoration,
      textCapitalization: TextCapitalization.words,
      autofocus: true,
      onSubmitted: _handleSubmit,
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: CustomPlatformDialogStyles.buttonStyle(
          CustomPlatformDialogStyles.cancelButtonColor,
        ),
        child: const Text(
          CustomPlatformDialogStyles.cancelButtonText,
          style: CustomPlatformDialogStyles.buttonTextStyle,
        ),
      ),
      TextButton(
        onPressed: () => _handleSubmit(_controller.text),
        style: CustomPlatformDialogStyles.buttonStyle(
          CustomPlatformDialogStyles.addButtonColor,
        ),
        child: const Text(
          CustomPlatformDialogStyles.addButtonText,
          style: CustomPlatformDialogStyles.buttonTextStyle,
        ),
      ),
    ];
  }

  void _handleSubmit(String value) {
    final platform = value.trim();

    if (platform.isNotEmpty) {
      final abbreviatedPlatform = PlatformUtils.abbreviatePlatformName(
        platform,
      );
      Navigator.of(context).pop(abbreviatedPlatform);
    } else {
      Navigator.of(context).pop();
    }
  }
}
