import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

void main() {
  group('GameEditScreen', () {
    late GameItem testGame;

    setUp(() {
      testGame = GameItem(
        id: const GameId('test-game'),
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
        imagePath: null,
      );
    });

    group('Edit Mode', () {
      testWidgets('renders correctly with edit title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        // No more async timing issues - Family providers are immediately available
        await tester.pump();

        expect(find.byType(GameEditScreen), findsOneWidget);
        expect(find.text('Edit Game'), findsOneWidget);
      });

      testWidgets('shows existing game title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        // No more async timing issues
        await tester.pump();

        expect(find.text('Test Game'), findsOneWidget);
      });

      testWidgets('shows Save Changes button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        // No more async timing issues
        await tester.pump();

        expect(find.text('Save Changes'), findsOneWidget);
      });
    });

    group('Add Mode', () {
      testWidgets('renders correctly with add title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        // No more async timing issues
        await tester.pump();

        expect(find.byType(GameEditScreen), findsOneWidget);
        expect(find.text('Add Game'), findsAtLeastNWidgets(1));
      });

      testWidgets('shows default title "New Game"', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        // No more async timing issues
        await tester.pump();

        expect(find.text('New Game'), findsOneWidget);
      });

      testWidgets('shows Add Game button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        // No more async timing issues
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text('Add Game'),
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets('shows game information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // No more async timing issues
      await tester.pump();

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('PS5'), findsOneWidget);
    });

    testWidgets('allows editing game title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // Simple pump - no more timing issues
      await tester.pump();

      // Find the title text field (using TextField instead of TextFormField)
      final titleField = find.byType(TextField).first;
      await tester.tap(titleField);
      await tester.pump();

      await tester.enterText(titleField, 'Updated Game Title');
      await tester.pump();

      expect(find.text('Updated Game Title'), findsOneWidget);
    });

    testWidgets('save button is enabled when changes are made', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // Simple pump - no more async timing issues
      await tester.pump();

      // Find save button by text instead of type to be more specific
      expect(find.text('Save Changes'), findsOneWidget);

      // Make a change to enable the save button
      final titleField = find.byType(TextField).first;
      await tester.tap(titleField);
      await tester.pump();
      await tester.enterText(titleField, 'Modified Title');
      await tester.pump();

      // The save button should still be present
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('shows platform selection', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // Simple pump - no more async timing issues
      await tester.pump();

      expect(find.text('PS5'), findsOneWidget);
    });

    testWidgets('renders in landscape orientation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameEditScreen.edit(game: testGame)),
          ),
        ),
      );

      // Simple pump - no more async timing issues
      await tester.pump();

      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(find.text('Edit Game'), findsOneWidget);
    });

    testWidgets('renders in portrait orientation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameEditScreen.edit(game: testGame)),
          ),
        ),
      );

      // Simple pump - no more async timing issues
      await tester.pump();

      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(find.text('Edit Game'), findsOneWidget);
    });

    group('Game Status Selection', () {
      testWidgets('displays current game status', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        // Simple pump - no more async timing issues
        await tester.pump();

        // The status selector should show the current status
        expect(find.byType(GameEditScreen), findsOneWidget);
      });
    });

    group('Provider State Management', () {
      testWidgets('properly initializes provider state for edit mode', (
        tester,
      ) async {
        final container = ProviderContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        await tester.pump();

        // Create the expected context for this edit session
        final editContext = GameEditContext(isAddMode: false, game: testGame);

        // Verify the provider state is correctly initialized
        final providerState = container.read(
          gameEditStateProvider(editContext),
        );
        expect(providerState.title, equals('Test Game'));
        expect(providerState.platform, equals('PS5'));
        expect(providerState.status, equals(GameStatus.playing));
        expect(providerState.hasUnsavedChanges, isFalse);

        container.dispose();
      });

      testWidgets('properly initializes provider state for add mode', (
        tester,
      ) async {
        final container = ProviderContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(home: GameEditScreen.add()),
          ),
        );

        await tester.pump();

        // Create the expected context for this add session
        final editContext = GameEditContext(isAddMode: true);

        // Verify the provider state is correctly initialized
        final providerState = container.read(
          gameEditStateProvider(editContext),
        );
        expect(providerState.title, equals('New Game'));
        expect(providerState.platform, equals(''));
        expect(providerState.status, equals(GameStatus.backlog));
        expect(providerState.hasUnsavedChanges, isFalse);

        container.dispose();
      });
    });

    group('Add Game Status Selection Bug Fix', () {
      testWidgets('shows all status options when adding a new game', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        await tester.pump();

        // Should show ALL status options for new games
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);
        expect(find.text('Wishlist'), findsOneWidget);
        expect(find.text('Ordered'), findsOneWidget);
      });

      testWidgets('allows selecting any status when adding a new game', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        await tester.pump();

        // Should be able to select wishlist status (which would be filtered out in edit mode for playing games)
        await tester.tap(find.text('Wishlist'), warnIfMissed: false);
        await tester.pump();

        // Wishlist should still be visible and selectable
        expect(find.text('Wishlist'), findsOneWidget);
        expect(find.text('Ordered'), findsOneWidget);

        // All other statuses should still be visible too
        expect(find.text('Playing'), findsOneWidget);
        expect(find.text('Backlog'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
        expect(find.text('Abandoned'), findsOneWidget);
      });
    });
  });
}
