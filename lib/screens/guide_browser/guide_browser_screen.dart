import 'dart:async';
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
import 'package:chkpnt/screens/guide_browser/widgets/multi_page_guide_dialog.dart';
import 'package:chkpnt/screens/guide_browser/widgets/multi_page_progress_modal.dart';

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
  bool _isMultiPageDownloadCancelled = false;
  String? _originalUrl;

  static const String _gameFaqsHomeUrl = 'https://gamefaqs.gamespot.com';
  static const Duration _pageLoadDelay = Duration(seconds: 1);
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
      _originalUrl = await _controller.currentUrl();
      final html = await _extractHtmlFromWebView();
      final fetcher = GuideContentFetcher();
      final guideContent = fetcher.parseFromHtml(html);

      if (guideContent.isMultiPage && mounted) {
        final action = await MultiPageGuideDialog.show(
          context,
          guideTitle: guideContent.title,
          pageCount: guideContent.sectionUrls.length,
        );

        if (!mounted) return;

        switch (action) {
          case MultiPageGuideAction.downloadFull:
            await _downloadFullGuide(guideContent);
          case MultiPageGuideAction.saveCurrentPage:
            await _saveCurrentPageOnly(guideContent);
          case MultiPageGuideAction.cancel:
          case null:
            setState(() {
              _isSaving = false;
            });
        }
      } else {
        await _saveSinglePageGuide(guideContent);
      }
    } catch (e) {
      _handleSaveError();
    }
  }

  Future<void> _saveSinglePageGuide(GuideContent guideContent) async {
    try {
      final storageService = ref.read(guideStorageServiceProvider);
      final jsonContent = guideContent.toJsonString(pretty: true);
      final fileName = await storageService.saveGuideJson(jsonContent);

      final guideItem = GuideItem.create(
        gameId: widget.gameId,
        title: guideContent.title,
        author: guideContent.author,
        fileName: fileName,
        sourceUrl: guideContent.url,
      );

      await ref
          .read(guidesForGameProvider(widget.gameId).notifier)
          .addGuide(guideItem);

      if (mounted) {
        _showSuccessAndClose(guideContent.title);
      }
    } catch (e) {
      _handleSaveError();
    }
  }

  Future<void> _saveCurrentPageOnly(GuideContent guideContent) async {
    try {
      final singlePageGuide = GuideContent(
        title: guideContent.title,
        author: guideContent.author,
        url: guideContent.url,
        sections: guideContent.sections,
        sectionUrls: const [],
      );

      final storageService = ref.read(guideStorageServiceProvider);
      final jsonContent = singlePageGuide.toJsonString(pretty: true);
      final fileName = await storageService.saveGuideJson(jsonContent);

      final guideItem = GuideItem.create(
        gameId: widget.gameId,
        title: singlePageGuide.title,
        author: singlePageGuide.author,
        fileName: fileName,
        sourceUrl: singlePageGuide.url,
      );

      await ref
          .read(guidesForGameProvider(widget.gameId).notifier)
          .addGuide(guideItem);

      if (mounted) {
        _showSuccessAndClose(singlePageGuide.title);
      }
    } catch (e) {
      _handleSaveError();
    }
  }

  List<String> _getUniqueUrlsToFetch(List<String> sectionUrls) {
    if (sectionUrls.isEmpty) return [];

    final firstUrl = sectionUrls.first;
    final seen = <String>{firstUrl};
    final uniqueUrls = <String>[];

    for (int i = 1; i < sectionUrls.length; i++) {
      final url = sectionUrls[i];
      if (!seen.contains(url)) {
        seen.add(url);
        uniqueUrls.add(url);
      }
    }

    return uniqueUrls;
  }

  Future<void> _downloadFullGuide(GuideContent initialContent) async {
    _isMultiPageDownloadCancelled = false;

    final urlsToFetch = _getUniqueUrlsToFetch(initialContent.sectionUrls);
    final totalPages = urlsToFetch.length + 1;

    final progressController = MultiPageProgressController(
      context: context,
      guideTitle: initialContent.title,
      totalPages: totalPages,
      onCancel: () {
        _isMultiPageDownloadCancelled = true;
      },
    );

    progressController.show();
    progressController.updateProgress(1);

    try {
      var json = initialContent.toJson();
      final fetcher = GuideContentFetcher();

      for (int i = 0; i < urlsToFetch.length; i++) {
        if (_isMultiPageDownloadCancelled) {
          progressController.dismiss();
          await _navigateToOriginalUrl();
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }
          return;
        }

        final url = urlsToFetch[i];
        await _controller.loadRequest(Uri.parse(url));

        await _waitForPageLoad();
        await Future.delayed(_pageLoadDelay);

        if (_isMultiPageDownloadCancelled) {
          progressController.dismiss();
          await _navigateToOriginalUrl();
          if (mounted) {
            setState(() {
              _isSaving = false;
            });
          }
          return;
        }

        final pageHtml = await _extractHtmlFromWebView();
        final result = fetcher.parseFromHtml(
          pageHtml,
          isFirstPage: false,
          previousJson: json,
        );
        json = result.toJson();

        progressController.updateProgress(i + 2);
      }

      progressController.dismiss();

      final completeGuide = GuideContent.fromJson(json);
      final storageService = ref.read(guideStorageServiceProvider);
      final jsonContent = completeGuide.toJsonString(pretty: true);
      final fileName = await storageService.saveGuideJson(jsonContent);

      final guideItem = GuideItem.create(
        gameId: widget.gameId,
        title: completeGuide.title,
        author: completeGuide.author,
        fileName: fileName,
        sourceUrl: completeGuide.url,
      );

      await ref
          .read(guidesForGameProvider(widget.gameId).notifier)
          .addGuide(guideItem);

      if (mounted) {
        _showSuccessAndClose(completeGuide.title);
      }
    } catch (e) {
      progressController.dismiss();
      await _navigateToOriginalUrl();
      _handleSaveError();
    }
  }

  Future<void> _waitForPageLoad() async {
    await Future.any([
      _waitForPageFinished(),
      Future.delayed(const Duration(seconds: 30)),
    ]);
  }

  Future<void> _waitForPageFinished() async {
    final completer = Completer<void>();

    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (completer.isCompleted) {
        timer.cancel();
        return;
      }

      if (!_isLoading) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {},
    );
  }

  Future<void> _navigateToOriginalUrl() async {
    if (_originalUrl != null) {
      await _controller.loadRequest(Uri.parse(_originalUrl!));
      await _waitForPageFinished();
    }
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
