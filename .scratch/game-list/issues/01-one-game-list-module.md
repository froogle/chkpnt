# Run every screen's Game list through one module

Status: ready-for-agent

Four screen pipelines (`fullyFilteredGames`, `sortedBacklogGamesByPlatform`, `collectionGamesByPlatform`, plus the Wishlist's use of the first) each repeat the same filter, search, group and sort steps, and four Platform lists (`availablePlatforms`, `wishlistPlatforms`, `backlogPlatforms`, `collectionPlatforms`) are built by four different rules. "No Platform chosen" is the string `'All'` in 13 places, which a player-named Platform called "All" would collide with.

## Decisions

- **Scope:** the four screen pipelines and the four Platform lists. The Profile screen's `gamesByStatus` stays as it is. `gamesByPlatform` and its tests are deleted, because nothing in the app calls it.
- **Screens:** `PlatformList { backlog, collection }` becomes `GameScreen { main, wishlist, backlog, collection }`. The Game list module takes it, and `PlatformSection` keys keep using it.
- **Which Games each screen shows**, in one `switch` on `GameScreen` in `game_provider.dart`:
  - Main: Playing, Ongoing, Backlog, Completed and Abandoned.
  - Wishlist: Wishlist and Ordered.
  - Backlog: Backlog and/or Ongoing, per its toggles.
  - Collection: every Game except Wishlist and Ordered, Physical and/or Digital per its toggles.
- **Sorting:** Backlog follows its sort controls; everything else is by title A–Z, ignoring case. Platform groups run A–Z.
- **Platform lists:** a screen's Platforms are the Platforms of the Games it shows, after its toggles and before the Platform choice and search. The main screen stops offering Platforms that only have Wishlist, Ordered or no-Status Games, and the Collection list starts following Physical/Digital.
- **Interface:** four providers replace the eight.
  - `screenPlatformsProvider(screen)`: that screen's Platforms, real ones only, sorted.
  - `statusSectionGamesProvider(status)`: one Status section's Games after the Platform choice and search, sorted by title.
  - `platformSectionsProvider(screen)`: Backlog or Collection Games after the Platform choice and search, grouped by Platform and sorted.
  - `everyPlatformProvider`: every Platform any Game has, for the edit screen's picker and scanned-Platform matching.
  - `mainScreenStatuses` and `wishlistScreenStatuses`: each screen's Statuses in section order, used by both the module and the screens' section lists so the two can't drift.
- **No Platform chosen:** the chosen Platform is `String?`, with `null` meaning none. `selectPlatform` takes `String?`, and `resetToAll` goes. `PlatformFilterDropdown` shows the "All" option itself and reports `null` for it. "All" is never stored as a string.
- **Headers:** `MainScreenHeader` takes a required `GameScreen screen` instead of the optional `customPlatforms`, and watches that screen's Platforms. The Collection header asks for `GameScreen.collection`.
- **Unchanged:** the chosen Platform stays shared across screens.
- **Tests:**
  - The module: which Games each screen shows, including the toggles; the Platform list rule; the Platform and search filter; all four Backlog sort combinations; group order; a Platform named "All" filtering like any other.
  - The dropdown: "All" is offered, and picking it reports `null`.
  - Tests of the replaced providers are replaced, not kept alongside.
- **Delivery:** branch `refactor/game-list` from main after PR #18 merges, one PR.

## Acceptance

- No `'All'` string literal for the Platform choice remains in lib.
- The eight old providers and `gamesByPlatform` are gone.
- No screen builds its own filter, search, group or sort chain.
- `flutter analyze` and `flutter test` pass.
