import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chkpnt/services/navigation_service.dart';

void main() {
  group('NavigationService', () {
    testWidgets('should not navigate when already on target screen', (
      tester,
    ) async {
      // Track navigation calls
      bool navigationCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/main',
          routes: {
            '/main':
                (context) => Scaffold(
                  body: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          // Try to navigate to the same screen
                          NavigationService.handleNavigation(
                            context,
                            NavigationService.homeIndex,
                          );
                        },
                        child: const Text('Navigate'),
                      );
                    },
                  ),
                ),
            '/backlog': (context) {
              navigationCalled = true;
              return const Scaffold(body: Text('Backlog'));
            },
          },
        ),
      );

      // Tap the button to trigger navigation to same screen
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should still be on main screen, no navigation called
      expect(find.text('Navigate'), findsOneWidget);
      expect(navigationCalled, false);
    });

    testWidgets('should navigate when on different screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/main',
          routes: {
            '/main':
                (context) => Scaffold(
                  body: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          NavigationService.handleNavigation(
                            context,
                            NavigationService.backlogIndex,
                          );
                        },
                        child: const Text('Navigate to Backlog'),
                      );
                    },
                  ),
                ),
            '/backlog':
                (context) => const Scaffold(body: Text('Backlog Screen')),
          },
        ),
      );

      // Tap the button to navigate to backlog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Should now be on backlog screen
      expect(find.text('Backlog Screen'), findsOneWidget);
      expect(find.text('Navigate to Backlog'), findsNothing);
    });

    test('route name mapping works correctly', () {
      expect(NavigationService.homeIndex, 0);
      expect(NavigationService.backlogIndex, 1);
      expect(NavigationService.physicalIndex, 2);
      expect(NavigationService.wishlistIndex, 3);
      expect(NavigationService.profileIndex, 4);
    });
  });
}
