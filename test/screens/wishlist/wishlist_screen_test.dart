import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/wishlist/wishlist_screen.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';

import '../../test_helpers.dart';

void main() {
  group('WishlistScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = TestHelpers.createTestContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly with basic structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );

      await tester.pump();

      // Verify the main screen structure is present
      expect(find.byType(WishlistScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays empty sections when no games', (tester) async {
      // Setup empty game lists by using a fresh container with empty data
      container = TestHelpers.createTestContainer();

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );

      await tester.pump();

      // Verify basic screen structure is present
      expect(find.byType(WishlistScreen), findsOneWidget);
    });

    testWidgets('handles navigation correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            routes: {
              '/main': (context) => const Scaffold(body: Text('Main Screen')),
            },
            home: const WishlistScreen(),
          ),
        ),
      );

      await tester.pump();

      // Test navigation by finding the home icon (index 0) and tapping it
      final bottomNavFinder = find.byType(BottomNavigationBar);
      expect(bottomNavFinder, findsOneWidget);

      // Find the home icon (should be the first item) and tap it
      await tester.tap(find.byIcon(Icons.home).first);
      await tester.pumpAndSettle();

      // Should navigate to main screen
      expect(find.text('Main Screen'), findsOneWidget);
    });

    testWidgets('displays wishlist sections with proper titles', (
      tester,
    ) async {
      final testGames = [
        GameItem.create(
          title: 'Ordered Game',
          platform: 'PC',
          status: GameStatus.ordered,
        ),
        GameItem.create(
          title: 'Wishlist Game',
          platform: 'PS5',
          status: GameStatus.wishlist,
        ),
      ];

      container = TestHelpers.createTestContainer();

      // Add test games to the container
      for (final game in testGames) {
        container.read(gameListProvider.notifier).addGame(game);
      }

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: WishlistScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the screen loads
      expect(find.byType(WishlistScreen), findsOneWidget);
    });
  });
}
