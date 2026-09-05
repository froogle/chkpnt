import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/collection/collection_screen.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';
import 'package:chkpnt/services/navigation_service.dart';
import 'package:chkpnt/models/game_models.dart';
import '../../test_helpers.dart';

void main() {
  group('CollectionScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          gameListProvider.overrideWith(() => IsolatedTestGameListNotifier()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: CollectionScreen()),
        ),
      );
    }

    Future<void> addGames(List<GameItem> games) async {
      final notifier = container.read(gameListProvider.notifier);
      for (final game in games) {
        await notifier.addGame(game);
      }
    }

    Finder headerNamed(String title) {
      return find.byWidgetPredicate(
        (widget) => widget is SlimSectionHeader && widget.title == title,
      );
    }

    Future<void> tapHeader(WidgetTester tester, Finder header) async {
      await tester.tap(
        find.descendant(of: header.first, matching: find.byType(InkWell)).first,
      );
      await tester.pump();
    }

    testWidgets('renders Physical and Digital groups with their games', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed Owned Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Downloaded Owned Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      expect(headerNamed('Physical'), findsOneWidget);
      expect(headerNamed('Digital'), findsOneWidget);
      expect(find.text('Boxed Owned Game'), findsOneWidget);
      expect(find.text('Downloaded Owned Game'), findsOneWidget);
    });

    testWidgets('does not render a group that has no games', (tester) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed Owned Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
      ]);
      await tester.pump();

      expect(headerNamed('Physical'), findsOneWidget);
      expect(headerNamed('Digital'), findsNothing);
    });

    testWidgets('collapsing a platform in one group leaves the other open', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Downloaded PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      expect(headerNamed('PS5'), findsNWidgets(2));
      expect(find.text('Boxed PS5 Game'), findsOneWidget);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);

      await tapHeader(tester, headerNamed('PS5'));

      expect(find.text('Boxed PS5 Game'), findsNothing);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);

      final expansion = container.read(sectionExpansionProvider);
      expect(expansion['Physical/PS5'], false);
      expect(expansion['Digital/PS5'], isNot(false));
    });

    testWidgets('collapsing a group hides its platform sections', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Downloaded PC Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      await tapHeader(tester, headerNamed('Physical'));

      expect(find.text('Boxed PS5 Game'), findsNothing);
      expect(find.text('Downloaded PC Game'), findsOneWidget);
    });

    testWidgets('search filters games across both groups', (tester) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Halo Infinite',
          platform: 'Xbox',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Halo Wars',
          platform: 'PC',
          status: GameStatus.owned,
        ),
        GameItem.create(
          title: 'Gran Turismo',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
      ]);
      await tester.pump();

      container.read(searchQueryProvider.notifier).updateQuery('halo');
      await tester.pump();

      expect(find.text('Halo Infinite'), findsOneWidget);
      expect(find.text('Halo Wars'), findsOneWidget);
      expect(find.text('Gran Turismo'), findsNothing);
    });

    testWidgets('search still shows matches inside a collapsed group', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Halo Infinite',
          platform: 'Xbox',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Halo Wars',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      await tapHeader(tester, headerNamed('Digital'));

      expect(find.text('Halo Wars'), findsNothing);

      container.read(searchQueryProvider.notifier).updateQuery('halo');
      await tester.pump();

      expect(find.text('Halo Wars'), findsOneWidget);
      expect(find.text('Halo Infinite'), findsOneWidget);
    });

    testWidgets('platform filter still shows matches inside a collapsed group', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Downloaded PC Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      await tapHeader(tester, headerNamed('Digital'));

      expect(find.text('Downloaded PC Game'), findsNothing);

      container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
      await tester.pump();

      expect(find.text('Downloaded PC Game'), findsOneWidget);
      expect(find.text('Boxed PS5 Game'), findsNothing);
    });

    testWidgets('a single tap collapses a platform section', (tester) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
      ]);
      await tester.pump();

      expect(find.text('Boxed PS5 Game'), findsOneWidget);

      await tapHeader(tester, headerNamed('PS5'));

      expect(find.text('Boxed PS5 Game'), findsNothing);
    });

    testWidgets('platform filter applies across both groups', (tester) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Boxed PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Downloaded PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
        ),
        GameItem.create(
          title: 'Downloaded PC Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      container.read(selectedPlatformProvider.notifier).selectPlatform('PS5');
      await tester.pump();

      expect(find.text('Boxed PS5 Game'), findsOneWidget);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);
      expect(find.text('Downloaded PC Game'), findsNothing);
    });

    testWidgets('shows the empty state when nothing is in the collection', (
      tester,
    ) async {
      await pumpScreen(tester);
      await tester.pump();

      expect(find.text('No games in your collection'), findsOneWidget);
      expect(headerNamed('Physical'), findsNothing);
      expect(headerNamed('Digital'), findsNothing);
    });

    testWidgets('is reachable on the /collection route at nav index 2', (
      tester,
    ) async {
      expect(NavigationService.collectionIndex, 2);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            initialRoute: '/main',
            routes: {
              '/main':
                  (context) => Scaffold(
                    body: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed:
                              () => NavigationService.handleNavigation(
                                context,
                                NavigationService.collectionIndex,
                              ),
                          child: const Text('Go to Collection'),
                        );
                      },
                    ),
                  ),
              '/collection': (context) => const CollectionScreen(),
            },
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(CollectionScreen), findsOneWidget);
    });
  });
}
