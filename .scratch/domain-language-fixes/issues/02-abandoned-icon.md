# Give Abandoned an icon that doesn't mean "on hold"

Status: needs-triage

`GLOSSARY.md` defines **Abandoned** as a Game the player stopped with no intention of returning; one they mean to come back to belongs in the Backlog. Abandoned currently uses `Icons.pause_circle_filled`, which reads as "paused" or "on hold", the very meanings the glossary rules out.

It appears in four places:

- `lib/screens/main/widgets/game_detail_sheet_info.dart:207`
- `lib/screens/main/widgets/game_detail_sheet_info.dart:235`
- `lib/services/game_actions_service.dart:226`
- `lib/shared/widgets/buttons/status_button.dart:74`

Picking the replacement icon is a design choice that needs a human (for example `Icons.cancel` or `Icons.do_not_disturb_on`).

## Acceptance

- All four sites use the same new icon, and none of them is a pause glyph.
- `flutter analyze` and `flutter test` pass.
