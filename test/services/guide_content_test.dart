import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/services/guide_parser/guide_content.dart';

void main() {
  group('ContentBlock', () {
    test('toJson returns correct map', () {
      final block = ContentBlock(content: 'Test content', preformatted: true);
      final json = block.toJson();

      expect(json['content'], 'Test content');
      expect(json['preformatted'], true);
    });

    test('fromJson creates correct instance', () {
      final json = {'content': 'Test content', 'preformatted': true};
      final block = ContentBlock.fromJson(json);

      expect(block.content, 'Test content');
      expect(block.preformatted, true);
    });

    test('fromJson defaults preformatted to false when missing', () {
      final json = {'content': 'Test content'};
      final block = ContentBlock.fromJson(json);

      expect(block.content, 'Test content');
      expect(block.preformatted, false);
    });
  });

  group('ContentSection', () {
    test('toJson returns correct map', () {
      final section = ContentSection(
        title: 'Section Title',
        blocks: [
          ContentBlock(content: 'Block 1', preformatted: false),
          ContentBlock(content: 'Block 2', preformatted: true),
        ],
      );
      final json = section.toJson();

      expect(json['title'], 'Section Title');
      expect(json['blocks'], isA<List>());
      expect((json['blocks'] as List).length, 2);
    });

    test('fromJson creates correct instance', () {
      final json = {
        'title': 'Section Title',
        'blocks': [
          {'content': 'Block 1', 'preformatted': false},
          {'content': 'Block 2', 'preformatted': true},
        ],
      };
      final section = ContentSection.fromJson(json);

      expect(section.title, 'Section Title');
      expect(section.blocks.length, 2);
      expect(section.blocks[0].content, 'Block 1');
      expect(section.blocks[1].preformatted, true);
    });
  });

  group('GuideContent', () {
    test('isMultiPage returns true when sectionUrls is not empty', () {
      final guide = GuideContent(
        title: 'Test Guide',
        author: 'Test Author',
        sections: [],
        sectionUrls: ['http://example.com/page1', 'http://example.com/page2'],
      );

      expect(guide.isMultiPage, true);
    });

    test('isMultiPage returns false when sectionUrls is empty', () {
      final guide = GuideContent(
        title: 'Test Guide',
        author: 'Test Author',
        sections: [],
        sectionUrls: const [],
      );

      expect(guide.isMultiPage, false);
    });

    test('toJson includes sectionUrls', () {
      final guide = GuideContent(
        title: 'Test Guide',
        author: 'Test Author',
        url: 'http://example.com',
        sections: [
          ContentSection(
            title: 'Section 1',
            blocks: [ContentBlock(content: 'Content', preformatted: false)],
          ),
        ],
        sectionUrls: ['http://example.com/page1'],
      );
      final json = guide.toJson();

      expect(json['title'], 'Test Guide');
      expect(json['author'], 'Test Author');
      expect(json['url'], 'http://example.com');
      expect(json['sections'], isA<List>());
      expect(json['sectionUrls'], ['http://example.com/page1']);
    });

    test('fromJson creates correct instance', () {
      final json = {
        'title': 'Test Guide',
        'author': 'Test Author',
        'url': 'http://example.com',
        'sections': [
          {
            'title': 'Section 1',
            'blocks': [
              {'content': 'Content', 'preformatted': false},
            ],
          },
        ],
        'sectionUrls': ['http://example.com/page1', 'http://example.com/page2'],
      };
      final guide = GuideContent.fromJson(json);

      expect(guide.title, 'Test Guide');
      expect(guide.author, 'Test Author');
      expect(guide.url, 'http://example.com');
      expect(guide.sections.length, 1);
      expect(guide.sectionUrls.length, 2);
    });

    test('fromJson handles missing sectionUrls', () {
      final json = {
        'title': 'Test Guide',
        'author': 'Test Author',
        'sections': [],
      };
      final guide = GuideContent.fromJson(json);

      expect(guide.sectionUrls, isEmpty);
      expect(guide.isMultiPage, false);
    });

    test('toJsonString produces valid JSON', () {
      final guide = GuideContent(
        title: 'Test',
        author: 'Author',
        sections: [],
      );
      final jsonString = guide.toJsonString();

      expect(jsonString, contains('"title":"Test"'));
      expect(jsonString, contains('"author":"Author"'));
    });

    test('cleanedText produces readable output', () {
      final guide = GuideContent(
        title: 'Test Guide',
        author: 'Author',
        sections: [
          ContentSection(
            title: 'Introduction',
            blocks: [
              ContentBlock(content: 'Welcome to the guide.', preformatted: false),
            ],
          ),
        ],
      );
      final text = guide.cleanedText;

      expect(text, contains('== Introduction =='));
      expect(text, contains('Welcome to the guide.'));
    });
  });

  group('GuideContentFetcher', () {
    late GuideContentFetcher fetcher;

    setUp(() {
      fetcher = GuideContentFetcher();
    });

    group('parseFromHtml - ASCII guides', () {
      test('parses simple ASCII guide', () {
        const html = '''
          <html>
            <head>
              <link rel="canonical" href="http://example.com/guide">
            </head>
            <body>
              <h2 class="title">Test Guide (PS5) by <a href="#">TestAuthor</a></h2>
              <div id="faqtext">
                <pre>
=======================================
Introduction
=======================================

This is a test guide.

It has multiple paragraphs.
                </pre>
              </div>
            </body>
          </html>
        ''';

        final content = fetcher.parseFromHtml(html);

        expect(content.title, 'Test Guide (PS5)');
        expect(content.author, 'TestAuthor');
        expect(content.url, 'http://example.com/guide');
        expect(content.sections.isNotEmpty, true);
        expect(content.sectionUrls, isEmpty);
        expect(content.isMultiPage, false);
      });

      test('handles ASCII guide without canonical URL', () {
        const html = '''
          <html>
            <body>
              <h1 class="page-title">Fallback Title</h1>
              <div id="faqtext">
                <pre>Content here</pre>
              </div>
            </body>
          </html>
        ''';

        final content = fetcher.parseFromHtml(html);

        expect(content.url, isNull);
        expect(content.title, 'Fallback Title');
      });
    });

    group('parseFromHtml - HTML guides', () {
      test('parses HTML guide with TOC', () {
        const html = '''
          <html>
            <head>
              <link rel="canonical" href="http://gamefaqs.gamespot.com/ps5/123-game/faqs/456">
            </head>
            <body>
              <h2 class="title">HTML Guide by <a href="#">Author</a></h2>
              <div id="faqwrap">
                <div class="ftoc">
                  <a href="/ps5/123-game/faqs/456/intro">Introduction</a>
                  <a href="/ps5/123-game/faqs/456/walkthrough">Walkthrough</a>
                </div>
                <h2>Welcome</h2>
                <p>This is the introduction.</p>
              </div>
            </body>
          </html>
        ''';

        final content = fetcher.parseFromHtml(html);

        expect(content.title, 'HTML Guide');
        expect(content.author, 'Author');
        expect(content.isMultiPage, true);
        expect(content.sectionUrls.length, 2);
        expect(content.sectionUrls[0], contains('intro'));
        expect(content.sectionUrls[1], contains('walkthrough'));
      });

      test('parses HTML guide sections correctly', () {
        const html = '''
          <html>
            <body>
              <div id="faqwrap">
                <h2>Section One</h2>
                <p>First paragraph.</p>
                <p>Second paragraph.</p>
                <h3>Subsection</h3>
                <ul>
                  <li>Item 1</li>
                  <li>Item 2</li>
                </ul>
              </div>
            </body>
          </html>
        ''';

        final content = fetcher.parseFromHtml(html);

        expect(content.sections.isNotEmpty, true);
        final sectionTitles = content.sections.map((s) => s.title).toList();
        expect(sectionTitles, contains('Section One'));
        expect(sectionTitles, contains('Subsection'));
      });
    });

    group('parseFromHtml - multi-page merging', () {
      test('throws ArgumentError when isFirstPage is false without previousJson', () {
        const html = '''
          <html>
            <body>
              <div id="faqwrap">
                <p>Content</p>
              </div>
            </body>
          </html>
        ''';

        expect(
          () => fetcher.parseFromHtml(html, isFirstPage: false),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('merges sections from subsequent pages', () {
        const firstPageHtml = '''
          <html>
            <head>
              <link rel="canonical" href="http://gamefaqs.gamespot.com/ps5/123-game/faqs/456">
            </head>
            <body>
              <h2 class="title">Multi-Page Guide by <a href="#">Author</a></h2>
              <div id="faqwrap">
                <div class="ftoc">
                  <a href="page1">Page 1</a>
                  <a href="page2">Page 2</a>
                </div>
                <h2>First Section</h2>
                <p>First page content.</p>
              </div>
            </body>
          </html>
        ''';

        const secondPageHtml = '''
          <html>
            <body>
              <div id="faqwrap">
                <h2>Second Section</h2>
                <p>Second page content.</p>
              </div>
            </body>
          </html>
        ''';

        final firstResult = fetcher.parseFromHtml(firstPageHtml);
        expect(firstResult.sections.length, 1);
        expect(firstResult.isMultiPage, true);

        final firstJson = firstResult.toJson();

        final mergedResult = fetcher.parseFromHtml(
          secondPageHtml,
          isFirstPage: false,
          previousJson: firstJson,
        );

        expect(mergedResult.title, 'Multi-Page Guide');
        expect(mergedResult.author, 'Author');
        expect(mergedResult.sections.length, 2);
        expect(mergedResult.sections[0].title, 'First Section');
        expect(mergedResult.sections[1].title, 'Second Section');
        expect(mergedResult.sectionUrls.length, 2);
      });

      test('preserves metadata from first page during merge', () {
        const firstPageHtml = '''
          <html>
            <head>
              <link rel="canonical" href="http://original-url.com">
            </head>
            <body>
              <h2 class="title">Original Title by <a href="#">Original Author</a></h2>
              <div id="faqwrap">
                <div class="ftoc">
                  <a href="page1">Page 1</a>
                  <a href="page2">Page 2</a>
                </div>
                <p>Content</p>
              </div>
            </body>
          </html>
        ''';

        const secondPageHtml = '''
          <html>
            <head>
              <link rel="canonical" href="http://different-url.com">
            </head>
            <body>
              <h2 class="title">Different Title by <a href="#">Different Author</a></h2>
              <div id="faqwrap">
                <p>More content</p>
              </div>
            </body>
          </html>
        ''';

        final firstResult = fetcher.parseFromHtml(firstPageHtml);
        final firstJson = firstResult.toJson();

        final mergedResult = fetcher.parseFromHtml(
          secondPageHtml,
          isFirstPage: false,
          previousJson: firstJson,
        );

        expect(mergedResult.title, 'Original Title');
        expect(mergedResult.author, 'Original Author');
        expect(mergedResult.url, 'http://original-url.com');
      });
    });

    group('parseFromHtml - error handling', () {
      test('throws exception when no guide content found', () {
        const html = '''
          <html>
            <body>
              <p>No guide content here</p>
            </body>
          </html>
        ''';

        expect(
          () => fetcher.parseFromHtml(html),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
