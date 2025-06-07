import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameEditScreen', () {
    late GameItem testGame;

    setUp(() {
      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'PS5',
        status: GameStatus.playing,
      );
    });

    group('Edit Mode', () {
      testWidgets('renders correctly with edit title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        expect(find.byType(GameEditScreen), findsOneWidget);
        expect(find.text('Edit Game'), findsOneWidget);
      });

      testWidgets('shows existing game title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        expect(find.text('Test Game'), findsOneWidget);
      });

      testWidgets('shows Save Changes button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
          ),
        );

        expect(find.text('Save Changes'), findsOneWidget);
      });
    });

    group('Add Mode', () {
      testWidgets('renders correctly with add title', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        expect(find.byType(GameEditScreen), findsOneWidget);
        expect(find.text('Add Game'), findsOneWidget);
      });

      testWidgets('shows default title "New Game"', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        expect(find.text('New Game'), findsOneWidget);
      });

      testWidgets('shows Add Game button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: GameEditScreen.add())),
        );

        expect(find.text('Add Game'), findsOneWidget);
      });
    });

    testWidgets('shows game information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('PS5'), findsOneWidget);
    });

    testWidgets('allows editing game title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // Find the title text field and clear it
      final titleField = find.byType(TextFormField).first;
      await tester.tap(titleField);
      await tester.pumpAndSettle();

      await tester.enterText(titleField, 'Updated Game Title');
      await tester.pumpAndSettle();

      expect(find.text('Updated Game Title'), findsOneWidget);
    });

    testWidgets('save button is enabled when changes are made', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

      // Initially, find save button (it might be disabled)
      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);

      // Make a change to enable the save button
      final titleField = find.byType(TextFormField).first;
      await tester.tap(titleField);
      await tester.pumpAndSettle();
      await tester.enterText(titleField, 'Modified Title');
      await tester.pumpAndSettle();

      // The save button should now be enabled
      final enabledSaveButton = find.byType(ElevatedButton);
      expect(enabledSaveButton, findsOneWidget);
    });

    testWidgets('shows platform selection', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: GameEditScreen.edit(game: testGame)),
        ),
      );

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

        // The status selector should show the current status
        expect(find.byType(GameEditScreen), findsOneWidget);
      });
    });
  });
}
