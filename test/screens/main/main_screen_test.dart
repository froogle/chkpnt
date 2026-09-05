import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/main/main_screen.dart';
import 'package:chkpnt/screens/main/widgets/welcome_empty_state.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/models/game_models.dart';
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

    group('search focus dismissal', () {
      testWidgets('content list dismisses the keyboard on drag', (
        tester,
      ) async {
        container = TestHelpers.createTestContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: MainScreen()),
          ),
        );

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(
          scrollView.keyboardDismissBehavior,
          equals(ScrollViewKeyboardDismissBehavior.onDrag),
        );
      });

      testWidgets('dragging the games list unfocuses the search field', (
        tester,
      ) async {
        container = TestHelpers.createTestContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: MainScreen()),
          ),
        );

        await tester.tap(find.byType(TextField).first);
        await tester.pumpAndSettle();

        final field = tester.widget<TextField>(find.byType(TextField).first);
        expect(
          field.focusNode?.hasFocus,
          isTrue,
          reason: 'search field should hold focus after being tapped',
        );

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();

        expect(
          field.focusNode?.hasFocus,
          isFalse,
          reason: 'scrolling the list should release search focus',
        );
      });
    });


    testWidgets('does not show owned games in any section', (tester) async {
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MainScreen()),
        ),
      );

      final notifier = container.read(gameListProvider.notifier);
      await notifier.addGame(
        TestHelpers.createPlayingGame(title: 'Visible Playing Game'),
      );
      await notifier.addGame(
        GameItem.create(
          title: 'Hidden Owned Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      );

      final expansion = container.read(sectionExpansionProvider.notifier);
      for (final section in const [
        'Playing',
        'Ongoing/Frequently Played',
        'Backlog',
        'Completed',
        'Abandoned',
      ]) {
        expansion.expandSection(section);
      }

      await tester.pump();

      expect(find.text('Visible Playing Game'), findsOneWidget);
      expect(find.text('Hidden Owned Game'), findsNothing);
    });
  });
}
