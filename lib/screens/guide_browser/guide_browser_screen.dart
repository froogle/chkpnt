import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';
import 'package:chkpnt/services/guide_storage_service.dart'
    show guideStorageServiceProvider;
import 'package:chkpnt/providers/guide_provider.dart';

class GuideBrowserScreen extends ConsumerStatefulWidget {
  final GameId gameId;
  final String gameTitle;

  const GuideBrowserScreen({
    super.key,
    required this.gameId,
    required this.gameTitle,
  });

  @override
  ConsumerState<GuideBrowserScreen> createState() => _GuideBrowserScreenState();
}

class _GuideBrowserScreenState extends ConsumerState<GuideBrowserScreen> {
  late final WebViewController _controller;
  bool _canGoBack = false;
  bool _isOnGuidePage = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String _currentUrl = _gameFaqsHomeUrl;

  static const String _gameFaqsHomeUrl = 'https://gamefaqs.gamespot.com';
  static final RegExp _guideUrlPattern = RegExp(
    r'gamefaqs\.gamespot\.com/[^/]+/\d+-[^/]+/faqs/\d+',
  );

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: _onPageStarted,
              onPageFinished: _onPageFinished,
              onNavigationRequest: _onNavigationRequest,
            ),
          )
          ..loadRequest(Uri.parse(_gameFaqsHomeUrl));
  }

  void _onPageStarted(String url) {
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _onPageFinished(String url) async {
    final canGoBack = await _controller.canGoBack();
    final isGuidePage = _guideUrlPattern.hasMatch(url);

    setState(() {
      _isLoading = false;
      _canGoBack = canGoBack;
      _isOnGuidePage = isGuidePage;
      _currentUrl = url;
    });
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    return NavigationDecision.navigate;
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  Future<String> _extractHtmlFromWebView() async {
    final htmlResult = await _controller.runJavaScriptReturningResult(
      'document.documentElement.outerHTML',
    );

    String html = htmlResult.toString();
    if (html.startsWith('"') && html.endsWith('"')) {
      html = html.substring(1, html.length - 1);
    }
    return _unescapeJavaScriptString(html);
  }

  Future<void> _handleSaveGuide() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final html = await _extractHtmlFromWebView();
      final page = GuideContentFetcher().parseFromHtml(html);
      final guideItem = switch (page) {
        TextGuidePage(:final content) => await _createTextGuide(content),
        HtmlGuidePage() => GuideItem.createHtmlLink(
          gameId: widget.gameId,
          title: page.title,
          author: page.author,
          sourceUrl: page.url ?? _currentUrl,
        ),
      };

      await ref
          .read(guidesForGameProvider(widget.gameId).notifier)
          .addGuide(guideItem);

      if (mounted) {
        _showSuccessAndClose(page.title);
      }
    } catch (e) {
      _handleSaveError();
    }
  }

  Future<GuideItem> _createTextGuide(GuideContent content) async {
    final storageService = ref.read(guideStorageServiceProvider);
    final fileName = await storageService.saveGuideJson(
      content.toJsonString(pretty: true),
    );

    return GuideItem.create(
      gameId: widget.gameId,
      title: content.title,
      author: content.author,
      fileName: fileName,
      sourceUrl: content.url,
    );
  }

  void _showSuccessAndClose(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: $title'),
        backgroundColor: AppColors.primaryPurple,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  void _handleSaveError() {
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Unable to save this guide. Try finding another.',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [_buildToolbar(), Expanded(child: _buildWebView())],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _canGoBack ? _handleBack : null,
            icon: Icon(
              Icons.arrow_back,
              color: _canGoBack ? AppColors.primaryText : AppColors.expandIcon,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Find Guide',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  widget.gameTitle,
                  style: TextStyle(fontSize: 12, color: AppColors.expandIcon),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (_isOnGuidePage) _buildSaveButton(),
          IconButton(
            onPressed: _handleClose,
            icon: Icon(Icons.cancel, color: AppColors.expandIcon, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isSaving ? null : _handleSaveGuide,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: _isSaving ? null : AppGradients.buttonGradient,
          color: _isSaving ? AppColors.expandIcon : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSaving)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(Icons.save_alt, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              _isSaving ? 'Saving...' : 'Save Guide',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
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

  String _unescapeJavaScriptString(String input) {
    final buffer = StringBuffer();
    var i = 0;

    while (i < input.length) {
      if (input[i] == '\\' && i + 1 < input.length) {
        final nextChar = input[i + 1];
        switch (nextChar) {
          case 'n':
            buffer.write('\n');
            i += 2;
          case 't':
            buffer.write('\t');
            i += 2;
          case 'r':
            buffer.write('\r');
            i += 2;
          case '"':
            buffer.write('"');
            i += 2;
          case "'":
            buffer.write("'");
            i += 2;
          case '\\':
            buffer.write('\\');
            i += 2;
          case '/':
            buffer.write('/');
            i += 2;
          case 'u':
            if (i + 5 < input.length) {
              final hexCode = input.substring(i + 2, i + 6);
              final codePoint = int.tryParse(hexCode, radix: 16);
              if (codePoint != null) {
                buffer.write(String.fromCharCode(codePoint));
                i += 6;
              } else {
                buffer.write(input[i]);
                i++;
              }
            } else {
              buffer.write(input[i]);
              i++;
            }
          default:
            buffer.write(input[i]);
            i++;
        }
      } else {
        buffer.write(input[i]);
        i++;
      }
    }

    return buffer.toString();
  }
}
