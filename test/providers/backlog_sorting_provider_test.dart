import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

void main() {
  group('BacklogSort Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have default sort type as title', () {
      final sortType = container.read(backlogSortProvider);
      expect(sortType, BacklogSortType.title);
    });

    test('should update sort type', () {
      final notifier = container.read(backlogSortProvider.notifier);

      // Change to date added
      notifier.setSortType(BacklogSortType.dateAdded);
      expect(container.read(backlogSortProvider), BacklogSortType.dateAdded);

      // Change back to title
      notifier.setSortType(BacklogSortType.title);
      expect(container.read(backlogSortProvider), BacklogSortType.title);
    });
  });

  group('BacklogSortDirectionState Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have default sort direction as ascending', () {
      final sortDirection = container.read(backlogSortDirectionStateProvider);
      expect(sortDirection, SortDirection.ascending);
    });

    test('should update sort direction', () {
      final notifier = container.read(
        backlogSortDirectionStateProvider.notifier,
      );

      // Change to descending
      notifier.setSortDirection(SortDirection.descending);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );

      // Change back to ascending
      notifier.setSortDirection(SortDirection.ascending);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );
    });

    test('should toggle sort direction', () {
      final notifier = container.read(
        backlogSortDirectionStateProvider.notifier,
      );

      // Initially ascending
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );

      // Toggle to descending
      notifier.toggleDirection();
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );

      // Toggle back to ascending
      notifier.toggleDirection();
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );
    });
  });

  group('CurrentScreen Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should have default screen as home (0)', () {
      final currentScreen = container.read(currentScreenProvider);
      expect(currentScreen, 0);
    });

    test('should update current screen', () {
      final notifier = container.read(currentScreenProvider.notifier);

      // Navigate to backlog (index 1)
      notifier.setScreen(1);
      expect(container.read(currentScreenProvider), 1);

      // Navigate to wishlist (index 2)
      notifier.setScreen(2);
      expect(container.read(currentScreenProvider), 2);

      // Navigate back to home (index 0)
      notifier.setScreen(0);
      expect(container.read(currentScreenProvider), 0);

      // Navigate to profile (index 3)
      notifier.setScreen(3);
      expect(container.read(currentScreenProvider), 3);
    });
  });

  group('Backlog Sorting Integration', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should coordinate sort type and direction changes', () {
      final sortNotifier = container.read(backlogSortProvider.notifier);
      final directionNotifier = container.read(
        backlogSortDirectionStateProvider.notifier,
      );

      // Set up non-default state
      sortNotifier.setSortType(BacklogSortType.dateAdded);
      directionNotifier.setSortDirection(SortDirection.descending);

      expect(container.read(backlogSortProvider), BacklogSortType.dateAdded);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );

      // Simulate changing sort type (should reset direction to ascending)
      sortNotifier.setSortType(BacklogSortType.title);
      directionNotifier.setSortDirection(SortDirection.ascending);

      expect(container.read(backlogSortProvider), BacklogSortType.title);
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );
    });

    test('should maintain sort direction when toggling same sort type', () {
      final directionNotifier = container.read(
        backlogSortDirectionStateProvider.notifier,
      );

      // Start with ascending
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );

      // Toggle direction multiple times
      directionNotifier.toggleDirection();
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );

      directionNotifier.toggleDirection();
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.ascending,
      );

      directionNotifier.toggleDirection();
      expect(
        container.read(backlogSortDirectionStateProvider),
        SortDirection.descending,
      );
    });
  });
}
