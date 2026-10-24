# Rename the "Date Added" Backlog sort to match what it sorts by

Status: resolved

The Backlog screen's "Date Added" sort (`lib/screens/backlog/widgets/backlog_sorting_controls.dart:28`) actually orders by `lastStatusChange` (`lib/providers/game_provider.dart:250`), which is the **Status Change**: when the Game took its current Status, not when it was added to ChkPnt. The behaviour is the one we want, since on the Backlog it shows how long a Game has been waiting. The label is wrong, and `GLOSSARY.md` lists "date added" under _Avoid_.

Example: a Game added a year ago as Playing and moved to Backlog yesterday currently sorts as if it were added yesterday.

## Scope

- Relabel the chip "Status Changed". "Time in Backlog" was rejected because the Backlog screen also lists Ongoing Games.
- Rename `BacklogSortType.dateAdded` to `BacklogSortType.statusChange`, and update `test/providers/backlog_sorting_provider_test.dart` and `test/screens/backlog/backlog_sorting_controls_test.dart`.
- Sorting behaviour stays the same.

## Acceptance

- No "Date Added" text or `dateAdded` identifier remains.
- `flutter analyze` and `flutter test` pass.

## Comments

Implemented in PR #16 (`fix/domain-language`).
