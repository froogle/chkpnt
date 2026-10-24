import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/global_styles.dart';
import '../test_helpers.dart';

void main() {
  group('GameActionsService', () {
    late ProviderContainer container;
    late GameActionsService service;
    late GameItem testGame;

    setUp(() async {
      container = TestHelpers.createTestContainer();
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
      await container.read(gameListProvider.notifier).addGame(testGame);
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

    group('no-state toast', () {
      Widget buildHost(void Function(BuildContext) onPressed) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => onPressed(context),
                  child: const Text('Update'),
                );
              },
            ),
          ),
        );
      }

      Finder inSnackBar(Finder matching) {
        return find.descendant(of: find.byType(SnackBar), matching: matching);
      }

      testWidgets('shows a neutral glyph-free toast for a deselected game', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildHost((context) {
            service.updateGame(
              testGame,
              testGame.copyWith(status: GameStatus.owned),
              context,
            );
          }),
        );

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, AppColors.emptyStateIcon);
        expect(snackBar.backgroundColor, isNot(const Color(0xFF64748B)));
        expect(inSnackBar(find.byIcon(Icons.bookmark)), findsNothing);
        expect(inSnackBar(find.byType(Icon)), findsNothing);
      });

      testWidgets('keeps the deselection toast wording unchanged', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildHost((context) {
            service.updateGame(
              testGame,
              testGame.copyWith(status: GameStatus.owned),
              context,
            );
          }),
        );

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        expect(
          find.text('${testGame.title} moved to In Collection!'),
          findsOneWidget,
        );
        expect(
          container.read(sectionExpansionProvider).containsKey('In Collection'),
          isFalse,
        );
      });

      testWidgets('keeps every other status toast icon and colour', (
        tester,
      ) async {
        final expected = {
          GameStatus.completed: (
            'Completed',
            Icons.check_circle,
            Colors.green,
          ),
          GameStatus.playing: (
            'Playing',
            Icons.play_circle_fill,
            Colors.orange,
          ),
          GameStatus.ordered: (
            'Ordered',
            Icons.shopping_cart,
            Colors.purple,
          ),
          GameStatus.abandoned: (
            'Abandoned',
            Icons.do_not_disturb_on,
            Colors.grey,
          ),
          GameStatus.wishlist: (
            'Wishlist',
            Icons.favorite,
            Colors.pink,
          ),
        };

        for (final entry in expected.entries) {
          final (name, icon, colour) = entry.value;

          await tester.pumpWidget(
            buildHost((context) {
              service.updateGame(
                testGame,
                testGame.copyWith(status: entry.key),
                context,
              );
            }),
          );

          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();

          expect(
            find.text('${testGame.title} moved to $name!'),
            findsOneWidget,
            reason: '$name should keep its toast wording',
          );

          final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
          expect(
            snackBar.backgroundColor,
            colour,
            reason: '$name should keep its toast colour',
          );
          expect(
            snackBar.backgroundColor,
            isNot(AppColors.emptyStateIcon),
            reason: 'the neutral colour must not leak to $name',
          );

          expect(
            inSnackBar(find.byIcon(icon)),
            findsOneWidget,
            reason: '$name should keep its toast icon',
          );
          expect(
            tester.widget<Icon>(inSnackBar(find.byIcon(icon))).color,
            Colors.white,
          );

          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
        }
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
