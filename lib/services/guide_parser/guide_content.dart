import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class ContentBlock {
  final String content;
  final bool preformatted;

  ContentBlock({required this.content, this.preformatted = false});

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

  ContentSection({required this.title, required this.blocks});

  Map<String, dynamic> toJson() => {
    'title': title,
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };

  factory ContentSection.fromJson(Map<String, dynamic> json) => ContentSection(
    title: json['title'] as String,
    blocks: (json['blocks'] as List<dynamic>)
        .map((b) => ContentBlock.fromJson(b as Map<String, dynamic>))
        .toList(),
  );
}

class GuideContent {
  final String title;
  final String author;
  final String? url;
  final List<ContentSection> sections;

  GuideContent({
    required this.title,
    required this.author,
    this.url,
    required this.sections,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    if (url != null) 'url': url,
    'sections': sections.map((s) => s.toJson()).toList(),
  };

  factory GuideContent.fromJson(Map<String, dynamic> json) => GuideContent(
    title: json['title'] as String,
    author: json['author'] as String,
    url: json['url'] as String?,
    sections: (json['sections'] as List<dynamic>)
        .map((s) => ContentSection.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  String toJsonString({bool pretty = false}) {
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(toJson());
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

sealed class GuidePage {
  String get title;
  String get author;
  String? get url;
}

final class TextGuidePage implements GuidePage {
  final GuideContent content;

  const TextGuidePage(this.content);

  @override
  String get title => content.title;

  @override
  String get author => content.author;

  @override
  String? get url => content.url;
}

final class HtmlGuidePage implements GuidePage {
  @override
  final String title;

  @override
  final String author;

  @override
  final String? url;

  const HtmlGuidePage({required this.title, required this.author, this.url});
}

class GuideContentFetcher {
  static final _borderChars = RegExp(r'[|+\-_=\[\]<>\\\/\*#~`^]');
  static const _preformattedThreshold = 0.3;
  static const _typicalLineWidth = 70;

  GuidePage parseFromHtml(String html) {
    final document = html_parser.parse(html);
    final url = document
        .querySelector('link[rel="canonical"]')
        ?.attributes['href'];
    final (extractedTitle, extractedAuthor) = _extractTitleAndAuthor(document);
    final title =
        extractedTitle ??
        document.querySelector('h1.page-title')?.text.trim() ??
        'Unknown Guide';
    final author =
        extractedAuthor ??
        document.querySelector('.faq_author a')?.text.trim() ??
        'Unknown Author';

    final faqText = document.querySelector('#faqtext');
    if (faqText != null && faqText.querySelectorAll('pre').isNotEmpty) {
      return TextGuidePage(
        GuideContent(
          title: title,
          author: author,
          url: url,
          sections: _mergeConsecutivePreformattedBlocks(
            _parseAsciiSections(faqText),
          ),
        ),
      );
    }

    if (document.querySelector('#faqwrap') != null) {
      return HtmlGuidePage(title: title, author: author, url: url);
    }

    throw Exception('Could not find guide content');
  }

  (String?, String?) _extractTitleAndAuthor(Document document) {
    final h2Title = document.querySelector('h2.title');
    if (h2Title == null) return (null, null);

    final authorLink = h2Title.querySelector('a');
    final author = authorLink?.text.trim();

    String? title;
    if (authorLink != null) {
      final h2Html = h2Title.innerHtml;
      final authorLinkStart = h2Html.indexOf('<a');
      if (authorLinkStart > 0) {
        var extractedTitle = h2Html.substring(0, authorLinkStart).trim();
        if (extractedTitle.toLowerCase().endsWith(' by')) {
          extractedTitle = extractedTitle
              .substring(0, extractedTitle.length - 3)
              .trim();
        }
        title = extractedTitle;
      }
    }

    return (title, author);
  }

  List<ContentSection> _mergeConsecutivePreformattedBlocks(
    List<ContentSection> sections,
  ) {
    return sections.map((section) {
      final mergedBlocks = <ContentBlock>[];

      for (final block in section.blocks) {
        if (block.preformatted &&
            mergedBlocks.isNotEmpty &&
            mergedBlocks.last.preformatted) {
          final lastBlock = mergedBlocks.removeLast();
          mergedBlocks.add(
            ContentBlock(
              content: '${lastBlock.content}\n\n${block.content}',
              preformatted: true,
            ),
          );
        } else {
          mergedBlocks.add(block);
        }
      }

      return ContentSection(title: section.title, blocks: mergedBlocks);
    }).toList();
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
        if (_isSectionDivider(afterNext) &&
            nextLine.isNotEmpty &&
            !_isSectionDivider(nextLine) &&
            !_isTableLine(nextLine)) {
          _flushParagraphToBlocks(
            paragraphBuffer,
            currentBlocks,
            lastWasPreformatted,
          );

          if (currentBlocks.isNotEmpty) {
            sections.add(
              ContentSection(title: currentSectionTitle, blocks: currentBlocks),
            );
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
          _isCenteredText(trimmedLine) ||
          (_isPreformattedLine(trimmedLine) &&
              !_isSimpleDivider(trimmedLine.trim()));

      if (isPreformatted) {
        _flushParagraphToBlocks(paragraphBuffer, currentBlocks, false);
        if (lastWasPreformatted &&
            currentBlocks.isNotEmpty &&
            currentBlocks.last.preformatted) {
          final lastBlock = currentBlocks.removeLast();
          currentBlocks.add(
            ContentBlock(
              content: '${lastBlock.content}\n$trimmedLine',
              preformatted: true,
            ),
          );
        } else {
          currentBlocks.add(
            ContentBlock(content: trimmedLine, preformatted: true),
          );
        }
        lastWasPreformatted = true;
      } else if (strippedLine.isEmpty) {
        _flushParagraphToBlocks(
          paragraphBuffer,
          currentBlocks,
          lastWasPreformatted,
        );
        lastWasPreformatted = false;
      } else {
        if (paragraphBuffer.isNotEmpty) {
          final prevContent = paragraphBuffer.toString();
          if (_shouldJoinLines(prevContent, strippedLine) ||
              (line.startsWith(' ') && !_isNewListItem(strippedLine))) {
            paragraphBuffer.write(' ');
          } else if (_isNewListItem(strippedLine) ||
              _looksLikeNewParagraph(prevContent, strippedLine)) {
            _flushParagraphToBlocks(paragraphBuffer, currentBlocks, false);
          } else {
            paragraphBuffer.write(' ');
          }
        }
        paragraphBuffer.write(strippedLine);
        lastWasPreformatted = false;
      }
    }

    _flushParagraphToBlocks(
      paragraphBuffer,
      currentBlocks,
      lastWasPreformatted,
    );
    if (currentBlocks.isNotEmpty) {
      sections.add(
        ContentSection(title: currentSectionTitle, blocks: currentBlocks),
      );
    }

    return sections;
  }

  void _flushParagraphToBlocks(
    StringBuffer buffer,
    List<ContentBlock> blocks,
    bool preformatted,
  ) {
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

  bool _isPreformattedLine(String line) {
    if (line.isEmpty) return false;

    final borderCount = _borderChars.allMatches(line).length;
    final ratio = borderCount / line.length;

    return ratio >= _preformattedThreshold;
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

    if (RegExp(r'[=\-_~*#]{4,}$').hasMatch(trimmed)) return true;

    if (RegExp(r'^[=\-_~*#]{4,}').hasMatch(trimmed)) return true;

    return false;
  }

  bool _isSimpleDivider(String line) {
    final trimmed = line.trim();
    if (trimmed.length < 3) return false;

    if (trimmed.contains(' ')) return false;

    final firstChar = trimmed[0];
    if (!'-=_~*#'.contains(firstChar)) return false;

    return trimmed.split('').every((c) => c == firstChar);
  }

  bool _shouldJoinLines(String prevContent, String currentLine) {
    if (prevContent.isEmpty) return false;

    final lastChar = prevContent[prevContent.length - 1];
    final firstChar = currentLine.isNotEmpty ? currentLine[0] : '';

    if ('.!?:'.contains(lastChar)) {
      if (firstChar.isNotEmpty &&
          firstChar == firstChar.toLowerCase() &&
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
}
