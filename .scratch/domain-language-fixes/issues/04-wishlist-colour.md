# Use one colour for the Wishlist Status

Status: ready-for-agent

The Wishlist Status uses different colours in different places: `Colors.red` in `lib/screens/main/widgets/game_detail_sheet_info.dart:188` and `Colors.green` in `lib/services/game_actions_service.dart:250`. Green is already Completed's colour in both files, so in the save confirmation a Wishlist Game looks Completed.

The current colours also break the project's rule against inline styling: both files hard-code a colour for every Status. Decision: fix only the Wishlist colour here. Colour, icon and label are all duplicated per Status across the same files, so centralising them is a single refactor for `/improve-codebase-architecture`, not part of this fix. That refactor should also cover the Profile chart's palette (`ProfileStyles.statusColors` in `lib/styles/profile_styles.dart`). It gives every Status a different colour from the rest of the app (for example Wishlist blue, Playing green, Abandoned red), so it is left alone here.

Use `Colors.pink`, which isn't used elsewhere. Red was rejected because the save confirmation uses the Status colour as its background, and red backgrounds already mean errors in this app.

## Acceptance

- Wishlist is `Colors.pink` in both places.
- `flutter analyze` and `flutter test` pass.
