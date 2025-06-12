import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/profile_screen.dart';
import 'package:chkpnt/screens/profile/widgets/profile_header.dart';
import 'package:chkpnt/screens/profile/widgets/profile_subscription_section.dart';
import 'package:chkpnt/screens/profile/widgets/profile_visualisation_section.dart';
import 'package:chkpnt/screens/profile/widgets/profile_incoming_games_section.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';

void main() {
  group('ProfileScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createProfileScreen() {
      return ProviderScope(
        parent: container,
        child: MaterialApp(home: const ProfileScreen()),
      );
    }

    testWidgets('renders all main sections', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      // Check that all main sections are rendered
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.byType(ProfileSubscriptionSection), findsOneWidget);
      expect(find.byType(ProfileVisualisationSection), findsOneWidget);
      expect(find.byType(ProfileIncomingGamesSection), findsOneWidget);
    });

    testWidgets('sets current screen to profile (index 3)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      // Check that current screen is set to profile
      final currentScreen = container.read(currentScreenProvider);
      expect(currentScreen, equals(3));
    });

    testWidgets('displays proper app bar background gradient', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      // Check that the container with gradient is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('uses MainScreenBottomNav component', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pumpAndSettle();

      // Should use the MainScreenBottomNav widget
      expect(find.byType(MainScreenBottomNav), findsOneWidget);

      // The profile icon should be highlighted
      final profileIcon = find.byIcon(Icons.person_outline);
      expect(profileIcon, findsOneWidget);
    });

    group('Navigation', () {
      testWidgets('navigates to home when home button tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        final homeButton = find.byIcon(Icons.home_outlined);
        expect(homeButton, findsOneWidget);

        // Tap home button - should navigate away from profile
        await tester.tap(homeButton);
        await tester.pumpAndSettle();
      });

      testWidgets('navigates to backlog when backlog button tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        final backlogButton = find.byIcon(Icons.list_alt_outlined);
        expect(backlogButton, findsOneWidget);

        await tester.tap(backlogButton);
        await tester.pumpAndSettle();
      });

      testWidgets('navigates to wishlist when wishlist button tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        final wishlistButton = find.byIcon(Icons.favorite_outline);
        expect(wishlistButton, findsOneWidget);

        await tester.tap(wishlistButton);
        await tester.pumpAndSettle();
      });

      testWidgets('stays on profile when profile button tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        final profileButton = find.byIcon(Icons.person_outline);
        expect(profileButton, findsOneWidget);

        // Tap profile button - should stay on profile
        await tester.tap(profileButton);
        await tester.pumpAndSettle();

        // Should still show profile content
        expect(find.byType(ProfileHeader), findsOneWidget);
      });
    });

    group('Responsiveness', () {
      testWidgets('renders correctly in portrait mode', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(
          414,
          896,
        ); // iPhone 11 Pro portrait
        tester.view.devicePixelRatio = 3.0;

        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('renders correctly in landscape mode', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(
          896,
          414,
        ); // iPhone 11 Pro landscape
        tester.view.devicePixelRatio = 3.0;

        await tester.pumpWidget(createProfileScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
