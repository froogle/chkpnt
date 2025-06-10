import 'package:flutter/material.dart';
import '../../../styles/platform_entry_styles.dart';

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
    _initializeControllers();
    _setupAutoFocus();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlatformEntryStyles.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _initializeControllers() {
    _controller = TextEditingController(text: widget.initialPlatform);
    _focusNode = FocusNode();
  }

  void _setupAutoFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      if (widget.initialPlatform.isEmpty) {
        _selectAllText();
      }
    });
  }

  void _selectAllText() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _disposeControllers() {
    _controller.dispose();
    _focusNode.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: PlatformEntryStyles.appBarBackgroundColor,
      elevation: PlatformEntryStyles.appBarElevation,
      surfaceTintColor: PlatformEntryStyles.appBarSurfaceTintColor,
      leading: _buildCloseButton(),
      title: _buildAppBarTitle(),
      actions: [_buildSaveButton()],
    );
  }

  Widget _buildCloseButton() {
    return IconButton(
      icon: const Icon(Icons.close, color: PlatformEntryStyles.appBarIconColor),
      onPressed: _closeScreen,
    );
  }

  Widget _buildAppBarTitle() {
    return const Text(
      'Enter Platform',
      style: PlatformEntryStyles.appBarTitleStyle,
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
      onPressed: _canSave() ? _savePlatform : null,
      child: Text(
        'Save',
        style: PlatformEntryStyles.saveButtonTextStyleWithColor(_canSave()),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Padding(
        padding: PlatformEntryStyles.screenPadding,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(),
        const SizedBox(height: PlatformEntryStyles.fieldLabelSpacing),
        _buildTextField(),
        const SizedBox(height: PlatformEntryStyles.helpTextSpacing),
        _buildHelpText(),
        const Spacer(),
        _buildPrimaryButton(),
      ],
    );
  }

  Widget _buildFieldLabel() {
    return const Text(
      'Platform Name',
      style: PlatformEntryStyles.fieldLabelStyle,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: PlatformEntryStyles.textInputStyle,
      decoration: PlatformEntryStyles.textInputDecoration,
      textCapitalization: TextCapitalization.words,
      onChanged: _handleTextChanged,
      onSubmitted: _handleTextSubmitted,
    );
  }

  Widget _buildHelpText() {
    return const Text(
      PlatformEntryStyles.helpText,
      style: PlatformEntryStyles.helpTextStyle,
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _canSave() ? _savePlatform : null,
        style: PlatformEntryStyles.primaryButtonStyle(_canSave()),
        child: const Text(
          PlatformEntryStyles.primaryButtonText,
          style: PlatformEntryStyles.primaryButtonTextStyle,
        ),
      ),
    );
  }

  void _handleTextChanged(String value) {
    setState(() {}); // Refresh save button state
  }

  void _handleTextSubmitted(String value) {
    if (_canSave()) {
      _savePlatform();
    }
  }

  bool _canSave() {
    return _controller.text.trim().isNotEmpty;
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  void _savePlatform() {
    final platform = _trimmedPlatformText();
    if (platform.isNotEmpty) {
      Navigator.of(context).pop(platform);
    }
  }

  String _trimmedPlatformText() {
    return _controller.text.trim();
  }
}
