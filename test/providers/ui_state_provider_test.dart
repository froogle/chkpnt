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

    test('should have default expansion state', () {
      final expansion = container.read(sectionExpansionProvider);

      expect(expansion, {
        'Playing': true,
        'Backlog': false,
        'Completed': false,
        'Abandoned': false,
      });
    });

    test('should toggle section expansion', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      // Initially, Backlog is false
      expect(container.read(sectionExpansionProvider)['Backlog'], false);

      // Toggle Backlog
      notifier.toggleSection('Backlog');
      expect(container.read(sectionExpansionProvider)['Backlog'], true);

      // Toggle again
      notifier.toggleSection('Backlog');
      expect(container.read(sectionExpansionProvider)['Backlog'], false);
    });

    test('should expand specific section', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      notifier.expandSection('Completed');
      expect(container.read(sectionExpansionProvider)['Completed'], true);
    });

    test('should collapse specific section', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      // Playing starts as true
      expect(container.read(sectionExpansionProvider)['Playing'], true);

      notifier.collapseSection('Playing');
      expect(container.read(sectionExpansionProvider)['Playing'], false);
    });

    test('should expand all sections', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      notifier.expandAll();
      final expansion = container.read(sectionExpansionProvider);

      expect(expansion['Playing'], true);
      expect(expansion['Backlog'], true);
      expect(expansion['Completed'], true);
      expect(expansion['Abandoned'], true);
    });

    test('should collapse all sections', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      notifier.collapseAll();
      final expansion = container.read(sectionExpansionProvider);

      expect(expansion['Playing'], false);
      expect(expansion['Backlog'], false);
      expect(expansion['Completed'], false);
      expect(expansion['Abandoned'], false);
    });

    group('updateExpansionBasedOnResults', () {
      test('should expand sections with games and collapse empty sections', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        final playingGames = [
          GameItem(
            id: '1',
            title: 'Test Game 1',
            platform: 'PC',
            status: GameStatus.playing,
            progress: 0.5,
          ),
        ];

        final backlogGames = <GameItem>[];
        final completedGames = [
          GameItem(
            id: '2',
            title: 'Test Game 2',
            platform: 'PC',
            status: GameStatus.completed,
            progress: 1.0,
          ),
        ];
        final abandonedGames = <GameItem>[];

        notifier.updateExpansionBasedOnResults(
          playingGames: playingGames,
          backlogGames: backlogGames,
          completedGames: completedGames,
          abandonedGames: abandonedGames,
        );

        final expansion = container.read(sectionExpansionProvider);
        expect(expansion['Playing'], true); // Has games
        expect(expansion['Backlog'], false); // Empty
        expect(expansion['Completed'], true); // Has games
        expect(expansion['Abandoned'], false); // Empty
      });

      test('should collapse all sections when no games match filter', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        notifier.updateExpansionBasedOnResults(
          playingGames: [],
          backlogGames: [],
          completedGames: [],
          abandonedGames: [],
        );

        final expansion = container.read(sectionExpansionProvider);
        expect(expansion['Playing'], false);
        expect(expansion['Backlog'], false);
        expect(expansion['Completed'], false);
        expect(expansion['Abandoned'], false);
      });

      test('should expand all sections when all have matching games', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        final gamesList = [
          GameItem(
            id: '1',
            title: 'Test Game',
            platform: 'PC',
            status: GameStatus.playing,
            progress: 0.5,
          ),
        ];

        notifier.updateExpansionBasedOnResults(
          playingGames: gamesList,
          backlogGames: gamesList,
          completedGames: gamesList,
          abandonedGames: gamesList,
        );

        final expansion = container.read(sectionExpansionProvider);
        expect(expansion['Playing'], true);
        expect(expansion['Backlog'], true);
        expect(expansion['Completed'], true);
        expect(expansion['Abandoned'], true);
      });
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

    test('should have "All" as initial platform', () {
      final platform = container.read(selectedPlatformProvider);
      expect(platform, 'All');
    });

    test('should select platform', () {
      final notifier = container.read(selectedPlatformProvider.notifier);

      notifier.selectPlatform('PC');
      expect(container.read(selectedPlatformProvider), 'PC');
    });

    test('should reset to All', () {
      final notifier = container.read(selectedPlatformProvider.notifier);

      notifier.selectPlatform('PS5');
      expect(container.read(selectedPlatformProvider), 'PS5');

      notifier.resetToAll();
      expect(container.read(selectedPlatformProvider), 'All');
    });
  });
}
