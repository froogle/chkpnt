import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('SectionExpansion', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    bool isExpanded(Section section) =>
        container.read(sectionExpandedProvider(section));

    SectionExpansion notifier() =>
        container.read(sectionExpansionProvider.notifier);

    const playing = StatusSection(GameStatus.playing);

    test('opens only the Playing Status section by default', () {
      final statuses = GameStatus.values.where((s) => s != GameStatus.owned);

      for (final status in statuses) {
        expect(
          isExpanded(StatusSection(status)),
          status == GameStatus.playing,
          reason: '$status section',
        );
      }
    });

    test('opens every Platform section by default', () {
      expect(
        isExpanded(const PlatformSection(GameScreen.backlog, 'PS5')),
        isTrue,
      );
      expect(
        isExpanded(const PlatformSection(GameScreen.collection, 'PS5')),
        isTrue,
      );
    });

    test('toggles a section closed and open again', () {
      notifier().toggleSection(playing);
      expect(isExpanded(playing), isFalse);

      notifier().toggleSection(playing);
      expect(isExpanded(playing), isTrue);
    });

    test('expands a closed section and keeps an open one open', () {
      const completed = StatusSection(GameStatus.completed);

      notifier().expandSection(completed);
      notifier().expandSection(playing);

      expect(isExpanded(completed), isTrue);
      expect(isExpanded(playing), isTrue);
    });

    test('keeps a Platform named Playing apart from the Playing section', () {
      const platformNamedPlaying = PlatformSection(
        GameScreen.backlog,
        'Playing',
      );

      notifier().toggleSection(platformNamedPlaying);

      expect(isExpanded(platformNamedPlaying), isFalse);
      expect(isExpanded(playing), isTrue);
    });

    test('opens one Platform on Backlog and Collection independently', () {
      const backlogPs5 = PlatformSection(GameScreen.backlog, 'PS5');
      const collectionPs5 = PlatformSection(GameScreen.collection, 'PS5');

      notifier().toggleSection(backlogPs5);

      expect(isExpanded(backlogPs5), isFalse);
      expect(isExpanded(collectionPs5), isTrue);
    });
  });

  group('SearchQuery', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have empty initial query', () {
      final query = container.read(searchQueryProvider);
      expect(query, '');
    });

    test('should update query', () {
      final notifier = container.read(searchQueryProvider.notifier);

      notifier.updateQuery('test game');
      expect(container.read(searchQueryProvider), 'test game');
    });

    test('should clear query', () {
      final notifier = container.read(searchQueryProvider.notifier);

      notifier.updateQuery('test game');
      expect(container.read(searchQueryProvider), 'test game');

      notifier.clearQuery();
      expect(container.read(searchQueryProvider), '');
    });
  });

  group('SelectedPlatform', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with no Platform chosen', () {
      expect(container.read(selectedPlatformProvider), isNull);
    });

    test('should select platform', () {
      final notifier = container.read(selectedPlatformProvider.notifier);

      notifier.selectPlatform('PS5');
      expect(container.read(selectedPlatformProvider), 'PS5');
    });

    test('clears the Platform choice', () {
      final notifier = container.read(selectedPlatformProvider.notifier);

      notifier.selectPlatform('Xbox');
      expect(container.read(selectedPlatformProvider), 'Xbox');

      notifier.selectPlatform(null);
      expect(container.read(selectedPlatformProvider), isNull);
    });
  });
}
