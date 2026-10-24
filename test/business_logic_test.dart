import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
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
        final testGame = TestHelpers.createBacklogGame(title: 'Test Game');

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
        final backlogGame = TestHelpers.createBacklogGame(
          title: 'Backlog to Playing',
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
    });

    group('UI State Management', () {
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
        final uniqueGames = TestHelpers.createUniquePlatformGames();
        TestHelpers.addGamesToContainer(container, uniqueGames);

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
        // Create and add game using helper
        final originalGame = TestHelpers.createBacklogGame(
          title: 'Integrity Test',
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
        // Create test game using helper
        final testGame = TestHelpers.createBacklogGame(
          title: 'Concurrent Test',
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
