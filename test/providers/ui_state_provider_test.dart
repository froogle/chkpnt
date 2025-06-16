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
        'Ordered': true,
        'Wish List': false,
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
      expect(expansion['Ordered'], true);
      expect(expansion['Wish List'], true);
    });

    test('should collapse all sections', () {
      final notifier = container.read(sectionExpansionProvider.notifier);

      notifier.collapseAll();
      final expansion = container.read(sectionExpansionProvider);

      expect(expansion['Playing'], false);
      expect(expansion['Backlog'], false);
      expect(expansion['Completed'], false);
      expect(expansion['Abandoned'], false);
      expect(expansion['Ordered'], false);
      expect(expansion['Wish List'], false);
    });

    group('updateExpansionBasedOnResults', () {
      test('should expand sections with games and collapse empty sections', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        final playingGames = [
          GameItem(
            id: GameId.generate(),
            title: 'Test Game 1',
            platform: 'PS5',
            status: GameStatus.playing,
            lastModified: DateTime.now(),
            lastStatusChange: DateTime.now(),
          ),
        ];

        final backlogGames = <GameItem>[];
        final completedGames = [
          GameItem(
            id: GameId.generate(),
            title: 'Test Game 2',
            platform: 'Xbox',
            status: GameStatus.completed,
            lastModified: DateTime.now(),
            lastStatusChange: DateTime.now(),
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
            id: GameId.generate(),
            title: 'Test Game',
            platform: 'PS5',
            status: GameStatus.playing,
            lastModified: DateTime.now(),
            lastStatusChange: DateTime.now(),
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

      test('should preserve manually controlled sections', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // User manually expands Backlog
        notifier.toggleSection('Backlog');
        expect(container.read(sectionExpansionProvider)['Backlog'], true);

        // System tries to collapse it based on empty results
        notifier.updateExpansionBasedOnResults(
          playingGames: [],
          backlogGames: [], // Empty - would normally collapse
          completedGames: [],
          abandonedGames: [],
        );

        final expansion = container.read(sectionExpansionProvider);
        expect(
          expansion['Backlog'],
          true,
        ); // Should remain expanded due to manual control
        expect(
          expansion['Playing'],
          false,
        ); // Should be collapsed since not manually controlled
      });

      test('should only update sections that are provided', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // Initially, Playing is true, Backlog is false
        expect(container.read(sectionExpansionProvider)['Playing'], true);
        expect(container.read(sectionExpansionProvider)['Backlog'], false);

        // Update only wishlist sections (like when on wishlist screen)
        notifier.updateExpansionBasedOnResults(
          orderedGames: [],
          wishlistGames: [],
        );

        final expansion = container.read(sectionExpansionProvider);
        // Main screen sections should remain unchanged
        expect(expansion['Playing'], true);
        expect(expansion['Backlog'], false);
        // Wishlist sections should be updated
        expect(expansion['Ordered'], false);
        expect(expansion['Wish List'], false);
      });
    });

    group('Manual Control Tracking', () {
      test('should track manually controlled sections', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // Reset any existing manual control
        notifier.resetManualControl();

        // Initially, automatic updates should work
        notifier.updateExpansionBasedOnResults(
          playingGames: [],
          backlogGames: [],
        );

        expect(container.read(sectionExpansionProvider)['Playing'], false);
        expect(container.read(sectionExpansionProvider)['Backlog'], false);

        // User manually toggles Backlog
        notifier.toggleSection('Backlog');
        expect(container.read(sectionExpansionProvider)['Backlog'], true);

        // Automatic update should not affect manually controlled Backlog
        notifier.updateExpansionBasedOnResults(
          playingGames: [],
          backlogGames: [], // Still empty
        );

        final expansion = container.read(sectionExpansionProvider);
        expect(expansion['Playing'], false); // Can still be auto-updated
        expect(expansion['Backlog'], true); // Preserved due to manual control
      });

      test('should reset manual control when requested', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // User manually controls a section
        notifier.toggleSection('Completed');

        // Reset manual control
        notifier.resetManualControl();

        // Now automatic updates should work again
        notifier.updateExpansionBasedOnResults(
          completedGames: [], // Empty
        );

        expect(container.read(sectionExpansionProvider)['Completed'], false);
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

      notifier.selectPlatform('PS5');
      expect(container.read(selectedPlatformProvider), 'PS5');
    });

    test('should reset to "All"', () {
      final notifier = container.read(selectedPlatformProvider.notifier);

      notifier.selectPlatform('Xbox');
      expect(container.read(selectedPlatformProvider), 'Xbox');

      notifier.resetToAll();
      expect(container.read(selectedPlatformProvider), 'All');
    });
  });

  group('GameEditFormState', () {
    test('creates instance with required fields', () {
      const state = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );

      expect(state.title, equals('Test Game'));
      expect(state.platform, equals('PS5'));
      expect(state.status, equals(GameStatus.playing));
      expect(state.imagePath, isNull);
      expect(state.hasUnsavedChanges, isFalse);
    });

    test('creates instance with all fields', () {
      const state = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
        imagePath: '/path/to/image.jpg',
        hasUnsavedChanges: true,
      );

      expect(state.title, equals('Test Game'));
      expect(state.platform, equals('PS5'));
      expect(state.status, equals(GameStatus.playing));
      expect(state.imagePath, equals('/path/to/image.jpg'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('copyWith works correctly', () {
      const originalState = GameEditFormState(
        title: 'Original Game',
        platform: 'PS4',
        status: GameStatus.backlog,
      );

      final updatedState = originalState.copyWith(
        title: 'Updated Game',
        hasUnsavedChanges: true,
      );

      expect(updatedState.title, equals('Updated Game'));
      expect(updatedState.platform, equals('PS4')); // unchanged
      expect(updatedState.status, equals(GameStatus.backlog)); // unchanged
      expect(updatedState.hasUnsavedChanges, isTrue);
    });

    test('equality works correctly', () {
      const state1 = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );

      const state2 = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );

      const state3 = GameEditFormState(
        title: 'Different Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('GameEditState Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default values for add mode', () {
      final context = GameEditContext(isAddMode: true);

      final state = container.read(gameEditStateProvider(context));

      expect(state.title, equals('New Game'));
      expect(state.platform, equals(''));
      expect(state.status, equals(GameStatus.backlog));
      expect(state.imagePath, isNull);
      expect(state.hasUnsavedChanges, isFalse);
    });

    test('should initialize with custom default status when provided', () {
      final context = GameEditContext(
        isAddMode: true,
        defaultStatus: GameStatus.wishlist,
      );

      final state = container.read(gameEditStateProvider(context));

      expect(state.title, equals('New Game'));
      expect(state.platform, equals(''));
      expect(state.status, equals(GameStatus.wishlist));
      expect(state.imagePath, isNull);
      expect(state.hasUnsavedChanges, isFalse);
    });

    test('should initialize with game data for edit mode', () {
      final testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
        imagePath: '/path/to/image.jpg',
      );

      final context = GameEditContext(isAddMode: false, game: testGame);

      final state = container.read(gameEditStateProvider(context));

      expect(state.title, equals('Test Game'));
      expect(state.platform, equals('PS5'));
      expect(state.status, equals(GameStatus.playing));
      expect(state.imagePath, equals('/path/to/image.jpg'));
      expect(state.hasUnsavedChanges, isFalse);
    });

    test('should update title and mark as changed', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      notifier.updateTitle('Updated Title');

      final state = container.read(gameEditStateProvider(context));
      expect(state.title, equals('Updated Title'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('should update platform and mark as changed', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      notifier.updatePlatform('PS5');

      final state = container.read(gameEditStateProvider(context));
      expect(state.platform, equals('PS5'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('should update status and mark as changed', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      notifier.updateStatus(GameStatus.completed);

      final state = container.read(gameEditStateProvider(context));
      expect(state.status, equals(GameStatus.completed));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('should update image path and mark as changed', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      notifier.updateImagePath('/path/to/image.jpg');

      final state = container.read(gameEditStateProvider(context));
      expect(state.imagePath, equals('/path/to/image.jpg'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('should remove image path and mark as changed', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      // First set an image
      notifier.updateImagePath('/path/to/image.jpg');
      // Then remove it
      notifier.updateImagePath(null);

      final state = container.read(gameEditStateProvider(context));
      expect(state.imagePath, isNull);
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('calculates hasChanges correctly for add mode', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      // Initially no changes
      expect(
        container.read(gameEditStateProvider(context)).hasUnsavedChanges,
        isFalse,
      );

      // Make a change
      notifier.updateTitle('Changed Title');
      expect(
        container.read(gameEditStateProvider(context)).hasUnsavedChanges,
        isTrue,
      );

      // Can't revert to default with Family provider - each context is independent
      expect(notifier.hasChanges, isTrue);
    });

    test('calculates hasChanges correctly for edit mode', () {
      final testGame = GameItem(
        id: GameId.generate(),
        title: 'Original Game',
        platform: 'PS5',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );

      final context = GameEditContext(isAddMode: false, game: testGame);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      // Initially no changes
      expect(
        container.read(gameEditStateProvider(context)).hasUnsavedChanges,
        isFalse,
      );

      // Make a change
      notifier.updateTitle('Changed Title');
      expect(
        container.read(gameEditStateProvider(context)).hasUnsavedChanges,
        isTrue,
      );

      // Check hasChanges getter
      expect(notifier.hasChanges, isTrue);
    });

    test('hasChanges getter works correctly', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      expect(notifier.hasChanges, isFalse);

      notifier.updateTitle('Changed');
      expect(notifier.hasChanges, isTrue);
    });

    test('handles multiple field updates correctly', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      notifier.updateTitle('Multi Game');
      notifier.updatePlatform('Nintendo Switch');
      notifier.updateStatus(GameStatus.completed);
      notifier.updateImagePath('/path/to/multi.jpg');

      final state = container.read(gameEditStateProvider(context));
      expect(state.title, equals('Multi Game'));
      expect(state.platform, equals('Nintendo Switch'));
      expect(state.status, equals(GameStatus.completed));
      expect(state.imagePath, equals('/path/to/multi.jpg'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('tracks unsaved changes correctly', () {
      final context = GameEditContext(isAddMode: true);
      final notifier = container.read(gameEditStateProvider(context).notifier);

      // Initially no changes
      expect(notifier.hasChanges, isFalse);

      // After updating title
      notifier.updateTitle('Changed Title');
      expect(notifier.hasChanges, isTrue);
    });

    test('maintains separate state for different contexts', () {
      final testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'PC',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );

      final addContext = GameEditContext(isAddMode: true);
      final editContext = GameEditContext(isAddMode: false, game: testGame);

      final addNotifier = container.read(
        gameEditStateProvider(addContext).notifier,
      );

      // Update add context
      addNotifier.updateTitle('Add Title');

      // Check states are separate
      final addState = container.read(gameEditStateProvider(addContext));
      final editState = container.read(gameEditStateProvider(editContext));

      expect(addState.title, equals('Add Title'));
      expect(editState.title, equals('Test Game')); // Unchanged
    });
  });
}
