# Give Abandoned an icon that doesn't mean "on hold"

Status: ready-for-agent

`GLOSSARY.md` defines **Abandoned** as a Game the player stopped with no intention of returning; one they mean to come back to belongs in the Backlog. Abandoned currently uses `Icons.pause_circle_filled`, which reads as "paused" or "on hold", the very meanings the glossary rules out.

It appears in four places:

- `lib/screens/main/widgets/game_detail_sheet_info.dart:207`
- `lib/screens/main/widgets/game_detail_sheet_info.dart:235`
- `lib/services/game_actions_service.dart:226`
- `lib/shared/widgets/buttons/status_button.dart:74`

Decision: use `Icons.do_not_disturb_on`, a filled circle like the other Status icons that reads as "stopped for good". `Icons.cancel` was rejected because it already serves as a dismiss control.

## Acceptance

- All four sites use `Icons.do_not_disturb_on`.
- `flutter analyze` and `flutter test` pass.
