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
