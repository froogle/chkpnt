import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import '../test_helpers.dart';

void main() {
  group('SectionExpansion', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    void expectSections(Map<String, bool> expected) {
      final expansion = container.read(sectionExpansionProvider);

      expect({
        for (final section in expected.keys) section: expansion[section],
      }, expected);
    }

    Map<String, bool> everySection(bool isExpanded) => {
      'Playing': isExpanded,
      'Backlog': isExpanded,
      'Completed': isExpanded,
      'Abandoned': isExpanded,
      'Ordered': isExpanded,
      'Wish List': isExpanded,
    };

    test('should have default expansion state', () {
      final expansion = container.read(sectionExpansionProvider);

      expect(expansion, {
        'Playing': true,
        'Ongoing/Frequently Played': false,
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
      container.read(sectionExpansionProvider.notifier).expandAll();

      expectSections(everySection(true));
    });

    test('should collapse all sections', () {
      container.read(sectionExpansionProvider.notifier).collapseAll();

      expectSections(everySection(false));
    });

    group('updateExpansionBasedOnResults', () {
      test('should expand sections with games and collapse empty sections', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        final playingGames = [
          TestHelpers.createPlayingGame(title: 'Test Game 1', platform: 'PS5'),
        ];

        final backlogGames = <GameItem>[];
        final completedGames = [
          TestHelpers.createCompletedGame(
            title: 'Test Game 2',
            platform: 'Xbox',
          ),
        ];
        final abandonedGames = <GameItem>[];

        notifier.updateExpansionBasedOnResults(
          playingGames: playingGames,
          backlogGames: backlogGames,
          completedGames: completedGames,
          abandonedGames: abandonedGames,
        );

        expectSections({
          'Playing': true,
          'Backlog': false,
          'Completed': true,
          'Abandoned': false,
        });
      });

      test('should collapse all sections when no games match filter', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        notifier.updateExpansionBasedOnResults(
          playingGames: [],
          backlogGames: [],
          completedGames: [],
          abandonedGames: [],
        );

        expectSections({
          'Playing': false,
          'Backlog': false,
          'Completed': false,
          'Abandoned': false,
        });
      });

      test('should expand all sections when all have matching games', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        final gamesList = [
          TestHelpers.createPlayingGame(title: 'Test Game', platform: 'PS5'),
        ];

        notifier.updateExpansionBasedOnResults(
          playingGames: gamesList,
          backlogGames: gamesList,
          completedGames: gamesList,
          abandonedGames: gamesList,
        );

        expectSections({
          'Playing': true,
          'Backlog': true,
          'Completed': true,
          'Abandoned': true,
        });
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

        expectSections({'Backlog': true, 'Playing': false});
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

        expectSections({
          'Playing': true,
          'Backlog': false,
          'Ordered': false,
          'Wish List': false,
        });
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
    test('leaves the optional fields at their defaults', () {
      const state = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );

      expect(state.imagePath, isNull);
      expect(state.hasUnsavedChanges, isFalse);
      expect(state.hasStartedEntry, isFalse);
    });

    test('carries every optional field it is given', () {
      const state = GameEditFormState(
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
        imagePath: '/path/to/image.jpg',
        hasUnsavedChanges: true,
      );

      expect(state.imagePath, equals('/path/to/image.jpg'));
      expect(state.hasUnsavedChanges, isTrue);
    });

    test('copyWith changes only the fields it is given', () {
      const originalState = GameEditFormState(
        title: 'Original Game',
        platform: 'PS4',
        status: GameStatus.backlog,
      );

      final updatedState = originalState.copyWith(
        title: 'Updated Game',
        hasUnsavedChanges: true,
      );

      expect(
        updatedState,
        const GameEditFormState(
          title: 'Updated Game',
          platform: 'PS4',
          status: GameStatus.backlog,
          hasUnsavedChanges: true,
        ),
      );
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

      expect(
        container.read(gameEditStateProvider(context)),
        const GameEditFormState(
          title: kDefaultAddGameTitle,
          platform: '',
          status: GameStatus.backlog,
        ),
      );
    });

    test('should initialize with custom default status when provided', () {
      final context = GameEditContext(
        isAddMode: true,
        defaultStatus: GameStatus.wishlist,
      );

      expect(
        container.read(gameEditStateProvider(context)),
        const GameEditFormState(
          title: kDefaultAddGameTitle,
          platform: '',
          status: GameStatus.wishlist,
        ),
      );
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

      expect(
        container.read(gameEditStateProvider(context)),
        const GameEditFormState(
          title: 'Test Game',
          platform: 'PS5',
          status: GameStatus.playing,
          imagePath: '/path/to/image.jpg',
          hasStartedEntry: true,
        ),
      );
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

      expect(
        container.read(gameEditStateProvider(context)),
        const GameEditFormState(
          title: 'Multi Game',
          platform: 'Nintendo Switch',
          status: GameStatus.completed,
          imagePath: '/path/to/multi.jpg',
          hasUnsavedChanges: true,
          hasStartedEntry: true,
        ),
      );
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

  group('GameEditState barcode scanning', () {
    late ProviderContainer container;
    const addContext = GameEditContext(isAddMode: true);

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts with no barcode', () {
      expect(container.read(gameEditStateProvider(addContext)).barcode, isNull);
    });

    test('a successful scan fills the form and marks it owned', () {
      container
          .read(gameEditStateProvider(addContext).notifier)
          .applyBarcodeScan(
            barcode: '5026555248082',
            title: 'Red Dead Redemption',
            platform: 'Xbox 360',
          );

      expect(
        container.read(gameEditStateProvider(addContext)),
        const GameEditFormState(
          title: 'Red Dead Redemption',
          platform: 'Xbox 360',
          status: GameStatus.owned,
          isPhysical: true,
          barcode: '5026555248082',
          hasUnsavedChanges: true,
          hasStartedEntry: true,
        ),
      );
    });

    test('a failed lookup still carries the barcode', () {
      container
          .read(gameEditStateProvider(addContext).notifier)
          .applyBarcodeScan(barcode: '5060990241239', title: '', platform: '');

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.barcode, '5060990241239');
      expect(state.status, GameStatus.owned);
      expect(state.isPhysical, isTrue);
    });

    test('a failed lookup never blanks a title or platform', () {
      final notifier = container.read(
        gameEditStateProvider(addContext).notifier,
      );
      notifier.updateTitle('Trails From Zero');
      notifier.updatePlatform('PS4');

      notifier.applyBarcodeScan(
        barcode: '5060990241239',
        title: '',
        platform: '',
      );

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.title, 'Trails From Zero');
      expect(state.platform, 'PS4');
      expect(state.barcode, '5060990241239');
    });

    test('a partial lookup keeps the platform the user chose', () {
      final notifier = container.read(
        gameEditStateProvider(addContext).notifier,
      );
      notifier.updatePlatform('PS4');

      notifier.applyBarcodeScan(
        barcode: '4012927064528',
        title: 'Metal Gear Solid - Peace Walker',
        platform: '',
      );

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.title, 'Metal Gear Solid - Peace Walker');
      expect(state.platform, 'PS4');
    });

    test('a scanned barcode survives later form edits', () {
      final notifier = container.read(gameEditStateProvider(addContext).notifier);
      notifier.applyBarcodeScan(
        barcode: '4012927064528',
        title: 'Metal Gear Solid - Peace Walker',
        platform: 'PSP',
      );
      notifier.updateTitle('Metal Gear Solid: Peace Walker');
      notifier.updateStatus(GameStatus.playing);

      final state = container.read(gameEditStateProvider(addContext));

      expect(state.barcode, '4012927064528');
      expect(state.title, 'Metal Gear Solid: Peace Walker');
      expect(state.status, GameStatus.playing);
    });
  });

  group('GameEditState started entry latch', () {
    late ProviderContainer container;
    const addContext = GameEditContext(isAddMode: true);

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    GameEditState notifier() =>
        container.read(gameEditStateProvider(addContext).notifier);

    bool hasStartedEntry() =>
        container.read(gameEditStateProvider(addContext)).hasStartedEntry;

    test('an untouched add form has not started entry', () {
      expect(hasStartedEntry(), isFalse);
    });

    test('an existing game has always started entry', () {
      final context = GameEditContext(
        isAddMode: false,
        game: GameItem.create(
          title: 'Existing Game',
          platform: 'PS5',
          status: GameStatus.playing,
        ),
      );

      expect(
        container.read(gameEditStateProvider(context)).hasStartedEntry,
        isTrue,
      );
    });

    test('re-entering the default title does not start entry', () {
      notifier().updatePlatform('PS5');
      notifier().updateTitle(kDefaultAddGameTitle);

      expect(hasStartedEntry(), isFalse);
    });

    test('clearing the title does not start entry', () {
      notifier().updatePlatform('PS5');
      notifier().updateTitle('');

      expect(hasStartedEntry(), isFalse);
    });

    test('a title alone does not start entry', () {
      notifier().updateTitle('Elden Ring');

      expect(hasStartedEntry(), isFalse);
    });

    test('a platform alone does not start entry', () {
      notifier().updatePlatform('PS5');

      expect(hasStartedEntry(), isFalse);
    });

    test('a title and a platform together start entry', () {
      notifier().updateTitle('Elden Ring');
      notifier().updatePlatform('PS5');

      expect(hasStartedEntry(), isTrue);
    });

    test('the order the two are entered in does not matter', () {
      notifier().updatePlatform('PS5');
      notifier().updateTitle('Elden Ring');

      expect(hasStartedEntry(), isTrue);
    });

    test('an empty platform does not start entry', () {
      notifier().updatePlatform('');

      expect(hasStartedEntry(), isFalse);
    });

    test('status, physical and image alone do not start entry', () {
      notifier().updateStatus(GameStatus.playing);
      notifier().updateIsPhysical(true);
      notifier().updateImagePath('/path/to/image.jpg');

      expect(hasStartedEntry(), isFalse);
    });

    test('a status change never substitutes for a platform', () {
      notifier().updateTitle('Elden Ring');
      notifier().updateStatus(GameStatus.playing);

      expect(hasStartedEntry(), isFalse);
    });

    test('a successful scan filling both fields starts entry', () {
      notifier().applyBarcodeScan(
        barcode: '5026555248082',
        title: 'Red Dead Redemption',
        platform: 'Xbox 360',
      );

      expect(hasStartedEntry(), isTrue);
    });

    test('a scanned title starts entry even with no matched platform', () {
      notifier().applyBarcodeScan(
        barcode: '5026555248082',
        title: 'Red Dead Redemption',
        platform: '',
      );

      expect(hasStartedEntry(), isTrue);
    });

    test('a scanned title of only whitespace does not start entry', () {
      notifier().applyBarcodeScan(
        barcode: '5026555248082',
        title: '   ',
        platform: '',
      );

      expect(hasStartedEntry(), isFalse);
    });

    test('a failed lookup does not start entry', () {
      notifier().applyBarcodeScan(
        barcode: '5060990241239',
        title: '',
        platform: '',
      );

      expect(hasStartedEntry(), isFalse);
    });

    test('a failed lookup after a full form keeps entry started', () {
      notifier().updateTitle('Trails From Zero');
      notifier().updatePlatform('PS4');
      notifier().applyBarcodeScan(
        barcode: '5060990241239',
        title: '',
        platform: '',
      );

      expect(hasStartedEntry(), isTrue);
    });

    test('a whitespace-only title does not start entry', () {
      notifier().updatePlatform('PS5');
      notifier().updateTitle('   ');

      expect(hasStartedEntry(), isFalse);
    });

    test('started entry never unsets', () {
      notifier().updateTitle('Elden Ring');
      notifier().updatePlatform('PS5');
      notifier().updateTitle(kDefaultAddGameTitle);
      notifier().updateTitle('');
      notifier().updatePlatform('');

      expect(hasStartedEntry(), isTrue);
    });
  });
}
