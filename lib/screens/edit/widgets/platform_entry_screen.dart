import 'package:flutter/material.dart';

class PlatformEntryScreen extends StatefulWidget {
  final String initialPlatform;

  const PlatformEntryScreen({super.key, this.initialPlatform = ''});

  @override
  State<PlatformEntryScreen> createState() => _PlatformEntryScreenState();
}

class _PlatformEntryScreenState extends State<PlatformEntryScreen> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPlatform);
    _focusNode = FocusNode();

    // Auto-focus after the screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      if (widget.initialPlatform.isEmpty) {
        // Select all text if there's initial text
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Enter Platform',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _canSave() ? _savePlatform : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _canSave() ? Colors.blue : Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Platform Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Nintendo Switch, PS5, PC',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}), // Refresh save button state
                onSubmitted: (_) => _canSave() ? _savePlatform() : null,
              ),
              const SizedBox(height: 16),
              Text(
                'The platform name will be automatically abbreviated if it matches a common platform.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSave() ? _savePlatform : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _canSave() ? Colors.blue : Colors.grey[300],
                    foregroundColor:
                        _canSave() ? Colors.white : Colors.grey[500],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _canSave() ? 2 : 0,
                  ),
                  child: const Text(
                    'Add Platform',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSave() {
    return _controller.text.trim().isNotEmpty;
  }

  void _savePlatform() {
    final platform = _controller.text.trim();
    if (platform.isNotEmpty) {
      Navigator.of(context).pop(platform);
    }
  }
}
