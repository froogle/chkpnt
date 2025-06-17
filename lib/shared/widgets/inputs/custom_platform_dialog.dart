import 'package:flutter/material.dart';
import 'package:chkpnt/utils/platform_utils.dart';
import 'android13_text_field_wrapper.dart';

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
      title: const Text('Enter Platform'),
      content: Android13TextFieldWrapper(
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter platform name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          onSubmitted: _handleSubmit,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _handleSubmit(_controller.text),
          child: const Text('Add'),
        ),
      ],
    );
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
