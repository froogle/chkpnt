import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/models/guide_models.dart';

void main() {
  group('GuideFormat', () {
    test('text is the first value so stored index 0 maps to text', () {
      expect(GuideFormat.text.index, 0);
      expect(GuideFormat.values[0], GuideFormat.text);
    });
  });

  group('GuideItem.create', () {
    test('creates a text guide with a file name', () {
      final guide = GuideItem.create(
        gameId: GameId.generate(),
        title: 'Text Guide',
        author: 'Author',
        fileName: 'guide_1.json',
        sourceUrl: 'http://example.com/guide',
      );

      expect(guide.format, GuideFormat.text);
      expect(guide.fileName, 'guide_1.json');
      expect(guide.sourceUrl, 'http://example.com/guide');
      expect(guide.lastReadSection, 0);
      expect(guide.hasSeenAttribution, false);
    });
  });

  group('GuideItem.createHtmlLink', () {
    test('creates an html guide that only stores the link', () {
      final gameId = GameId.generate();
      final guide = GuideItem.createHtmlLink(
        gameId: gameId,
        title: 'HTML Guide',
        author: 'Author',
        sourceUrl: 'http://example.com/html-guide',
      );

      expect(guide.format, GuideFormat.html);
      expect(guide.fileName, '');
      expect(guide.sourceUrl, 'http://example.com/html-guide');
      expect(guide.gameId, gameId);
      expect(guide.title, 'HTML Guide');
      expect(guide.author, 'Author');
    });
  });
}
