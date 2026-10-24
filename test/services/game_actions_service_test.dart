import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/styles/global_styles.dart';
import 'package:chkpnt/styles/status_styles.dart';
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

        expect(
          container.read(
            sectionExpandedProvider(const StatusSection(GameStatus.completed)),
          ),
          isTrue,
        );
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
          container
              .read(sectionExpansionProvider)
              .containsKey(const StatusSection(GameStatus.owned)),
          isFalse,
        );
      });

      testWidgets(
        'presents every other Status toast as Status presentation does',
        (tester) async {
          final statuses = GameStatus.values.where(
            (status) => status != GameStatus.owned && status != testGame.status,
          );

          for (final status in statuses) {
            final style = StatusStyles.of(status);

            await tester.pumpWidget(
              buildHost((context) {
                service.updateGame(
                  testGame,
                  testGame.copyWith(status: status),
                  context,
                );
              }),
            );

            await tester.tap(find.text('Update'));
            await tester.pumpAndSettle();

            expect(
              find.text('${testGame.title} moved to ${style.label}!'),
              findsOneWidget,
              reason: '$status toast wording',
            );
            final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
            expect(snackBar.backgroundColor, style.colour, reason: '$status');
            expect(
              inSnackBar(find.byIcon(style.icon!)),
              findsOneWidget,
              reason: '$status toast icon',
            );
            expect(
              container.read(sectionExpandedProvider(StatusSection(status))),
              isTrue,
              reason: '$status section expands',
            );

            await tester.pumpWidget(const SizedBox.shrink());
            await tester.pumpAndSettle();
          }
        },
      );

      testWidgets('presents the start playing toast as Playing', (
        tester,
      ) async {
        final style = StatusStyles.of(GameStatus.playing);

        await tester.pumpWidget(
          buildHost((context) {
            service.startPlayingGame(testGame, context);
          }),
        );

        await tester.tap(find.text('Update'));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();

        expect(
          find.text('${testGame.title} moved to ${style.label}!'),
          findsOneWidget,
        );
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, style.colour);
        expect(inSnackBar(find.byIcon(style.icon!)), findsOneWidget);
      });
    });
  });
}
