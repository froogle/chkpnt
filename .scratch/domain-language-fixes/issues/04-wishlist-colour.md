# Use one colour for the Wishlist Status

Status: needs-triage

The Wishlist Status uses different colours in different places: `Colors.red` in `lib/screens/main/widgets/game_detail_sheet_info.dart:188` and `Colors.green` in `lib/services/game_actions_service.dart:250`. Green is already Completed's colour in both files, so in the save confirmation a Wishlist Game looks Completed.

The current colours also break the project's rule against inline styling: both files hard-code a colour for every Status. Moving the per-Status colours into `lib/styles/` would fix the mismatch and the duplication at once. Whether to do that here or as a separate change needs a human.

## Acceptance

- Wishlist has one colour everywhere, and it differs from Completed's.
- `flutter analyze` and `flutter test` pass.
