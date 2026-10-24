import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/backlog/backlog_screen.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import '../../test_helpers.dart';

void main() {
  group('BacklogScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders correctly and shows empty state by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      // Verify the backlog screen renders
      expect(find.byType(BacklogScreen), findsOneWidget);

      // Should show empty state when no games present
      expect(find.text('No games in backlog'), findsOneWidget);
      expect(find.text('Add some games to get started!'), findsOneWidget);
    });

    testWidgets('disposes scroll controller properly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
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

    testWidgets('adding a Game shows one confirmation', (tester) async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );
      await container
          .read(gameListProvider.notifier)
          .addGame(TestHelpers.createBacklogGame(title: 'Hades'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Celeste');
      await tester.tap(find.byIcon(Icons.gamepad_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ListTile, 'PC'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Game'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Celeste added to Backlog!'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('does not list owned games', (tester) async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      final notifier = container.read(gameListProvider.notifier);
      await notifier.addGame(
        TestHelpers.createBacklogGame(title: 'Visible Backlog Game'),
      );
      await notifier.addGame(
        GameItem.create(
          title: 'Hidden Owned Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      );

      await tester.pump();

      expect(find.text('Visible Backlog Game'), findsOneWidget);
      expect(find.text('Hidden Owned Game'), findsNothing);
    });

    testWidgets('a single tap collapses a platform section', (tester) async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );

      await container
          .read(gameListProvider.notifier)
          .addGame(
            TestHelpers.createBacklogGame(
              title: 'Collapsible Backlog Game',
              platform: 'PS5',
            ),
          );
      await tester.pump();

      expect(find.text('Collapsible Backlog Game'), findsOneWidget);

      await tester.tap(
        find
            .descendant(
              of: find.byWidgetPredicate(
                (widget) =>
                    widget is SlimSectionHeader && widget.title == 'PS5',
              ),
              matching: find.byType(InkWell),
            )
            .first,
      );
      await tester.pump();

      expect(find.text('Collapsible Backlog Game'), findsNothing);
    });
  });
}
