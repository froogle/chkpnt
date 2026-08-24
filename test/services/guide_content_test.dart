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
    test('toJson returns correct map', () {
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
      );
      final json = guide.toJson();

      expect(json['title'], 'Test Guide');
      expect(json['author'], 'Test Author');
      expect(json['url'], 'http://example.com');
      expect(json['sections'], isA<List>());
      expect(json.containsKey('sectionUrls'), false);
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
      };
      final guide = GuideContent.fromJson(json);

      expect(guide.title, 'Test Guide');
      expect(guide.author, 'Test Author');
      expect(guide.url, 'http://example.com');
      expect(guide.sections.length, 1);
    });

    test('fromJson ignores legacy sectionUrls key', () {
      final json = {
        'title': 'Test Guide',
        'author': 'Test Author',
        'sections': [],
        'sectionUrls': ['http://example.com/page1'],
      };
      final guide = GuideContent.fromJson(json);

      expect(guide.title, 'Test Guide');
      expect(guide.sections, isEmpty);
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

    group('parseFromHtml - text guides', () {
      test('parses simple text guide', () {
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

        final page = fetcher.parseFromHtml(html);

        expect(page, isA<TextGuidePage>());
        expect(page.title, 'Test Guide (PS5)');
        expect(page.author, 'TestAuthor');
        expect(page.url, 'http://example.com/guide');

        final content = (page as TextGuidePage).content;
        expect(content.title, 'Test Guide (PS5)');
        expect(content.author, 'TestAuthor');
        expect(content.url, 'http://example.com/guide');
        expect(content.sections.isNotEmpty, true);
      });

      test('handles text guide without canonical URL', () {
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

        final page = fetcher.parseFromHtml(html);

        expect(page, isA<TextGuidePage>());
        expect(page.url, isNull);
        expect(page.title, 'Fallback Title');
        expect(page.author, 'Unknown Author');
      });
    });

    group('parseFromHtml - HTML guides', () {
      test('returns a link page without parsing content', () {
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

        final page = fetcher.parseFromHtml(html);

        expect(page, isA<HtmlGuidePage>());
        expect(page.title, 'HTML Guide');
        expect(page.author, 'Author');
        expect(page.url, 'http://gamefaqs.gamespot.com/ps5/123-game/faqs/456');
      });

      test('handles HTML guide without canonical URL', () {
        const html = '''
          <html>
            <body>
              <div id="faqwrap">
                <h2>Section One</h2>
                <p>First paragraph.</p>
              </div>
            </body>
          </html>
        ''';

        final page = fetcher.parseFromHtml(html);

        expect(page, isA<HtmlGuidePage>());
        expect(page.url, isNull);
        expect(page.title, 'Unknown Guide');
        expect(page.author, 'Unknown Author');
      });

      test('prefers text content when both containers are present', () {
        const html = '''
          <html>
            <body>
              <div id="faqtext"><pre>Plain text guide</pre></div>
              <div id="faqwrap"><p>Formatted guide</p></div>
            </body>
          </html>
        ''';

        final page = fetcher.parseFromHtml(html);

        expect(page, isA<TextGuidePage>());
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
