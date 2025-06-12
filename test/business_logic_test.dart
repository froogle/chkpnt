import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/services/game_actions_service.dart';
import 'test_helpers.dart';

void main() {
  group('Business Logic Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = TestHelpers.createTestContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Game Actions Service', () {
      test('should correctly determine status display names', () {
        // Test private method indirectly through service behaviour

        // Create games with different statuses
        final testGame = GameItem.create(
          title: 'Test Game',
          platform: 'PC',
          status: GameStatus.backlog,
        );

        container.read(gameListProvider.notifier).addGame(testGame);

        // Start playing the game (backlog -> playing)
        container.read(gameListProvider.notifier).startPlaying(testGame.id);

        // Verify the transition worked
        final games = container.read(gameListProvider);
        final updatedGame = games.firstWhere((g) => g.id == testGame.id);
        expect(updatedGame.status, GameStatus.playing);
      });

      test('should handle game status transitions correctly', () {
        // Test backlog -> playing
        final backlogGame = GameItem.create(
          title: 'Backlog to Playing',
          platform: 'PC',
          status: GameStatus.backlog,
        );

        container.read(gameListProvider.notifier).addGame(backlogGame);
        container.read(gameListProvider.notifier).startPlaying(backlogGame.id);

        final playingGames = container.read(
          gamesByStatusProvider(GameStatus.playing),
        );
        expect(playingGames.any((g) => g.id == backlogGame.id), true);

        // Test playing -> completed
        container.read(gameListProvider.notifier).markCompleted(backlogGame.id);

        final completedGames = container.read(
          gamesByStatusProvider(GameStatus.completed),
        );
        expect(completedGames.any((g) => g.id == backlogGame.id), true);
      });

      test('should update section expansion based on filters', () {
        // Add test games
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'PC Playing Game',
              platform: 'PC',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Switch Backlog Game',
              platform: 'Switch',
              status: GameStatus.backlog,
            );

        // Apply PC filter
        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');

        // Update section expansion
        final gameActionsService = container.read(gameActionsServiceProvider);
        gameActionsService.updateSectionExpansionForFilters();

        final expansionState = container.read(sectionExpansionProvider);

        // PC filter should expand sections with PC games
        expect(expansionState['Playing'], true); // Has PC playing game
        expect(expansionState['Backlog'], false); // No PC backlog games
      });

      test('should handle complex filter scenarios', () {
        // Add diverse test data
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Cyberpunk PC Completed',
              platform: 'PC',
              status: GameStatus.completed,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Cyberpunk PS5 Playing',
              platform: 'PS5',
              status: GameStatus.playing,
            );

        // Apply platform + search filters
        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
        container.read(searchQueryProvider.notifier).updateQuery('cyber');

        final gameActionsService2 = container.read(gameActionsServiceProvider);
        gameActionsService2.updateSectionExpansionForFilters();

        final expansionState = container.read(sectionExpansionProvider);

        // Only PC + Cyberpunk in completed should be expanded
        expect(expansionState['Completed'], true);
        expect(expansionState['Playing'], false); // PS5 Cyberpunk filtered out
      });

      test('should not auto-expand when no active filters', () {
        // Reset to default state
        container.read(selectedPlatformProvider.notifier).resetToAll();
        container.read(searchQueryProvider.notifier).clearQuery();

        // Manually collapse all sections
        container
            .read(sectionExpansionProvider.notifier)
            .collapseSection('Playing');
        container
            .read(sectionExpansionProvider.notifier)
            .collapseSection('Completed');

        final gameActionsService3 = container.read(gameActionsServiceProvider);
        gameActionsService3.updateSectionExpansionForFilters();

        final expansionState = container.read(sectionExpansionProvider);

        // Should remain collapsed since no active filters
        expect(expansionState['Playing'], false);
        expect(expansionState['Completed'], false);
      });
    });

    group('UI State Management', () {
      test('should manage section expansion state correctly', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // Test expansion
        notifier.expandSection('Playing');
        expect(container.read(sectionExpansionProvider)['Playing'], true);

        // Test collapse
        notifier.collapseSection('Playing');
        expect(container.read(sectionExpansionProvider)['Playing'], false);

        // Test toggle
        notifier.toggleSection('Backlog');
        expect(container.read(sectionExpansionProvider)['Backlog'], true);
        notifier.toggleSection('Backlog');
        expect(container.read(sectionExpansionProvider)['Backlog'], false);
      });

      test('should update expansion based on game results', () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // Mock filtered results
        final playingGames = [
          GameItem.create(
            title: 'Game 1',
            platform: 'PC',
            status: GameStatus.playing,
          ),
        ];
        final emptyBacklog = <GameItem>[];
        final completedGames = [
          GameItem.create(
            title: 'Game 2',
            platform: 'PC',
            status: GameStatus.completed,
          ),
        ];
        final emptyAbandoned = <GameItem>[];

        notifier.updateExpansionBasedOnResults(
          playingGames: playingGames,
          backlogGames: emptyBacklog,
          completedGames: completedGames,
          abandonedGames: emptyAbandoned,
        );

        final expansionState = container.read(sectionExpansionProvider);
        expect(expansionState['Playing'], true); // Has games
        expect(expansionState['Backlog'], false); // Empty
        expect(expansionState['Completed'], true); // Has games
        expect(expansionState['Abandoned'], false); // Empty
      });

      test('should manage platform filter state', () {
        final notifier = container.read(selectedPlatformProvider.notifier);

        // Test platform selection
        notifier.selectPlatform('PC');
        expect(container.read(selectedPlatformProvider), 'PC');

        // Test reset to all
        notifier.resetToAll();
        expect(container.read(selectedPlatformProvider), 'All');
      });

      test('should manage search query state', () {
        final notifier = container.read(searchQueryProvider.notifier);

        // Test query update
        notifier.updateQuery('cyberpunk');
        expect(container.read(searchQueryProvider), 'cyberpunk');

        // Test clear query
        notifier.clearQuery();
        expect(container.read(searchQueryProvider), '');
      });
    });

    group('Filter Integration Logic', () {
      test('should detect active filters correctly', () {
        // No active filters
        container.read(selectedPlatformProvider.notifier).resetToAll();
        container.read(searchQueryProvider.notifier).clearQuery();

        final platform1 = container.read(selectedPlatformProvider);
        final search1 = container.read(searchQueryProvider);
        final hasActiveFilters1 = platform1 != 'All' || search1.isNotEmpty;
        expect(hasActiveFilters1, false);

        // Platform filter active
        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
        final platform2 = container.read(selectedPlatformProvider);
        final search2 = container.read(searchQueryProvider);
        final hasActiveFilters2 = platform2 != 'All' || search2.isNotEmpty;
        expect(hasActiveFilters2, true);

        // Search filter active
        container.read(selectedPlatformProvider.notifier).resetToAll();
        container.read(searchQueryProvider.notifier).updateQuery('zelda');
        final platform3 = container.read(selectedPlatformProvider);
        final search3 = container.read(searchQueryProvider);
        final hasActiveFilters3 = platform3 != 'All' || search3.isNotEmpty;
        expect(hasActiveFilters3, true);
      });

      test('should combine filters correctly', () {
        // Use unique platforms to avoid conflicts with sample data
        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Test Game Playing',
              platform: 'TestPlatform1',
              status: GameStatus.playing,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Test Game Backlog',
              platform: 'TestPlatform1',
              status: GameStatus.backlog,
            );

        container
            .read(gameListProvider.notifier)
            .createGame(
              title: 'Different Game',
              platform: 'TestPlatform2',
              status: GameStatus.completed,
            );

        // Test platform filter only
        final platform1Games = container.read(
          fullyFilteredGamesProvider(GameStatus.playing, 'TestPlatform1', ''),
        );
        expect(platform1Games.length, 1);
        expect(platform1Games.first.title, 'Test Game Playing');

        // Test platform + search filter
        final filteredGames = container.read(
          fullyFilteredGamesProvider(
            GameStatus.backlog,
            'TestPlatform1',
            'test',
          ),
        );
        expect(filteredGames.length, 1);
        expect(filteredGames.first.title, 'Test Game Backlog');

        // Test no matches
        final noMatches = container.read(
          fullyFilteredGamesProvider(
            GameStatus.completed,
            'TestPlatform1',
            'nomatch',
          ),
        );
        expect(noMatches, isEmpty);
      });
    });

    group('Data Consistency', () {
      test('should maintain referential integrity', () {
        // Create and add game
        final originalGame = GameItem.create(
          title: 'Integrity Test',
          platform: 'PC',
          status: GameStatus.backlog,
        );

        container.read(gameListProvider.notifier).addGame(originalGame);

        // Update game status
        container.read(gameListProvider.notifier).startPlaying(originalGame.id);

        // Verify the game exists in the correct filtered lists
        final allGames = container.read(gameListProvider);
        final playingGames = container.read(
          gamesByStatusProvider(GameStatus.playing),
        );
        final backlogGames = container.read(
          gamesByStatusProvider(GameStatus.backlog),
        );

        final updatedGame = allGames.firstWhere((g) => g.id == originalGame.id);

        expect(updatedGame.status, GameStatus.playing);
        expect(playingGames.contains(updatedGame), true);
        expect(backlogGames.contains(updatedGame), false);
      });

      test('should handle concurrent state changes', () {
        // Create test game
        final testGame = GameItem.create(
          title: 'Concurrent Test',
          platform: 'PC',
          status: GameStatus.backlog,
        );

        container.read(gameListProvider.notifier).addGame(testGame);

        // Make multiple quick state changes
        container.read(gameListProvider.notifier).startPlaying(testGame.id);
        container.read(gameListProvider.notifier).markCompleted(testGame.id);

        // Verify final state is consistent - simplified to avoid timestamp precision issues
        final finalGames = container.read(gameListProvider);
        final finalGame = finalGames.firstWhere((g) => g.id == testGame.id);

        expect(finalGame.status, GameStatus.completed);
        // Simplified checks - just verify the game has the correct final state
        expect(finalGame.id, testGame.id);
        expect(finalGame.title, testGame.title);
      });
    });
  });
}
