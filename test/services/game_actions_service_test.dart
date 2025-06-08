import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

void main() {
  group('GameActionsService', () {
    late ProviderContainer container;
    late GameActionsService service;
    late GameItem testGame;

    setUp(() {
      container = ProviderContainer();
      service = container.read(gameActionsServiceProvider);
      testGame = GameItem(
        id: GameId.generate(),
        title: 'Test Game',
        platform: 'Test Platform',
        status: GameStatus.backlog,
        lastModified: DateTime.now(),
        lastStatusChange: DateTime.now(),
      );

      // Add test game to provider
      container.read(gameListProvider.notifier).addGame(testGame);
    });

    tearDown(() {
      container.dispose();
    });

    group('updateGame', () {
      testWidgets('should update game with new details', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      final updatedGame = testGame.copyWith(
                        title: 'Updated Title',
                        platform: 'PS5',
                        status: GameStatus.playing,
                      );
                      service.updateGame(testGame, updatedGame, context);
                    },
                    child: const Text('Update'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Update'));
        await tester.pump();

        final games = container.read(gameListProvider);
        final savedGame = games.firstWhere((g) => g.id == testGame.id);

        expect(savedGame.title, 'Updated Title');
        expect(savedGame.platform, 'PS5');
        expect(savedGame.status, GameStatus.playing);
      });

      testWidgets('should expand relevant section when status changes', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      final updatedGame = testGame.copyWith(
                        status: GameStatus.completed,
                      );
                      service.updateGame(testGame, updatedGame, context);
                    },
                    child: const Text('Update'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Update'));
        await tester.pump();

        final sectionExpansion = container.read(sectionExpansionProvider);
        expect(sectionExpansion['Completed'], true);
      });

      testWidgets('should show feedback when updating', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      final updatedGame = testGame.copyWith(title: 'New Title');
                      service.updateGame(testGame, updatedGame, context);
                    },
                    child: const Text('Update'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        expect(find.text('New Title details updated!'), findsOneWidget);
      });
    });

    group('updateSectionExpansionForFilters', () {
      test('should not change expansion when no filters active', () {
        // Set initial state
        container.read(sectionExpansionProvider.notifier).expandAll();

        service.updateSectionExpansionForFilters();

        final sectionExpansion = container.read(sectionExpansionProvider);
        expect(sectionExpansion['Playing'], true);
        expect(sectionExpansion['Backlog'], true);
      });

      test('should update expansion based on filtered results', () {
        // Set a platform filter
        container
            .read(selectedPlatformProvider.notifier)
            .selectPlatform('NonExistent');

        service.updateSectionExpansionForFilters();

        final sectionExpansion = container.read(sectionExpansionProvider);
        // All sections should be collapsed as no games match the filter
        expect(sectionExpansion['Playing'], false);
        expect(sectionExpansion['Backlog'], false);
        expect(sectionExpansion['Completed'], false);
        expect(sectionExpansion['Abandoned'], false);
      });
    });
  });
}
