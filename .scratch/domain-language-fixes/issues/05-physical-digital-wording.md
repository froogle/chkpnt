# Say Physical and Digital in the detail sheet's copy row

Status: ready-for-human

The game detail sheet describes the kind of copy twice, using different words each time:

- The badge says "Physical" / "Digital" (`lib/screens/main/widgets/game_detail_sheet_info.dart:111`).
- The info row says "Boxed Copy" / "Download" (`lib/screens/main/widgets/game_detail_sheet_info.dart:134`).

`GLOSSARY.md` settles on **Physical** and **Digital** and lists "boxed" under _Avoid_. The Collection filter (`lib/screens/collection/widgets/collection_format_controls.dart`) already uses Physical and Digital.

A human needs to decide one thing: whether to relabel the row "Physical" / "Digital", or to remove it, since the badge already says the same thing. If the row stays, its `Icons.inventory_2_outlined` / `Icons.download_outlined` icons differ from the badge's `Icons.sd_card` / `Icons.cloud_outlined`, and should probably match too.

## Decision

The badge and the copy row's icon and text sit in the same row, so relabelling the text would put the same icon and word twice side by side. The row keeps only the badge, as the Status row does for a Game with no Status.

## Acceptance

- No "Boxed Copy" or "Download" text remains in the detail sheet.
- The detail sheet names the kind of copy only as Physical or Digital.
- A test in `test/screens/main/widgets/game_detail_sheet_info_test.dart` covers both a Physical and a Digital Game.
- `flutter analyze` and `flutter test` pass.
