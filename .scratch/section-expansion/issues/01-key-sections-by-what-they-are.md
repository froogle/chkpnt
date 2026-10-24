# Key each section by what it is

Status: resolved

Whether a section is open is stored in one `Map<String, bool>` keyed by three kinds of string: Status section titles, raw Platform names on the Backlog screen, and `'Collection/<Platform>'` on the Collection screen. A Platform named "Playing" or "Backlog" shares state with that Status section, defaults are split between the map and two different fallbacks in the section widgets, and about 17 tests cover methods the app never calls.

## Decisions

- **Scope:** Status sections on the main and Wishlist screens, and Platform sections on the Backlog and Collection screens. Each gets its own kind of key, so no two can collide.
- **Key shape:** a `Section` type with two kinds, `StatusSection(GameStatus status)` and `PlatformSection(PlatformList list, String platform)`, with `enum PlatformList { backlog, collection }`. Equality is hand-written, as `GameEditContext` does it. The types live in `ui_state_provider.dart` beside `SectionExpansion`.
- **Defaults:** one rule in the provider. Playing starts open, every other Status section starts closed, every Platform section starts open. The unread Ordered default goes.
- **Interface:** `SectionExpansion` holds only the sections the player has opened or closed, as `Map<Section, bool>`. `toggleSection` and `expandSection` keep their names and take a `Section`. A family provider, `sectionExpandedProvider(section)`, answers whether a section is open, default applied. Widgets watch it; the service calls `expandSection(StatusSection(status))`.
- **Platform section widget:** `BacklogPlatformSection` takes a required `PlatformList list` instead of the optional `expansionKey` string. The Collection screen's `'Collection'` prefix constant goes.
- **Deleted:** `updateSectionExpansionForFilters`, `updateExpansionBasedOnResults`, the manually controlled sections tracking, `expandAll`, `collapseAll`, `collapseSection` and `resetToDefaults`, with their tests. Nothing in the app calls them.
- **Unchanged:** while a filter is on, a section is open exactly when it has matching Games. That rule stays in the two section widgets. The Wishlist screen keeps its sections always open.
- **Tests:** the provider is tested for defaults, toggle, expand, a Platform named "Playing" on the Backlog screen not affecting the Playing Status section, and one Platform's Backlog and Collection sections opening independently. The main screen, Collection screen and service tests switch to `Section` keys. String-key tests are removed, not kept alongside.
- **Delivery:** branch `refactor/section-expansion` from main after PR #17 merges, one PR.

## Acceptance

- No section's open state is keyed by a display title or a prefixed string.
- No `?? true` or `?? false` expansion fallback remains in a section widget.
- None of the deleted methods remain in lib or test.
- `flutter analyze` and `flutter test` pass.

## Comments

Implemented in PR #18 (`refactor/section-expansion`).
