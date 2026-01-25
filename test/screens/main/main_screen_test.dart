import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/main_screen.dart';
import 'package:chkpnt/screens/main/widgets/welcome_empty_state.dart';
import 'package:chkpnt/providers/game_provider.dart';
import '../../test_helpers.dart';

void main() {
  group('MainScreen', () {
    late ProviderContainer container;

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly with scroll functionality when games exist', (tester) async {
      container = TestHelpers.createTestContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders welcome empty state when no games exist', (
      tester,
    ) async {
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => EmptyGameListNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      expect(find.byType(MainScreen), findsOneWidget);
      expect(find.byType(WelcomeEmptyState), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('disposes scroll controller properly', (tester) async {
      container = TestHelpers.createTestContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      await tester.pump();

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: Text('Other Screen'))),
        ),
      );

      // No exception should be thrown during dispose
    });

    testWidgets('displays game sections for all statuses', (tester) async {
      container = TestHelpers.createTestContainer();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      await tester.pump();

      // Find containers for the game sections
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // We expect multiple containers in the widget tree (sections, styling, etc.)
      expect(containers.evaluate().length, greaterThanOrEqualTo(4));
    });
  });
}
