import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/game_edit_provider.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/services/barcode_lookup_service.dart';

class _FixedGameList extends GameList {
  final List<GameItem> games;

  _FixedGameList(this.games);

  @override
  List<GameItem> build() => games;
}

class _FakeLookup extends BarcodeLookupService {
  BarcodeLookupResult result;
  final Completer<void>? gate;
  final Object? error;
  final List<String> lookedUp = [];

  _FakeLookup(this.result, {this.gate, this.error});

  @override
  Future<BarcodeLookupResult> lookup(String barcode) async {
    lookedUp.add(barcode);
    await gate?.future;
    if (error != null) throw error!;
    return result;
  }
}

class SocketExceptionStandIn implements Exception {
  const SocketExceptionStandIn();
}

void main() {
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
          isAddMode: true,
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
          isAddMode: true,
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
          isAddMode: true,
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

  group('GameEditState barcode scan', () {
    late ProviderContainer container;
    late _FakeLookup lookup;
    const addContext = GameEditContext(isAddMode: true);
    const backlogContext = GameEditContext(
      isAddMode: true,
      availableStatuses: [
        GameStatus.playing,
        GameStatus.backlog,
        GameStatus.ongoing,
      ],
      defaultStatus: GameStatus.backlog,
    );
    final savedGame = GameItem.create(
      title: 'Halo 3',
      platform: 'Xbox 360',
      status: GameStatus.completed,
      barcode: '0882224446012',
    );
    const found = BarcodeLookupResult(
      outcome: BarcodeLookupOutcome.found,
      title: 'Red Dead Redemption',
      platform: 'xbox 360',
    );
    const notFound = BarcodeLookupResult(
      outcome: BarcodeLookupOutcome.notFound,
    );

    void useLookup(
      BarcodeLookupResult result, {
      Completer<void>? gate,
      Object? error,
    }) {
      lookup = _FakeLookup(result, gate: gate, error: error);
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => _FixedGameList([savedGame])),
          barcodeLookupServiceProvider.overrideWithValue(lookup),
        ],
      );
      addTearDown(container.dispose);
    }

    GameEditState edit([GameEditContext context = addContext]) {
      container.listen(gameEditStateProvider(context), (_, _) {});
      return container.read(gameEditStateProvider(context).notifier);
    }

    GameEditFormState form([GameEditContext context = addContext]) =>
        container.read(gameEditStateProvider(context));

    test('starts with no barcode', () {
      useLookup(found);

      expect(form().barcode, isNull);
    });

    test(
      'fills the form from a found barcode as Physical with no Status',
      () async {
        useLookup(found);

        final scan = await edit().scanBarcode('5026555248082');

        expect(scan, isA<BarcodeLookedUp>());
        expect((scan as BarcodeLookedUp).result, same(found));
        expect(
          form(),
          const GameEditFormState(
            title: 'Red Dead Redemption',
            platform: 'Xbox 360',
            status: GameStatus.owned,
            isPhysical: true,
            barcode: '5026555248082',
            hasUnsavedChanges: true,
            hasStartedEntry: true,
            isAddMode: true,
          ),
        );
      },
    );

    test(
      'reports a barcode already on a saved Game, without a lookup',
      () async {
        useLookup(found);

        final scan = await edit().scanBarcode('882224446012');

        expect(scan, isA<DuplicateBarcode>());
        expect((scan as DuplicateBarcode).game, savedGame);
        expect(lookup.lookedUp, isEmpty);
        expect(form().barcode, isNull);
      },
    );

    test('leaves a scanned Platform the player does not have empty', () async {
      useLookup(
        const BarcodeLookupResult(
          outcome: BarcodeLookupOutcome.found,
          title: 'Elden Ring',
          platform: 'PS5',
        ),
      );

      await edit().scanBarcode('3391892017403');

      expect(form().platform, isEmpty);
    });

    test('keeps the selected Status when the screen limits Statuses', () async {
      useLookup(found);
      edit(backlogContext).updateStatus(GameStatus.ongoing);

      await edit(backlogContext).scanBarcode('5026555248082');

      expect(form(backlogContext).status, GameStatus.ongoing);
      expect(form(backlogContext).isPhysical, isTrue);
    });

    test('shows the lookup is running only while it runs', () async {
      final gate = Completer<void>();
      useLookup(found, gate: gate);

      final scanning = edit().scanBarcode('5026555248082');
      await Future<void>.delayed(Duration.zero);
      expect(form().isLookingUpBarcode, isTrue);

      gate.complete();
      await scanning;
      expect(form().isLookingUpBarcode, isFalse);
    });

    test('drops a lookup that returns after the form has closed', () async {
      final gate = Completer<void>();
      useLookup(found, gate: gate);
      final openForm = container.listen(
        gameEditStateProvider(addContext),
        (_, _) {},
      );
      final scanning = container
          .read(gameEditStateProvider(addContext).notifier)
          .scanBarcode('5026555248082');
      await Future<void>.delayed(Duration.zero);

      openForm.close();
      await container.pump();
      container.listen(gameEditStateProvider(addContext), (_, _) {});
      gate.complete();
      await scanning;

      expect(form().barcode, isNull);
      expect(form().title, kDefaultAddGameTitle);
      expect(form().isLookingUpBarcode, isFalse);
    });

    test('stops showing the lookup when it fails with an error', () async {
      useLookup(found, error: const SocketExceptionStandIn());

      await expectLater(
        edit().scanBarcode('5026555248082'),
        throwsA(isA<SocketExceptionStandIn>()),
      );

      expect(form().isLookingUpBarcode, isFalse);
    });

    test('a failed lookup still carries the barcode', () async {
      useLookup(notFound);

      final scan = await edit().scanBarcode('5060990241239');

      expect(
        (scan as BarcodeLookedUp).result.outcome,
        BarcodeLookupOutcome.notFound,
      );
      expect(form().barcode, '5060990241239');
      expect(form().status, GameStatus.owned);
      expect(form().isPhysical, isTrue);
      expect(form().title, kDefaultAddGameTitle);
    });

    test('a failed lookup never blanks a title or platform', () async {
      useLookup(notFound);
      edit().updateTitle('Trails From Zero');
      edit().updatePlatform('PS4');

      await edit().scanBarcode('5060990241239');

      expect(form().title, 'Trails From Zero');
      expect(form().platform, 'PS4');
      expect(form().barcode, '5060990241239');
    });

    test('a partial lookup keeps the platform the player chose', () async {
      useLookup(
        const BarcodeLookupResult(
          outcome: BarcodeLookupOutcome.found,
          title: 'Metal Gear Solid - Peace Walker',
        ),
      );
      edit().updatePlatform('PS4');

      await edit().scanBarcode('4012927064528');

      expect(form().title, 'Metal Gear Solid - Peace Walker');
      expect(form().platform, 'PS4');
    });

    test('a scanned barcode survives later form edits', () async {
      useLookup(found);
      await edit().scanBarcode('4012927064528');

      edit().updateTitle('Red Dead Redemption: GOTY');
      edit().updateStatus(GameStatus.playing);

      expect(form().barcode, '4012927064528');
      expect(form().title, 'Red Dead Redemption: GOTY');
      expect(form().status, GameStatus.playing);
    });
  });

  group('GameEditState form rules', () {
    late ProviderContainer container;
    const addContext = GameEditContext(isAddMode: true);
    final existing = GameItem.create(
      title: 'Hades',
      platform: 'PC',
      status: GameStatus.playing,
      barcode: '0811949033017',
    );
    final editContext = GameEditContext(isAddMode: false, game: existing);

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    GameEditState edit(GameEditContext context) {
      container.listen(gameEditStateProvider(context), (_, _) {});
      return container.read(gameEditStateProvider(context).notifier);
    }

    GameEditFormState form(GameEditContext context) =>
        container.read(gameEditStateProvider(context));

    test('offers a scan only until entry starts when adding', () {
      expect(form(addContext).offersScan, isTrue);

      edit(addContext).updateTitle('Celeste');
      edit(addContext).updatePlatform('PC');

      expect(form(addContext).offersScan, isFalse);
      expect(form(editContext).offersScan, isFalse);
    });

    test('can save an added Game only with a real title', () {
      expect(form(addContext).canSave, isFalse);

      edit(addContext).updateTitle('   ');
      expect(form(addContext).canSave, isFalse);

      edit(addContext).updateTitle(kDefaultAddGameTitle);
      expect(form(addContext).canSave, isFalse);

      edit(addContext).updateTitle('Celeste');
      expect(form(addContext).canSave, isTrue);

      expect(form(editContext).canSave, isTrue);

      final placeholderTitled = GameEditContext(
        isAddMode: false,
        game: GameItem.create(
          title: kDefaultAddGameTitle,
          platform: 'PC',
          status: GameStatus.backlog,
        ),
      );
      expect(form(placeholderTitled).canSave, isTrue);
    });

    test('builds a new Game to add from the form', () {
      final notifier = edit(addContext);
      notifier.updateTitle('  Celeste  ');
      notifier.updatePlatform('Switch');
      notifier.updateStatus(GameStatus.completed);
      notifier.updateIsPhysical(true);
      notifier.updateImagePath('/covers/celeste.jpg');

      final game = notifier.gameToSave();

      expect(game.title, 'Celeste');
      expect(game.platform, 'Switch');
      expect(game.status, GameStatus.completed);
      expect(game.isPhysical, isTrue);
      expect(game.imagePath, '/covers/celeste.jpg');
    });

    test('builds the updated Game from the form when editing', () {
      final notifier = edit(editContext);
      notifier.updateTitle(' Hades II ');
      notifier.updateStatus(GameStatus.completed);

      final game = notifier.gameToSave();

      expect(game.id, existing.id);
      expect(game.title, 'Hades II');
      expect(game.status, GameStatus.completed);
      expect(game.barcode, '0811949033017');
    });
  });

  group('GameEditState started entry latch', () {
    late ProviderContainer container;
    late _FakeLookup lookup;
    const addContext = GameEditContext(isAddMode: true);

    setUp(() {
      lookup = _FakeLookup(
        const BarcodeLookupResult(outcome: BarcodeLookupOutcome.notFound),
      );
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(
            () => _FixedGameList([
              GameItem.create(
                title: 'Halo 3',
                platform: 'Xbox 360',
                status: GameStatus.completed,
              ),
            ]),
          ),
          barcodeLookupServiceProvider.overrideWithValue(lookup),
        ],
      );
      container.listen(gameEditStateProvider(addContext), (_, _) {});
    });

    tearDown(() {
      container.dispose();
    });

    GameEditState notifier() =>
        container.read(gameEditStateProvider(addContext).notifier);

    bool hasStartedEntry() =>
        container.read(gameEditStateProvider(addContext)).hasStartedEntry;

    Future<void> scanFinding(String title, {String? platform}) {
      lookup.result = BarcodeLookupResult(
        outcome:
            title.isEmpty
                ? BarcodeLookupOutcome.notFound
                : BarcodeLookupOutcome.found,
        title: title,
        platform: platform,
      );
      return notifier().scanBarcode('5026555248082');
    }

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

    test('a successful scan filling both fields starts entry', () async {
      await scanFinding('Red Dead Redemption', platform: 'Xbox 360');

      expect(hasStartedEntry(), isTrue);
    });

    test(
      'a scanned title starts entry even with no matched platform',
      () async {
        await scanFinding('Red Dead Redemption', platform: 'Dreamcast');

        expect(hasStartedEntry(), isTrue);
      },
    );

    test('a scanned title of only whitespace does not start entry', () async {
      await scanFinding('   ');

      expect(hasStartedEntry(), isFalse);
    });

    test('a failed lookup does not start entry', () async {
      await scanFinding('');

      expect(hasStartedEntry(), isFalse);
    });

    test('a failed lookup after a full form keeps entry started', () async {
      notifier().updateTitle('Trails From Zero');
      notifier().updatePlatform('PS4');
      await scanFinding('');

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
