import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class ContentBlock {
  final String content;
  final bool preformatted;

  ContentBlock({
    required this.content,
    this.preformatted = false,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'preformatted': preformatted,
  };

  factory ContentBlock.fromJson(Map<String, dynamic> json) => ContentBlock(
    content: json['content'] as String,
    preformatted: json['preformatted'] as bool? ?? false,
  );
}

class ContentSection {
  final String title;
  final List<ContentBlock> blocks;

  ContentSection({
    required this.title,
    required this.blocks,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };

  factory ContentSection.fromJson(Map<String, dynamic> json) => ContentSection(
    title: json['title'] as String,
    blocks: (json['blocks'] as List)
        .map((b) => ContentBlock.fromJson(b as Map<String, dynamic>))
        .toList(),
  );
}

class GuideContent {
  final String title;
  final String author;
  final List<ContentSection> sections;
  final List<String> sectionUrls;

  GuideContent({
    required this.title,
    required this.author,
    required this.sections,
    this.sectionUrls = const [],
  });

  bool get isMultiPage => sectionUrls.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'sections': sections.map((s) => s.toJson()).toList(),
  };

  String toJsonString({bool pretty = false}) {
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(toJson());
  }

  Future<void> saveToFile(String filePath, {bool pretty = true}) async {
    final file = File(filePath);
    await file.writeAsString(toJsonString(pretty: pretty));
  }

  factory GuideContent.fromJson(Map<String, dynamic> json) => GuideContent(
    title: json['title'] as String,
    author: json['author'] as String,
    sections: (json['sections'] as List)
        .map((s) => ContentSection.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  factory GuideContent.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return GuideContent.fromJson(json);
  }

  String get cleanedText {
    final buffer = StringBuffer();
    for (final section in sections) {
      buffer.writeln('== ${section.title} ==');
      buffer.writeln();
      for (final block in section.blocks) {
        buffer.writeln(block.content);
        buffer.writeln();
      }
    }
    return buffer.toString().trim();
  }
}

class GuideContentFetcher {
  final http.Client _client;

  static const _typicalLineWidth = 70;

  static const _defaultHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
  };

  GuideContentFetcher({http.Client? client}) : _client = client ?? http.Client();

  Future<GuideContent> parseFromFile(String filePath, {String? title, String? author}) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }
    final html = await file.readAsString();
    return parseFromHtml(html, title: title, author: author);
  }

  GuideContent parseFromHtml(String html, {String? title, String? author}) {
    final document = html_parser.parse(html);

    final pageTitle = title ??
        document.querySelector('h1.page-title')?.text.trim() ??
        'Unknown Guide';

    final pageAuthor = author ??
        document.querySelector('.faq_author a')?.text.trim() ??
        'Unknown Author';

    final faqText = document.querySelector('#faqtext');
    final faqWrap = document.querySelector('#faqwrap');

    List<ContentSection> sections = [];

    if (faqText != null && faqText.querySelectorAll('pre').isNotEmpty) {
      sections = _parseAsciiSections(faqText);
    } else if (faqWrap != null) {
      sections = _parseHtmlSections(faqWrap);
    } else {
      throw Exception('Could not find guide content');
    }

    return GuideContent(
      title: pageTitle,
      author: pageAuthor,
      sections: sections,
    );
  }

  Future<GuideContent> fetchFromUrl(String url, [String? title, String? author, bool singlePageOnly = false]) async {
    final response = await _client.get(Uri.parse(url), headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch guide: ${response.statusCode}');
    }

    final document = html_parser.parse(response.body);

    final pageTitle = title ??
        document.querySelector('h1.page-title')?.text.trim() ??
        'Unknown Guide';

    final pageAuthor = author ??
        document.querySelector('.faq_author a')?.text.trim() ??
        'Unknown Author';

    final faqText = document.querySelector('#faqtext');
    final faqWrap = document.querySelector('#faqwrap');

    List<String> sectionUrls = [];
    List<ContentSection> sections = [];

    if (faqText != null && faqText.querySelectorAll('pre').isNotEmpty) {
      sections = _parseAsciiSections(faqText);
    } else if (faqWrap != null) {
      sectionUrls = _extractSectionUrls(document, url);
      sections = _parseHtmlSections(faqWrap);

      if (!singlePageOnly && sectionUrls.length > 1) {
        for (int i = 1; i < sectionUrls.length; i++) {
          try {
            final pageSections = await _fetchSingleSectionParsed(sectionUrls[i]);
            sections.addAll(pageSections);
          } catch (e) {
            continue;
          }
        }
      }
    } else {
      throw Exception('Could not find guide content');
    }

    return GuideContent(
      title: pageTitle,
      author: pageAuthor,
      sections: sections,
      sectionUrls: sectionUrls,
    );
  }

  Future<List<ContentSection>> _fetchSingleSectionParsed(String url) async {
    final response = await _client.get(Uri.parse(url), headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch section: ${response.statusCode}');
    }

    final document = html_parser.parse(response.body);
    final faqWrap = document.querySelector('#faqwrap');

    if (faqWrap == null) {
      return [];
    }

    return _parseHtmlSections(faqWrap);
  }

  List<String> _extractSectionUrls(dynamic document, String currentUrl) {
    final urls = <String>[];
    final baseUrl = 'https://gamefaqs.gamespot.com';

    final toc = document.querySelector('.ftoc');
    if (toc == null) return urls;

    final guideUrlMatch = RegExp(r'(/[^/]+/\d+-[^/]+/faqs/\d+)').firstMatch(currentUrl);
    final guideBase = guideUrlMatch?.group(1) ?? '';

    final links = toc.querySelectorAll('a[href]');
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null || href.isEmpty) continue;

      String fullUrl;
      if (href.startsWith('http')) {
        fullUrl = href;
      } else if (href.startsWith('/')) {
        fullUrl = '$baseUrl$href';
      } else {
        fullUrl = '$baseUrl$guideBase/$href';
      }

      if (!urls.contains(fullUrl)) {
        urls.add(fullUrl);
      }
    }

    return urls;
  }

  List<ContentSection> _parseHtmlSections(Element faqWrapElement) {
    final sections = <ContentSection>[];
    String currentSectionTitle = 'Content';
    List<ContentBlock> currentBlocks = [];

    for (final child in faqWrapElement.children) {
      if (child.classes.contains('ftoc')) continue;
      if (child.localName == 'img') continue;
      if (child.querySelector('img') != null && child.text.trim().isEmpty) continue;

      final tagName = child.localName;

      if (tagName == 'h1' || tagName == 'h2' || tagName == 'h3' || tagName == 'h4') {
        if (currentBlocks.isNotEmpty) {
          sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
          currentBlocks = [];
        }
        currentSectionTitle = child.text.trim();
      } else if (tagName == 'p') {
        final text = child.text.trim();
        if (text.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: text, preformatted: false));
        }
      } else if (tagName == 'ul' || tagName == 'ol') {
        final items = child.querySelectorAll('li');
        final listText = items.map((item) => '• ${item.text.trim()}').join('\n');
        if (listText.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: listText, preformatted: false));
        }
      } else if (tagName == 'table') {
        final tableText = _tableToText(child);
        if (tableText.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: tableText, preformatted: true));
        }
      } else if (tagName == 'pre') {
        final text = child.text.trim();
        if (text.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: text, preformatted: true));
        }
      } else {
        final text = child.text.trim();
        if (text.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: text, preformatted: false));
        }
      }
    }

    if (currentBlocks.isNotEmpty) {
      sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
    }

    return sections;
  }

  String _tableToText(Element table) {
    final buffer = StringBuffer();
    final rows = table.querySelectorAll('tr');

    for (final row in rows) {
      final cells = row.querySelectorAll('td, th');
      final cellTexts = cells.map((c) => c.text.trim()).toList();
      buffer.writeln(cellTexts.join(' | '));
    }

    return buffer.toString().trim();
  }

  List<ContentSection> _parseAsciiSections(Element faqTextElement) {
    final sections = <ContentSection>[];

    final buffer = StringBuffer();
    final preElements = faqTextElement.querySelectorAll('pre');
    for (final pre in preElements) {
      buffer.writeln(pre.text);
    }

    final rawText = buffer.toString();
    final lines = rawText.split('\n');

    String currentSectionTitle = 'Content';
    List<ContentBlock> currentBlocks = [];
    final paragraphBuffer = StringBuffer();
    bool lastWasPreformatted = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trimRight();
      final strippedLine = trimmedLine.trim();

      if (_isSectionDivider(trimmedLine) && i + 2 < lines.length) {
        final nextLine = lines[i + 1].trim();
        final afterNext = lines[i + 2].trimRight();
        if (_isSectionDivider(afterNext) && nextLine.isNotEmpty &&
            !_isSectionDivider(nextLine) && !_isTableLine(nextLine)) {
          _flushParagraphToBlocks(paragraphBuffer, currentBlocks, lastWasPreformatted);

          if (currentBlocks.isNotEmpty) {
            sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
            currentBlocks = [];
          }

          currentSectionTitle = _cleanSectionTitle(nextLine);
          i += 2;
          lastWasPreformatted = false;
          continue;
        }
      }

      final isPreformatted =
          _isTableLine(trimmedLine) ||
          _isComplexAsciiArt(trimmedLine) ||
          _isCenteredText(trimmedLine);

      if (isPreformatted) {
        _flushParagraphToBlocks(paragraphBuffer, currentBlocks, false);
        currentBlocks.add(ContentBlock(content: trimmedLine, preformatted: true));
        lastWasPreformatted = true;
      } else if (strippedLine.isEmpty) {
        _flushParagraphToBlocks(paragraphBuffer, currentBlocks, lastWasPreformatted);
        lastWasPreformatted = false;
      } else {
        if (paragraphBuffer.isNotEmpty) {
          final prevContent = paragraphBuffer.toString();
          if (_shouldJoinLines(prevContent, strippedLine) ||
              (line.startsWith(' ') && !_isNewListItem(strippedLine))) {
            paragraphBuffer.write(' ');
          } else if (_isNewListItem(strippedLine) || _looksLikeNewParagraph(prevContent, strippedLine)) {
            _flushParagraphToBlocks(paragraphBuffer, currentBlocks, false);
          } else {
            paragraphBuffer.write(' ');
          }
        }
        paragraphBuffer.write(strippedLine);
        lastWasPreformatted = false;
      }
    }

    _flushParagraphToBlocks(paragraphBuffer, currentBlocks, lastWasPreformatted);
    if (currentBlocks.isNotEmpty) {
      sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
    }

    return sections;
  }

  void _flushParagraphToBlocks(StringBuffer buffer, List<ContentBlock> blocks, bool preformatted) {
    if (buffer.isNotEmpty) {
      final text = _postProcess(buffer.toString());
      if (text.isNotEmpty) {
        blocks.add(ContentBlock(content: text, preformatted: preformatted));
      }
      buffer.clear();
    }
  }

  bool _isNewListItem(String line) {
    if (line.startsWith('-') || line.startsWith('*') || line.startsWith('•')) {
      return true;
    }
    if (RegExp(r'^\d+[\.\)\:]').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^[a-zA-Z][\.\)]').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\[\d+\]').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\[[a-zA-Z]\]').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^<\d+>').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^<[a-zA-Z]>').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\(\d+\)').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\([a-zA-Z]\)').hasMatch(line)) {
      return true;
    }
    return false;
  }

  bool _isCenteredText(String line) {
    final leadingSpaces = line.length - line.trimLeft().length;
    final content = line.trim();
    return leadingSpaces > 20 && content.length < 60 && content.isNotEmpty;
  }

  bool _looksLikeNewParagraph(String prevContent, String currentLine) {
    if (prevContent.isEmpty) return false;

    final lastChar = prevContent[prevContent.length - 1];

    if ('.!?'.contains(lastChar)) {
      if (currentLine.isNotEmpty &&
          currentLine[0] == currentLine[0].toUpperCase() &&
          RegExp(r'^[A-Z]').hasMatch(currentLine)) {
        if (prevContent.length < _typicalLineWidth - 5) {
          return true;
        }
      }
    }
    return false;
  }

  String _cleanSectionTitle(String title) {
    var cleaned = title.replaceAll(RegExp(r'^[\-=_~*#\s]+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'[\-=_~*#\s]+$'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\d+\)\s*'), '');
    return cleaned.isEmpty ? title.trim() : cleaned;
  }

  bool _isSectionDivider(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 40) return false;
    if (trimmed.contains('|')) return false;
    if (trimmed.contains(RegExp(r'[a-zA-Z]'))) return false;

    final dividerChars = RegExp(r'[\-=_~*#]').allMatches(trimmed).length;
    return dividerChars > trimmed.length * 0.8;
  }

  bool _isTableLine(String line) {
    final pipeCount = '|'.allMatches(line).length;
    return pipeCount >= 2;
  }

  bool _isComplexAsciiArt(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;

    if (_isSimpleDivider(trimmed)) return false;

    if (RegExp(r'\S {3,}\S').hasMatch(line)) return true;

    if (line.contains(RegExp(r'[|+][_\-=]+[|+]'))) return true;

    if (line.contains(RegExp(r'\\.*/'))) return true;
    if (line.contains(RegExp(r'/.*\\'))) return true;

    if (trimmed.startsWith('|') && trimmed.endsWith('|')) return true;
    if (trimmed.startsWith('+') && trimmed.endsWith('+')) return true;
    if (trimmed.startsWith('o-') && trimmed.endsWith('-o')) return true;

    if (line.contains('|__') || line.contains('__|')) return true;
    if (line.contains('|  ') || line.contains('  |')) return true;

    return false;
  }

  bool _isSimpleDivider(String line) {
    if (line.length < 3) return false;

    final chars = line.replaceAll(' ', '');
    if (chars.isEmpty) return false;

    final firstChar = chars[0];
    if (!'-=_~*#'.contains(firstChar)) return false;

    final matchCount = chars.split('').where((c) => c == firstChar).length;
    return matchCount > chars.length * 0.8;
  }

  bool _shouldJoinLines(String prevContent, String currentLine) {
    if (prevContent.isEmpty) return false;

    final lastChar = prevContent[prevContent.length - 1];
    final firstChar = currentLine.isNotEmpty ? currentLine[0] : '';

    if ('.!?:'.contains(lastChar)) {
      if (firstChar.isNotEmpty && firstChar == firstChar.toLowerCase() &&
          RegExp(r'[a-z]').hasMatch(firstChar)) {
        return true;
      }
      return false;
    }

    if (currentLine.startsWith(' ') ||
        currentLine.startsWith('-') ||
        currentLine.startsWith('*') ||
        currentLine.startsWith('•') ||
        currentLine.startsWith('[') ||
        currentLine.startsWith('(') ||
        currentLine.startsWith('<') ||
        RegExp(r'^\d+[\.\)\:]').hasMatch(currentLine) ||
        RegExp(r'^[a-zA-Z][\.\)]').hasMatch(currentLine)) {
      return false;
    }

    if (',;'.contains(lastChar)) return true;

    if (prevContent.length >= _typicalLineWidth - 10) {
      return true;
    }

    if (RegExp(r'[a-zA-Z0-9]$').hasMatch(prevContent)) {
      return true;
    }

    return false;
  }

  String _postProcess(String text) {
    var result = text.replaceAll(RegExp(r'\n{4,}'), '\n\n\n');

    result = result
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ');

    return result.trim();
  }

  void dispose() {
    _client.close();
  }
}
