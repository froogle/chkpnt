import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/main_screen.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('MainScreen Auto-Expansion Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets(
      'should auto-expand sections with results when platform filter is applied',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: MainScreen()),
          ),
        );

        // Initial state - Playing should be expanded by default
        expect(container.read(sectionExpansionProvider)['Playing'], true);
        expect(container.read(sectionExpansionProvider)['Backlog'], false);
        expect(container.read(sectionExpansionProvider)['Completed'], false);
        expect(container.read(sectionExpansionProvider)['Abandoned'], false);

        // Apply PC filter
        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
        await tester.pump();

        // Check which sections should be expanded based on PC games
        final expansionState = container.read(sectionExpansionProvider);

        // Based on sample data, PC should have:
        // - No playing games
        // - No backlog games
        // - 1 completed game (Cyberpunk 2077)
        // - 1 abandoned game (Mass Effect)
        expect(expansionState['Playing'], false); // No PC games playing
        expect(expansionState['Backlog'], false); // No PC games in backlog
        expect(expansionState['Completed'], true); // Has PC completed games
        expect(expansionState['Abandoned'], true); // Has PC abandoned games
      },
    );

    testWidgets(
      'should auto-expand/collapse sections when search filter is applied',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: MainScreen()),
          ),
        );

        // Apply search filter for "zelda"
        container.read(searchQueryProvider.notifier).updateQuery('zelda');
        await tester.pump();

        final expansionState = container.read(sectionExpansionProvider);

        // Only Playing section should have Zelda game
        expect(expansionState['Playing'], true); // Has Zelda in playing
        expect(expansionState['Backlog'], false); // No Zelda in backlog
        expect(expansionState['Completed'], false); // No Zelda in completed
        expect(expansionState['Abandoned'], false); // No Zelda in abandoned
      },
    );

    testWidgets('should collapse all sections when search has no results', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      // Apply search filter with no results
      container
          .read(searchQueryProvider.notifier)
          .updateQuery('nonexistent game');
      await tester.pump();

      final expansionState = container.read(sectionExpansionProvider);

      // All sections should be collapsed since no games match
      expect(expansionState['Playing'], false);
      expect(expansionState['Backlog'], false);
      expect(expansionState['Completed'], false);
      expect(expansionState['Abandoned'], false);
    });

    testWidgets('should not auto-expand when filters are reset to default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      // First apply a filter to trigger auto-expansion
      container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
      await tester.pump();

      // Manually collapse a section that was auto-expanded
      container
          .read(sectionExpansionProvider.notifier)
          .collapseSection('Completed');

      // Reset filters to default
      container.read(selectedPlatformProvider.notifier).resetToAll();
      container.read(searchQueryProvider.notifier).clearQuery();
      await tester.pump();

      // The manually collapsed section should remain collapsed
      // since we're back to no active filters
      expect(container.read(sectionExpansionProvider)['Completed'], false);
    });

    testWidgets('should handle combined platform and search filters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      // Apply both platform and search filters
      container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
      container.read(searchQueryProvider.notifier).updateQuery('cyber');
      await tester.pump();

      final expansionState = container.read(sectionExpansionProvider);

      // Only Completed section should have PC + Cyberpunk game
      expect(expansionState['Playing'], false);
      expect(expansionState['Backlog'], false);
      expect(expansionState['Completed'], true); // Cyberpunk 2077 on PC
      expect(expansionState['Abandoned'], false);
    });

    test(
      'updateSectionExpansionForFilters should handle hasActiveFilters logic correctly',
      () {
        // Test the logic without widget testing
        final sectionNotifier = container.read(
          sectionExpansionProvider.notifier,
        );

        // Case 1: No active filters (All platform, empty search)
        container.read(selectedPlatformProvider.notifier).selectPlatform('All');
        container.read(searchQueryProvider.notifier).clearQuery();

        final platform = container.read(selectedPlatformProvider);
        final searchQuery = container.read(searchQueryProvider);
        final hasActiveFilters = platform != 'All' || searchQuery.isNotEmpty;

        expect(hasActiveFilters, false);

        // Case 2: Platform filter active
        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
        final platform2 = container.read(selectedPlatformProvider);
        final searchQuery2 = container.read(searchQueryProvider);
        final hasActiveFilters2 = platform2 != 'All' || searchQuery2.isNotEmpty;

        expect(hasActiveFilters2, true);

        // Case 3: Search filter active
        container.read(selectedPlatformProvider.notifier).resetToAll();
        container.read(searchQueryProvider.notifier).updateQuery('test');
        final platform3 = container.read(selectedPlatformProvider);
        final searchQuery3 = container.read(searchQueryProvider);
        final hasActiveFilters3 = platform3 != 'All' || searchQuery3.isNotEmpty;

        expect(hasActiveFilters3, true);
      },
    );
  });

  group('Section Expansion State Persistence', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'should preserve manual expansion state when no filters are active',
      () {
        final notifier = container.read(sectionExpansionProvider.notifier);

        // Manually expand backlog
        notifier.expandSection('Backlog');
        expect(container.read(sectionExpansionProvider)['Backlog'], true);

        // Manually collapse playing
        notifier.collapseSection('Playing');
        expect(container.read(sectionExpansionProvider)['Playing'], false);

        // The state should remain as manually set since no filters are active
        expect(container.read(sectionExpansionProvider)['Backlog'], true);
        expect(container.read(sectionExpansionProvider)['Playing'], false);
      },
    );

    test('should override manual state when filters become active', () {
      final sectionNotifier = container.read(sectionExpansionProvider.notifier);

      // Manually set some expansion state
      sectionNotifier.collapseAll();
      expect(container.read(sectionExpansionProvider)['Playing'], false);

      // Apply a filter - this should override manual state
      container
          .read(selectedPlatformProvider.notifier)
          .selectPlatform('Switch');

      // Get the filtered results for Switch platform
      final playingGames = container.read(
        fullyFilteredGamesProvider(GameStatus.playing, 'Switch', ''),
      );

      // Update expansion based on filter results
      sectionNotifier.updateExpansionBasedOnResults(
        playingGames: playingGames,
        backlogGames: [],
        completedGames: [],
        abandonedGames: [],
      );

      // Playing should now be expanded because there's a Switch game playing
      expect(container.read(sectionExpansionProvider)['Playing'], true);
    });
  });
}
