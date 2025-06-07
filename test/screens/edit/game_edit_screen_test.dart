import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chkpnt/screens/edit/game_edit_screen.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('GameEditScreen', () {
    late GameItem testGame;

    setUp(() {
      testGame = const GameItem(
        id: GameId('test-id'),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.playing,
        progress: 0.5,
      );
    });

    testWidgets('renders correctly with game data', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(find.text('Edit Game'), findsOneWidget);
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test Platform'), findsOneWidget);
    });

    testWidgets('shows app bar with back button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.text('Edit Game'), findsOneWidget);
    });

    testWidgets('displays save button that is initially disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      final saveButton = find.text('Save Changes');
      expect(saveButton, findsOneWidget);

      // Button should be disabled initially (no changes)
      final elevatedButton = tester.widget<ElevatedButton>(
        find.ancestor(of: saveButton, matching: find.byType(ElevatedButton)),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('enables save button when title is changed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      // Find and modify the title field
      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'Modified Game Title');
      await tester.pump();

      // Save button should now be enabled
      final saveButton = find.text('Save Changes');
      final elevatedButton = tester.widget<ElevatedButton>(
        find.ancestor(of: saveButton, matching: find.byType(ElevatedButton)),
      );
      expect(elevatedButton.onPressed, isNotNull);
    });

    testWidgets('shows status buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      // Check that status buttons are present
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Abandoned'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Backlog'), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);
    });

    testWidgets('handles back button press without changes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameEditScreen(game: testGame)),
          ),
        ),
      );

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      // Should navigate back without showing dialog
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('shows unsaved changes dialog when back pressed with changes', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GameEditScreen(game: testGame)),
          ),
        ),
      );

      // Make a change
      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'Modified Title');
      await tester.pump();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      // Should show unsaved changes dialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Unsaved Changes'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('works in landscape orientation', (tester) async {
      // Set landscape orientation
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: GameEditScreen(game: testGame))),
      );

      expect(find.byType(GameEditScreen), findsOneWidget);
      expect(find.text('Test Game'), findsOneWidget);
      expect(find.text('Test Platform'), findsOneWidget);

      // Reset to portrait
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
