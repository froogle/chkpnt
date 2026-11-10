import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/shared/widgets/dialogs/confirm_delete_dialog.dart';
import 'package:chkpnt/providers/guide_provider.dart';
import 'package:chkpnt/screens/guide_reader/widgets/guide_web_reader_toolbar.dart';

class GuideWebReaderScreen extends ConsumerStatefulWidget {
  final GuideItem guide;
  final String url;
  final bool canDelete;

  const GuideWebReaderScreen({
    super.key,
    required this.guide,
    required this.url,
    this.canDelete = true,
  });

  @override
  ConsumerState<GuideWebReaderScreen> createState() =>
      _GuideWebReaderScreenState();
}

class _GuideWebReaderScreenState extends ConsumerState<GuideWebReaderScreen> {
  late final WebViewController _controller;
  bool _canGoBack = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _onPageStarted(String url) {
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _onPageFinished(String url) async {
    final canGoBack = await _controller.canGoBack();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _canGoBack = canGoBack;
    });
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Delete Guide',
      itemName: widget.guide.title,
    );

    if (confirmed && mounted) {
      await _deleteGuide();
    }
  }

  Future<void> _deleteGuide() async {
    try {
      await ref
          .read(guidesForGameProvider(widget.guide.gameId).notifier)
          .deleteGuide(widget.guide.id);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted: ${widget.guide.title}'),
            backgroundColor: AppColors.primaryPurple,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete guide'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildToolbar(),
            Expanded(child: _buildWebView()),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return GuideWebReaderToolbar(
      title: widget.guide.title,
      author: widget.guide.author,
      canGoBack: _canGoBack,
      onBack: _handleBack,
      onClose: _handleClose,
      onDelete: widget.canDelete ? _showDeleteConfirmation : null,
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(color: AppColors.primaryPurple),
          ),
      ],
    );
  }
}
