import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chkpnt/models/game_models.dart';
import 'package:chkpnt/providers/game_provider.dart';
import 'package:chkpnt/providers/ui_state_provider.dart';

class _FixedGameList extends GameList {
  final List<GameItem> games;

  _FixedGameList(this.games);

  @override
  List<GameItem> build() => games;
}

void main() {
  late ProviderContainer container;

  void showGames(List<GameItem> games) {
    container = ProviderContainer(
      overrides: [gameListProvider.overrideWith(() => _FixedGameList(games))],
    );
    addTearDown(container.dispose);
  }

  GameItem game(
    String title, {
    String platform = 'PC',
    GameStatus status = GameStatus.backlog,
    bool isPhysical = false,
    int statusChangeDay = 1,
  }) {
    return GameItem.create(
      title: title,
      platform: platform,
      status: status,
      isPhysical: isPhysical,
    ).copyWith(lastStatusChange: DateTime(2026, 1, statusChangeDay));
  }

  List<String> titles(List<GameItem> games) =>
      games.map((game) => game.title).toList();

  Map<String, List<String>> sectionTitles(GameScreen screen) => container
      .read(platformSectionsProvider(screen))
      .map((platform, games) => MapEntry(platform, titles(games)));

  List<String> platformsOf(GameScreen screen) =>
      container.read(screenPlatformsProvider(screen));

  List<String> statusSection(GameStatus status) =>
      titles(container.read(statusSectionGamesProvider(status)));

  void choosePlatform(String? platform) => container
      .read(selectedPlatformProvider.notifier)
      .selectPlatform(platform);

  void search(String query) =>
      container.read(searchQueryProvider.notifier).updateQuery(query);

  group('screen Platforms', () {
    test('lists the Platforms of the Games each screen shows', () {
      showGames([
        game('Playing', platform: 'PS5', status: GameStatus.playing),
        game('Silksong', platform: 'Switch', status: GameStatus.wishlist),
        game('Celeste', platform: 'PC', status: GameStatus.owned),
        game('Hollow Knight', platform: 'Xbox', status: GameStatus.ordered),
        game('Waiting', platform: 'Steam Deck', status: GameStatus.backlog),
      ]);

      expect(platformsOf(GameScreen.main), ['PS5', 'Steam Deck']);
      expect(platformsOf(GameScreen.wishlist), ['Switch', 'Xbox']);
      expect(platformsOf(GameScreen.backlog), ['Steam Deck']);
      expect(platformsOf(GameScreen.collection), ['PC', 'PS5', 'Steam Deck']);
    });

    test('follows the Backlog toggles', () {
      showGames([
        game('Waiting', platform: 'PS5', status: GameStatus.backlog),
        game('Returning', platform: 'PC', status: GameStatus.ongoing),
      ]);

      container.read(backlogShowOngoingFilterProvider.notifier).toggle();

      expect(platformsOf(GameScreen.backlog), ['PS5']);
    });

    test('follows the Collection Physical and Digital toggles', () {
      showGames([
        game('Elden Ring', platform: 'PS5', isPhysical: true),
        game('Hades', platform: 'PC'),
      ]);

      container.read(collectionShowDigitalFilterProvider.notifier).toggle();

      expect(platformsOf(GameScreen.collection), ['PS5']);
    });

    test('ignores the Platform choice and search', () {
      showGames([
        game('One', platform: 'PS5', status: GameStatus.playing),
        game('Two', platform: 'PC', status: GameStatus.playing),
      ]);

      choosePlatform('PS5');
      search('nothing matches this');

      expect(platformsOf(GameScreen.main), ['PC', 'PS5']);
    });

    test('offers every Platform any Game has for editing', () {
      showGames([
        game('Playing', platform: 'PS5', status: GameStatus.playing),
        game('Silksong', platform: 'Switch', status: GameStatus.wishlist),
        game('Celeste', platform: 'PC', status: GameStatus.owned),
        game('Balatro', platform: 'PC', status: GameStatus.owned),
      ]);

      expect(container.read(everyPlatformProvider), ['PC', 'PS5', 'Switch']);
    });
  });

  group('Status section Games', () {
    test('lists one Status by title, ignoring case', () {
      showGames([
        game('beta', status: GameStatus.playing),
        game('Alpha', status: GameStatus.playing),
        game('Gamma', status: GameStatus.playing),
        game('Elsewhere', status: GameStatus.completed),
      ]);

      expect(statusSection(GameStatus.playing), ['Alpha', 'beta', 'Gamma']);
    });

    test('narrows to the chosen Platform and the search', () {
      showGames([
        game('Elden Ring', platform: 'PS5', status: GameStatus.playing),
        game('Hades', platform: 'PS5', status: GameStatus.playing),
        game('Halo', platform: 'Xbox', status: GameStatus.playing),
      ]);

      choosePlatform('PS5');
      expect(statusSection(GameStatus.playing), ['Elden Ring', 'Hades']);

      search('hades');
      expect(statusSection(GameStatus.playing), ['Hades']);

      choosePlatform(null);
      search('xbox');
      expect(statusSection(GameStatus.playing), ['Halo']);
    });

    test('treats a Platform named All like any other', () {
      showGames([
        game('On All', platform: 'All', status: GameStatus.playing),
        game('On PC', platform: 'PC', status: GameStatus.playing),
      ]);

      choosePlatform('All');
      expect(statusSection(GameStatus.playing), ['On All']);

      choosePlatform(null);
      expect(statusSection(GameStatus.playing), ['On All', 'On PC']);
    });
  });

  group('Platform sections', () {
    test('groups Backlog and Ongoing Games by Platform, A to Z', () {
      showGames([
        game('Another Crab', platform: 'Switch', status: GameStatus.backlog),
        game('Returning', platform: 'PC', status: GameStatus.ongoing),
        game('Playing', platform: 'PC', status: GameStatus.playing),
      ]);

      expect(sectionTitles(GameScreen.backlog), {
        'PC': ['Returning'],
        'Switch': ['Another Crab'],
      });
      expect(sectionTitles(GameScreen.backlog).keys, ['PC', 'Switch']);
    });

    test('leaves out the Games the Backlog toggles hide', () {
      showGames([
        game('Waiting', platform: 'PS5', status: GameStatus.backlog),
        game('Returning', platform: 'PS5', status: GameStatus.ongoing),
      ]);

      container.read(backlogShowBacklogFilterProvider.notifier).toggle();

      expect(sectionTitles(GameScreen.backlog), {
        'PS5': ['Returning'],
      });
    });

    test('sorts Backlog by title or Status Change, either way', () {
      showGames([
        game('Alpha', statusChangeDay: 3),
        game('beta', statusChangeDay: 1),
        game('Gamma', statusChangeDay: 2),
      ]);
      final sort = container.read(backlogSortProvider.notifier);
      final direction = container.read(
        backlogSortDirectionStateProvider.notifier,
      );

      expect(sectionTitles(GameScreen.backlog)['PC'], [
        'Alpha',
        'beta',
        'Gamma',
      ]);

      direction.setSortDirection(SortDirection.descending);
      expect(sectionTitles(GameScreen.backlog)['PC'], [
        'Gamma',
        'beta',
        'Alpha',
      ]);

      sort.setSortType(BacklogSortType.statusChange);
      expect(sectionTitles(GameScreen.backlog)['PC'], [
        'Alpha',
        'Gamma',
        'beta',
      ]);

      direction.setSortDirection(SortDirection.ascending);
      expect(sectionTitles(GameScreen.backlog)['PC'], [
        'beta',
        'Gamma',
        'Alpha',
      ]);
    });

    test('shows every Game in the Collection', () {
      showGames([
        game('celeste', platform: 'PC', status: GameStatus.owned),
        game('Doom', platform: 'PC', status: GameStatus.completed),
        game('Silksong', platform: 'PC', status: GameStatus.wishlist),
        game('Hollow Knight', platform: 'PS5', status: GameStatus.ordered),
      ]);

      expect(sectionTitles(GameScreen.collection), {
        'PC': ['celeste', 'Doom'],
      });
    });

    test('leaves out the Games the Collection toggles hide', () {
      showGames([
        game('Elden Ring', platform: 'PS5', isPhysical: true),
        game('Hades', platform: 'PS5'),
      ]);

      container.read(collectionShowPhysicalFilterProvider.notifier).toggle();

      expect(sectionTitles(GameScreen.collection), {
        'PS5': ['Hades'],
      });
    });

    test('narrows the Collection to the chosen Platform and the search', () {
      showGames([
        game('Elden Ring', platform: 'PS5', status: GameStatus.owned),
        game('Hades', platform: 'PS5', status: GameStatus.owned),
        game('Halo', platform: 'Xbox', status: GameStatus.owned),
      ]);

      choosePlatform('PS5');
      search('elden');

      expect(sectionTitles(GameScreen.collection), {
        'PS5': ['Elden Ring'],
      });
    });
  });
}
