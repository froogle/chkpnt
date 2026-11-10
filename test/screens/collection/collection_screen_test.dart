import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/screens/backlog/backlog_screen.dart';
import 'package:chkpnt/screens/collection/collection_screen.dart';
import 'package:chkpnt/screens/collection/widgets/collection_format_controls.dart';
import 'package:chkpnt/screens/collection/widgets/collection_screen_header.dart';
import 'package:chkpnt/shared/widgets/layout/slim_section_header.dart';
import 'package:chkpnt/shared/widgets/status_filter_chip.dart';
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

    Finder chipNamed(String label) {
      return find.byWidgetPredicate(
        (widget) => widget is StatusFilterChip && widget.label == label,
      );
    }

    Future<void> tapHeader(WidgetTester tester, Finder header) async {
      await tester.tap(
        find.descendant(of: header.first, matching: find.byType(InkWell)).first,
      );
      await tester.pump();
    }

    Future<void> tapChip(WidgetTester tester, String label) async {
      await tester.tap(chipNamed(label));
      await tester.pump();
    }

    Future<void> addMixedFormatGames() async {
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
    }

    testWidgets('renders one merged section per platform for both formats', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      expect(headerNamed('PS5'), findsOneWidget);
      expect(find.text('Boxed PS5 Game'), findsOneWidget);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);
    });

    testWidgets('keeps the header auto-hiding its title after the timer', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      expect(find.text('Collection'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Collection'), findsNothing);
    });

    testWidgets('keeps the chips visible after the header hides its title', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Collection'), findsNothing);
      expect(chipNamed('Physical'), findsOneWidget);
      expect(chipNamed('Digital'), findsOneWidget);

      await tapChip(tester, 'Digital');

      expect(container.read(collectionShowDigitalFilterProvider), isFalse);
      expect(find.text('Downloaded PS5 Game'), findsNothing);
      expect(find.text('Boxed PS5 Game'), findsOneWidget);
    });

    testWidgets('keeps the chips out of the header', (tester) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(CollectionScreenHeader),
          matching: find.byType(StatusFilterChip),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(CollectionFormatControls),
          matching: find.byType(StatusFilterChip),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('right-aligns the chips in their own row beneath the header', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      final headerRect = tester.getRect(find.byType(CollectionScreenHeader));
      final rowRect = tester.getRect(find.byType(CollectionFormatControls));
      final physicalRect = tester.getRect(chipNamed('Physical'));
      final digitalRect = tester.getRect(chipNamed('Digital'));

      expect(rowRect.top, greaterThanOrEqualTo(headerRect.bottom));
      expect(physicalRect.left, greaterThan(rowRect.center.dx));
      expect(digitalRect.left, greaterThanOrEqualTo(physicalRect.right));
      expect(digitalRect.right, rowRect.right - 16);
      expect(digitalRect.left - physicalRect.right, 8);
    });

    testWidgets('renders no Physical or Digital section headers', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      expect(headerNamed('Physical'), findsNothing);
      expect(headerNamed('Digital'), findsNothing);
      expect(chipNamed('Physical'), findsOneWidget);
      expect(chipNamed('Digital'), findsOneWidget);
    });

    testWidgets('turning off Digital hides digital games only', (tester) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      await tapChip(tester, 'Digital');

      expect(container.read(collectionShowDigitalFilterProvider), isFalse);
      expect(container.read(collectionShowPhysicalFilterProvider), isTrue);
      expect(find.text('Downloaded PS5 Game'), findsNothing);
      expect(find.text('Boxed PS5 Game'), findsOneWidget);
    });

    testWidgets('turning off Physical hides physical games only', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      await tapChip(tester, 'Physical');

      expect(container.read(collectionShowPhysicalFilterProvider), isFalse);
      expect(container.read(collectionShowDigitalFilterProvider), isTrue);
      expect(find.text('Boxed PS5 Game'), findsNothing);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);
    });

    testWidgets('turning off the only active filter re-enables the other', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addMixedFormatGames();
      await tester.pump();

      await tapChip(tester, 'Digital');
      await tapChip(tester, 'Physical');

      expect(container.read(collectionShowPhysicalFilterProvider), isFalse);
      expect(container.read(collectionShowDigitalFilterProvider), isTrue);
      expect(find.text('Downloaded PS5 Game'), findsOneWidget);
      expect(find.text('Boxed PS5 Game'), findsNothing);
    });

    testWidgets('the format filters compose with the search box', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Halo Infinite',
          platform: 'Xbox',
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

      await tapChip(tester, 'Digital');

      expect(find.text('Halo Infinite'), findsNothing);
      expect(find.text('Gran Turismo'), findsNothing);
      expect(find.text('No games in your collection'), findsOneWidget);
    });

    testWidgets('the format filters compose with the platform dropdown', (
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
        GameItem.create(
          title: 'Downloaded PC Game',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      container.read(selectedPlatformProvider.notifier).selectPlatform('PS5');
      await tester.pump();

      await tapChip(tester, 'Physical');

      expect(find.text('Downloaded PS5 Game'), findsOneWidget);
      expect(find.text('Boxed PS5 Game'), findsNothing);
      expect(find.text('Downloaded PC Game'), findsNothing);
    });

    testWidgets('collapsing a platform here does not collapse it on Backlog', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Collected PS5 Game',
          platform: 'PS5',
          status: GameStatus.owned,
          isPhysical: true,
        ),
        GameItem.create(
          title: 'Backlogged PS5 Game',
          platform: 'PS5',
          status: GameStatus.backlog,
        ),
      ]);
      await tester.pump();

      await tapHeader(tester, headerNamed('PS5'));

      expect(find.text('Collected PS5 Game'), findsNothing);

      bool isExpanded(GameScreen screen) => container.read(
        sectionExpandedProvider(PlatformSection(screen, 'PS5')),
      );
      expect(isExpanded(GameScreen.collection), isFalse);
      expect(isExpanded(GameScreen.backlog), isTrue);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: BacklogScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('Backlogged PS5 Game'), findsOneWidget);
    });

    testWidgets('search filters games across both formats', (tester) async {
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

    testWidgets('search still shows matches inside a collapsed section', (
      tester,
    ) async {
      await pumpScreen(tester);
      await addGames([
        GameItem.create(
          title: 'Halo Wars',
          platform: 'PC',
          status: GameStatus.owned,
        ),
      ]);
      await tester.pump();

      await tapHeader(tester, headerNamed('PC'));

      expect(find.text('Halo Wars'), findsNothing);

      container.read(searchQueryProvider.notifier).updateQuery('halo');
      await tester.pump();

      expect(find.text('Halo Wars'), findsOneWidget);
    });

    testWidgets(
      'platform filter still shows matches inside a collapsed section',
      (tester) async {
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

        await tapHeader(tester, headerNamed('PC'));

        expect(find.text('Downloaded PC Game'), findsNothing);

        container.read(selectedPlatformProvider.notifier).selectPlatform('PC');
        await tester.pump();

        expect(find.text('Downloaded PC Game'), findsOneWidget);
        expect(find.text('Boxed PS5 Game'), findsNothing);
      },
    );

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

    testWidgets('platform filter applies across both formats', (tester) async {
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
              '/main': (context) => Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () => NavigationService.handleNavigation(
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
