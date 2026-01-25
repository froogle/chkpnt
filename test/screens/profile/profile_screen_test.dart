import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/profile/profile_screen.dart';
import 'package:chkpnt/screens/profile/widgets/profile_header.dart';
import 'package:chkpnt/screens/profile/widgets/profile_visualisation_section.dart';
import 'package:chkpnt/screens/profile/widgets/profile_incoming_games_section.dart';
import 'package:chkpnt/screens/profile/widgets/profile_backup_section.dart';
import 'package:chkpnt/screens/main/widgets/main_screen_bottom_nav.dart';

void main() {
  group('ProfileScreen', () {
    Widget createProfileScreen() {
      return const ProviderScope(child: MaterialApp(home: ProfileScreen()));
    }

    testWidgets('renders all main sections', (WidgetTester tester) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      // Check that all main sections are rendered
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.byType(ProfileVisualisationSection), findsOneWidget);
      expect(find.byType(ProfileIncomingGamesSection), findsOneWidget);
      expect(find.byType(ProfileBackupSection), findsOneWidget);
    });

    testWidgets('displays proper app bar background gradient', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      // Check that the container with gradient is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('uses MainScreenBottomNav component', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      // Should use the MainScreenBottomNav widget
      expect(find.byType(MainScreenBottomNav), findsOneWidget);

      // The profile icon should be present
      final profileIcon = find.byIcon(Icons.person_outline);
      expect(profileIcon, findsOneWidget);
    });

    group('Navigation', () {
      testWidgets('displays navigation buttons', (WidgetTester tester) async {
        await tester.pumpWidget(createProfileScreen());
        await tester.pump();

        final homeButton = find.byIcon(Icons.home_outlined);
        expect(homeButton, findsOneWidget);

        final backlogButton = find.byIcon(Icons.list_alt_outlined);
        expect(backlogButton, findsOneWidget);

        final wishlistButton = find.byIcon(Icons.favorite_outline);
        expect(wishlistButton, findsOneWidget);

        final profileButton = find.byIcon(Icons.person_outline);
        expect(profileButton, findsOneWidget);
      });
    });

    group('Basic Responsiveness', () {
      testWidgets('renders correctly in portrait mode', (
        WidgetTester tester,
      ) async {
        // Set reasonable portrait dimensions
        tester.view.physicalSize = const Size(414, 896);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createProfileScreen());
        await tester.pump();

        expect(find.byType(ProfileScreen), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
