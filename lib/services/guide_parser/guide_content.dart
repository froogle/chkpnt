import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// A single content block within a section
class ContentBlock {
  final String content;
  final bool preformatted; // true = ASCII art, table, etc. - do not reflow

  ContentBlock({
    required this.content,
    this.preformatted = false,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'preformatted': preformatted,
  };
}

/// A section of the guide content (e.g., "Introduction", "Walkthrough", etc.)
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
}

class GuideContent {
  final String title;
  final String author;
  final String? url; // Canonical URL of the source document
  final List<ContentSection> sections;
  final List<String> sectionUrls; // For multi-page HTML guides

  GuideContent({
    required this.title,
    required this.author,
    this.url,
    required this.sections,
    this.sectionUrls = const [],
  });

  bool get isMultiPage => sectionUrls.isNotEmpty;

  /// Convert to JSON map
  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    if (url != null) 'url': url,
    'sections': sections.map((s) => s.toJson()).toList(),
  };

  /// Convert to JSON string
  String toJsonString({bool pretty = false}) {
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(toJson());
  }

  /// Save JSON to a file
  Future<void> saveToFile(String filePath, {bool pretty = true}) async {
    final file = File(filePath);
    await file.writeAsString(toJsonString(pretty: pretty));
  }

  /// Get plain text (for backwards compatibility)
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

  // Characters commonly used in ASCII art and tables
  static final _borderChars = RegExp(r'[|+\-_=\[\]<>\\\/\*#~`^]');

  // Line is likely preformatted if it has high density of border chars
  static const _preformattedThreshold = 0.3;

  // Typical line width for FAQs (authors wrap at ~75-80 chars)
  static const _typicalLineWidth = 70;

  // Default headers to avoid being blocked
  static const _defaultHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
  };

  GuideContentFetcher({http.Client? client}) : _client = client ?? http.Client();

  /// Parses guide content from a local HTML file.
  Future<GuideContent> parseFromFile(String filePath, {String? title, String? author}) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }
    final html = await file.readAsString();
    return parseFromHtml(html, title: title, author: author);
  }

  /// Parses guide content from local HTML string.
  GuideContent parseFromHtml(String html, {String? title, String? author}) {
    final document = html_parser.parse(html);

    // Extract canonical URL from <link rel="canonical" href="...">
    final canonicalUrl = document
        .querySelector('link[rel="canonical"]')
        ?.attributes['href'];

    // Extract title and author from h2.title if available
    // Format: "Guide and Walkthrough (PSP) by <a>AuthorName</a>"
    final (extractedTitle, extractedAuthor) = _extractTitleAndAuthor(document);

    final pageTitle = title ??
        extractedTitle ??
        document.querySelector('h1.page-title')?.text.trim() ??
        'Unknown Guide';

    final pageAuthor = author ??
        extractedAuthor ??
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

    // Post-process: merge consecutive preformatted blocks
    sections = _mergeConsecutivePreformattedBlocks(sections);

    return GuideContent(
      title: pageTitle,
      author: pageAuthor,
      url: canonicalUrl,
      sections: sections,
    );
  }

  /// Extract title and author from h2.title element
  /// Format: "Guide and Walkthrough (PSP) by <a>AuthorName</a>"
  (String?, String?) _extractTitleAndAuthor(Document document) {
    final h2Title = document.querySelector('h2.title');
    if (h2Title == null) return (null, null);

    // Get the author from the <a> tag inside h2.title
    final authorLink = h2Title.querySelector('a');
    final author = authorLink?.text.trim();

    // Get the title by extracting text before the <a> tag
    // We need to get the raw text content and strip " by " suffix
    String? title;
    if (authorLink != null) {
      // Get all text nodes before the <a> element
      final h2Html = h2Title.innerHtml;
      final authorLinkStart = h2Html.indexOf('<a');
      if (authorLinkStart > 0) {
        var extractedTitle = h2Html.substring(0, authorLinkStart).trim();
        // Remove trailing " by " (case insensitive)
        if (extractedTitle.toLowerCase().endsWith(' by')) {
          extractedTitle = extractedTitle.substring(0, extractedTitle.length - 3).trim();
        }
        title = extractedTitle;
      }
    }

    return (title, author);
  }

  /// Merge consecutive preformatted blocks within each section
  List<ContentSection> _mergeConsecutivePreformattedBlocks(List<ContentSection> sections) {
    return sections.map((section) {
      final mergedBlocks = <ContentBlock>[];

      for (final block in section.blocks) {
        if (block.preformatted &&
            mergedBlocks.isNotEmpty &&
            mergedBlocks.last.preformatted) {
          // Merge with previous preformatted block
          final lastBlock = mergedBlocks.removeLast();
          mergedBlocks.add(ContentBlock(
            content: '${lastBlock.content}\n\n${block.content}',
            preformatted: true,
          ));
        } else {
          mergedBlocks.add(block);
        }
      }

      return ContentSection(title: section.title, blocks: mergedBlocks);
    }).toList();
  }

  /// Fetches and cleans guide content from a URL.
  /// For HTML guides, automatically fetches all sections unless [singlePageOnly] is true.
  Future<GuideContent> fetchFromUrl(String url, [String? title, String? author, bool singlePageOnly = false]) async {
    final response = await _client.get(Uri.parse(url), headers: _defaultHeaders);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch guide: ${response.statusCode}');
    }

    final document = html_parser.parse(response.body);

    // Extract title from page if not provided
    final pageTitle = title ??
        document.querySelector('h1.page-title')?.text.trim() ??
        'Unknown Guide';

    // Extract author if not provided
    final pageAuthor = author ??
        document.querySelector('.faq_author a')?.text.trim() ??
        'Unknown Author';

    // Try ASCII format first (pre elements inside #faqtext)
    final faqText = document.querySelector('#faqtext');
    // Then try HTML format (#faqwrap)
    final faqWrap = document.querySelector('#faqwrap');

    List<String> sectionUrls = [];
    List<ContentSection> sections = [];

    if (faqText != null && faqText.querySelectorAll('pre').isNotEmpty) {
      // ASCII text format - single page
      sections = _parseAsciiSections(faqText);
    } else if (faqWrap != null) {
      // HTML format - may be multi-page
      sectionUrls = _extractSectionUrls(document, url);
      sections = _parseHtmlSections(faqWrap);

      // Fetch all sections unless explicitly told not to
      if (!singlePageOnly && sectionUrls.length > 1) {
        // Fetch remaining sections (skip first as we already have it)
        for (int i = 1; i < sectionUrls.length; i++) {
          try {
            final pageSections = await _fetchSingleSectionParsed(sectionUrls[i]);
            sections.addAll(pageSections);
          } catch (e) {
            // Skip failed sections but continue
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

  /// Fetches a single section's parsed content (used internally for multi-page guides)
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

    // Look for TOC links in ftoc div
    final toc = document.querySelector('.ftoc');
    if (toc == null) return urls;

    // Extract the base guide URL (without section)
    // e.g., /ps5/469495-clair-obscur-expedition-33/faqs/81883
    final guideUrlMatch = RegExp(r'(/[^/]+/\d+-[^/]+/faqs/\d+)').firstMatch(currentUrl);
    final guideBase = guideUrlMatch?.group(1) ?? '';

    final links = toc.querySelectorAll('a[href]');
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null || href.isEmpty) continue;

      // Build full URL
      String fullUrl;
      if (href.startsWith('http')) {
        fullUrl = href;
      } else if (href.startsWith('/')) {
        fullUrl = '$baseUrl$href';
      } else {
        // Relative to guide base (e.g., "characters" -> /faqs/81883/characters)
        fullUrl = '$baseUrl$guideBase/$href';
      }

      if (!urls.contains(fullUrl)) {
        urls.add(fullUrl);
      }
    }

    return urls;
  }

  /// Parse HTML guide into sections with blocks
  List<ContentSection> _parseHtmlSections(Element faqWrapElement) {
    final sections = <ContentSection>[];
    String currentSectionTitle = 'Content';
    List<ContentBlock> currentBlocks = [];

    for (final child in faqWrapElement.children) {
      // Skip TOC and images
      if (child.classes.contains('ftoc')) continue;
      if (child.localName == 'img') continue;
      if (child.querySelector('img') != null && child.text.trim().isEmpty) continue;

      final tagName = child.localName;

      if (tagName == 'h1' || tagName == 'h2' || tagName == 'h3' || tagName == 'h4') {
        // New section - save previous if it has content
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
        // Tables - convert to text but mark as preformatted
        final tableText = _tableToText(child);
        if (tableText.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: tableText, preformatted: true));
        }
      } else if (tagName == 'pre') {
        // Preformatted text
        final text = child.text.trim();
        if (text.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: text, preformatted: true));
        }
      } else {
        // Other elements - get text if any
        final text = child.text.trim();
        if (text.isNotEmpty) {
          currentBlocks.add(ContentBlock(content: text, preformatted: false));
        }
      }
    }

    // Don't forget the last section
    if (currentBlocks.isNotEmpty) {
      sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
    }

    return sections;
  }

  /// Convert HTML table to plain text
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

  /// Parse ASCII guide into sections with blocks
  List<ContentSection> _parseAsciiSections(Element faqTextElement) {
    final sections = <ContentSection>[];

    // Get all text from pre elements
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

      // Check if this is a section header (long divider lines followed by centered text)
      // Pattern: -------Title------- or ====Title==== style headers
      if (_isSectionDivider(trimmedLine) && i + 2 < lines.length) {
        final nextLine = lines[i + 1].trim();
        final afterNext = lines[i + 2].trimRight();
        if (_isSectionDivider(afterNext) && nextLine.isNotEmpty &&
            !_isSectionDivider(nextLine) && !_isTableLine(nextLine)) {
          // Found a section header pattern
          _flushParagraphToBlocks(paragraphBuffer, currentBlocks, lastWasPreformatted);

          if (currentBlocks.isNotEmpty) {
            sections.add(ContentSection(title: currentSectionTitle, blocks: currentBlocks));
            currentBlocks = [];
          }

          currentSectionTitle = _cleanSectionTitle(nextLine);
          i += 2; // Skip the header and closing divider
          lastWasPreformatted = false;
          continue;
        }
      }

      // Detect preformatted content
      // Note: Simple decorative dividers (~~~~, ----) are NOT preformatted
      // Only tables and complex ASCII art need preformatted=true
      // Note: We do NOT treat simple indented lines as preformatted - many old
      // GameFAQs guides use consistent indentation for all prose content
      final isPreformatted =
          _isTableLine(trimmedLine) ||
          _isComplexAsciiArt(trimmedLine) ||
          _isCenteredText(trimmedLine) ||
          (_isPreformattedLine(trimmedLine) && !_isSimpleDivider(trimmedLine.trim()));

      if (isPreformatted) {
        _flushParagraphToBlocks(paragraphBuffer, currentBlocks, false);
        // Combine consecutive preformatted lines into a single block
        if (lastWasPreformatted && currentBlocks.isNotEmpty && currentBlocks.last.preformatted) {
          final lastBlock = currentBlocks.removeLast();
          currentBlocks.add(ContentBlock(
            content: '${lastBlock.content}\n$trimmedLine',
            preformatted: true,
          ));
        } else {
          currentBlocks.add(ContentBlock(content: trimmedLine, preformatted: true));
        }
        lastWasPreformatted = true;
      } else if (strippedLine.isEmpty) {
        _flushParagraphToBlocks(paragraphBuffer, currentBlocks, lastWasPreformatted);
        lastWasPreformatted = false;
      } else {
        // Normal text - accumulate for paragraph
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

    // Flush remaining content
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
    // Bullet points
    if (line.startsWith('-') || line.startsWith('*') || line.startsWith('•')) {
      return true;
    }
    // Numbered lists: 1) or 1. or 1:
    if (RegExp(r'^\d+[\.\)\:]').hasMatch(line)) {
      return true;
    }
    // Letter lists: a) or A)
    if (RegExp(r'^[a-zA-Z][\.\)]').hasMatch(line)) {
      return true;
    }
    // Bracketed numbers/letters: [1] or [a] or [A]
    if (RegExp(r'^\[\d+\]').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\[[a-zA-Z]\]').hasMatch(line)) {
      return true;
    }
    // Angle bracketed: <1> or <a>
    if (RegExp(r'^<\d+>').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^<[a-zA-Z]>').hasMatch(line)) {
      return true;
    }
    // Parenthesized at start: (1) or (a) - note: 1) already handled above
    if (RegExp(r'^\(\d+\)').hasMatch(line)) {
      return true;
    }
    if (RegExp(r'^\([a-zA-Z]\)').hasMatch(line)) {
      return true;
    }
    return false;
  }

  bool _isCenteredText(String line) {
    // Detect centered text (lots of leading spaces, short content)
    final leadingSpaces = line.length - line.trimLeft().length;
    final content = line.trim();
    // If more than 20 leading spaces and content is relatively short, likely centered
    return leadingSpaces > 20 && content.length < 60 && content.isNotEmpty;
  }

  bool _looksLikeNewParagraph(String prevContent, String currentLine) {
    if (prevContent.isEmpty) return false;

    final lastChar = prevContent[prevContent.length - 1];

    // Previous line ended with sentence-ending punctuation
    if ('.!?'.contains(lastChar)) {
      // And current line starts with capital letter - likely new paragraph
      if (currentLine.isNotEmpty &&
          currentLine[0] == currentLine[0].toUpperCase() &&
          RegExp(r'^[A-Z]').hasMatch(currentLine)) {
        // But only if previous line was short (natural end) not wrapped
        if (prevContent.length < _typicalLineWidth - 5) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isPreformattedLine(String line) {
    if (line.isEmpty) return false;

    // Count border/special characters
    final borderCount = _borderChars.allMatches(line).length;
    final ratio = borderCount / line.length;

    return ratio >= _preformattedThreshold;
  }

  /// Clean up section title by removing surrounding dashes/decoration
  String _cleanSectionTitle(String title) {
    // Remove leading/trailing dashes, equals, spaces
    var cleaned = title.replaceAll(RegExp(r'^[\-=_~*#\s]+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'[\-=_~*#\s]+$'), '');

    // Also handle numbered sections like "1)" at the start
    cleaned = cleaned.replaceAll(RegExp(r'^\d+\)\s*'), '');

    return cleaned.isEmpty ? title.trim() : cleaned;
  }

  /// Strict section divider detection - for section headers
  /// Must be a long line of mostly dashes/equals, no pipes or letters
  bool _isSectionDivider(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 40) return false; // Must be long (ignoring leading spaces)
    if (trimmed.contains('|')) return false; // No table lines
    if (trimmed.contains(RegExp(r'[a-zA-Z]'))) return false; // No letters

    // Must be mostly dashes, equals, underscores (check trimmed content)
    final dividerChars = RegExp(r'[\-=_~*#]').allMatches(trimmed).length;
    return dividerChars > trimmed.length * 0.8;
  }

  bool _isTableLine(String line) {
    // Lines with multiple pipe characters (table cells)
    final pipeCount = '|'.allMatches(line).length;
    return pipeCount >= 2;
  }

  /// Detect complex ASCII art or tabular content that needs spacing preserved
  /// Simple decorative dividers (----, ~~~~, ====) are NOT complex
  bool _isComplexAsciiArt(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return false;

    // Simple single-character repeat dividers are NOT complex ASCII art
    // e.g., ~~~~~~~~, --------, ========, ********
    if (_isSimpleDivider(trimmed)) return false;

    // Lines with multiple consecutive spaces (3+) BETWEEN content indicate columnar alignment
    // e.g., "MEDICINE            100" or "Fire Sword      +10 ATK"
    // But NOT leading indentation like "    continued text here"
    // Pattern: non-space, then 3+ spaces, then non-space
    if (RegExp(r'\S {3,}\S').hasMatch(line)) return true;

    // Box-drawing patterns with mixed characters
    if (line.contains(RegExp(r'[|+][_\-=]+[|+]'))) return true;

    // Lines with diagonal patterns (maps, diagrams)
    if (line.contains(RegExp(r'\\.*/'))) return true;
    if (line.contains(RegExp(r'/.*\\'))) return true;

    // Lines bounded by pipes (table rows, box edges)
    if (trimmed.startsWith('|') && trimmed.endsWith('|')) return true;
    if (trimmed.startsWith('+') && trimmed.endsWith('+')) return true;
    if (trimmed.startsWith('o-') && trimmed.endsWith('-o')) return true;

    // Multi-character patterns that form structures
    if (line.contains('|__') || line.contains('__|')) return true;
    if (line.contains('|  ') || line.contains('  |')) return true;

    // Lines ending with a run of 4+ repeating decoration characters
    // e.g., "I) Walkthrough: {WAL} ====================="
    if (RegExp(r'[=\-_~*#]{4,}$').hasMatch(trimmed)) return true;

    // Lines starting with a run of 4+ repeating decoration characters
    // e.g., "===== Chapter 1 ====="
    if (RegExp(r'^[=\-_~*#]{4,}').hasMatch(trimmed)) return true;

    return false;
  }

  /// Detect simple decorative dividers that don't need preformatting
  /// Only matches pure dividers like "--------" or "========" with no internal spaces
  bool _isSimpleDivider(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 3) return false;

    // If line has internal spaces, it's NOT a simple divider (could be ASCII art)
    // e.g., "______ ______" is ASCII art, not a divider
    if (trimmed.contains(' ')) return false;

    final firstChar = trimmed[0];
    // Common divider characters
    if (!'-=_~*#'.contains(firstChar)) return false;

    // Must be entirely one character
    return trimmed.split('').every((c) => c == firstChar);
  }

  bool _shouldJoinLines(String prevContent, String currentLine) {
    if (prevContent.isEmpty) return false;

    final lastChar = prevContent[prevContent.length - 1];
    final firstChar = currentLine.isNotEmpty ? currentLine[0] : '';

    // Don't join if previous line ends with sentence-ending punctuation
    // followed by what looks like a new sentence/paragraph
    if ('.!?:'.contains(lastChar)) {
      // But DO join if current line starts with lowercase (continuation)
      if (firstChar.isNotEmpty && firstChar == firstChar.toLowerCase() &&
          RegExp(r'[a-z]').hasMatch(firstChar)) {
        return true;
      }
      return false;
    }

    // Don't join if current line starts with special formatting or list markers
    if (currentLine.startsWith(' ') ||
        currentLine.startsWith('-') ||
        currentLine.startsWith('*') ||
        currentLine.startsWith('•') ||
        currentLine.startsWith('[') ||  // Bracketed list items [1], [a], etc.
        currentLine.startsWith('(') ||  // Parenthesized list items (1), (a), etc.
        currentLine.startsWith('<') ||  // Angle bracketed <1>, <a>, etc.
        RegExp(r'^\d+[\.\)\:]').hasMatch(currentLine) ||  // 1. 1) 1:
        RegExp(r'^[a-zA-Z][\.\)]').hasMatch(currentLine)) {  // a. a)
      return false;
    }

    // Join if previous line was artificially wrapped (ends mid-word or with comma)
    if (',;'.contains(lastChar)) return true;

    // Join if previous line appears to be wrapped at typical width
    // and doesn't end with terminal punctuation
    if (prevContent.length >= _typicalLineWidth - 10) {
      return true;
    }

    // Join if line ends with a word (no punctuation)
    if (RegExp(r'[a-zA-Z0-9]$').hasMatch(prevContent)) {
      return true;
    }

    return false;
  }

  String _postProcess(String text) {
    // Clean up excessive blank lines (max 2 consecutive)
    var result = text.replaceAll(RegExp(r'\n{4,}'), '\n\n\n');

    // Decode HTML entities
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
