import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/services/navigation_service.dart';
import 'package:chkpnt/styles/styles.dart';

void main() {
  group('MainScreenBottomNav', () {
    const routeLabels = <String, String>{
      '/main': 'Home Screen',
      '/backlog': 'Backlog Screen',
      '/collection': 'Collection Screen',
      '/wishlist': 'Wishlist Screen',
      '/profile': 'Profile Screen',
    };

    Widget buildNavApp(String initialRoute) {
      return ProviderScope(
        child: MaterialApp(
          initialRoute: initialRoute,
          routes: {
            for (final entry in routeLabels.entries)
              entry.key:
                  (context) => Scaffold(
                    body: Column(
                      children: [
                        Text(entry.value),
                        const Spacer(),
                        MainScreenBottomNav(
                          onNavItemPressed:
                              (index) => NavigationService.handleNavigation(
                                context,
                                index,
                              ),
                        ),
                      ],
                    ),
                  ),
          },
        ),
      );
    }

    Widget buildNavOnly(void Function(int) onPressed) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Spacer(),
                MainScreenBottomNav(onNavItemPressed: onPressed),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('gives every nav item a tap target of at least 48x48', (
      tester,
    ) async {
      await tester.pumpWidget(buildNavOnly((_) {}));

      final items = find.byType(IconButton);
      expect(items, findsNWidgets(5));

      for (var index = 0; index < 5; index++) {
        final size = tester.getSize(items.at(index));
        expect(
          size.width,
          greaterThanOrEqualTo(48.0),
          reason: 'nav item $index is too narrow',
        );
        expect(
          size.height,
          greaterThanOrEqualTo(48.0),
          reason: 'nav item $index is too short',
        );
      }
    });

    testWidgets('routes each of the five items to its own screen', (
      tester,
    ) async {
      final destinations = <int, String>{
        NavigationService.homeIndex: '/main',
        NavigationService.backlogIndex: '/backlog',
        NavigationService.collectionIndex: '/collection',
        NavigationService.wishlistIndex: '/wishlist',
        NavigationService.profileIndex: '/profile',
      };

      for (final entry in destinations.entries) {
        final startRoute = entry.value == '/main' ? '/profile' : '/main';
        await tester.pumpWidget(buildNavApp(startRoute));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(IconButton).at(entry.key));
        await tester.pumpAndSettle();

        expect(
          find.text(routeLabels[entry.value]!),
          findsOneWidget,
          reason: 'item ${entry.key} should route to ${entry.value}',
        );
      }
    });

    testWidgets('reports each item index independently', (tester) async {
      final pressed = <int>[];
      await tester.pumpWidget(buildNavOnly(pressed.add));

      for (var index = 0; index < 5; index++) {
        await tester.tap(find.byType(IconButton).at(index));
        await tester.pump();
      }

      expect(pressed, [0, 1, 2, 3, 4]);
    });

    testWidgets('activates an item when tapped near its vertical extremes', (
      tester,
    ) async {
      final pressed = <int>[];
      await tester.pumpWidget(buildNavOnly(pressed.add));

      for (var index = 0; index < 5; index++) {
        final rect = tester.getRect(find.byType(IconButton).at(index));

        await tester.tapAt(Offset(rect.center.dx, rect.top + 1));
        await tester.pump();
        await tester.tapAt(Offset(rect.center.dx, rect.bottom - 1));
        await tester.pump();
      }

      expect(pressed, [0, 0, 1, 1, 2, 2, 3, 3, 4, 4]);
    });

    testWidgets('leaves the overall bar height unchanged', (tester) async {
      await tester.pumpWidget(buildNavOnly((_) {}));

      expect(MainScreenStyles.bottomNavHeight, 48.0);

      expect(
        tester.getSize(find.byType(MainScreenBottomNav)).height,
        MainScreenStyles.bottomNavHeight,
      );
    });

    testWidgets('keeps the active and inactive icon sizes and colours', (
      tester,
    ) async {
      await tester.pumpWidget(buildNavApp('/main'));
      await tester.pumpAndSettle();

      final activeIcon = tester.widget<Icon>(find.byIcon(Icons.home_outlined));
      expect(activeIcon.size, 24);
      expect(activeIcon.color, AppColors.primaryPurple);

      final inactiveIcon = tester.widget<Icon>(
        find.byIcon(Icons.list_alt_outlined),
      );
      expect(inactiveIcon.size, 22);
      expect(
        inactiveIcon.color,
        AppColors.primaryPurple.withValues(alpha: 0.5),
      );
    });
  });
}
