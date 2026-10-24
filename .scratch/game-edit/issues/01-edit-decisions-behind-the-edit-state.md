# Move the Game edit decisions behind the edit state

Status: resolved

The edit screen widget makes the edit flow's decisions itself: it checks for a duplicate barcode, runs the lookup, matches the scanned Platform, decides whether the button offers a scan or a save, and builds the Game to save. The title is held twice, in the text field and in the edit state. `GameStatusSelector` sets the default Status a second time after the first frame. Adding a Game from the Backlog screen shows two confirmations. A scan always clears the Status, so a Game scanned from the Backlog or Wishlist screen lands only in the Collection.

## Decisions

- **Location:** `GameEditContext`, `GameEditFormState` and `GameEditState` move from `ui_state_provider.dart` to `lib/providers/game_edit_provider.dart`, so the edit state can read the Game list without the two files importing each other. Their tests move to `test/providers/game_edit_provider_test.dart`.
- **Scan:** `Future<BarcodeScan> scanBarcode(String barcode)` on the edit state returns one of two results.
  - `DuplicateBarcode(game)`: a saved Game already has the barcode; no lookup runs.
  - `BarcodeLookedUp(result)`: the lookup has run and its result is applied to the form, including Platform matching and the Status rule.
  - The form state gains `isLookingUpBarcode`, which drives the overlay.
- **Status after a scan:** when the screen limits the Statuses on offer, the scan keeps the Status currently selected. Otherwise the Game has no Status. Either way it becomes Physical.
- **Form rules:** the form state gains `isAddMode` and the getters `offersScan` and `canSave`. The notifier gains `gameToSave()`, which builds the new Game or the updated copy. The screen still chooses the add or update service call.
- **Title:** the edit state owns it. The text field mirrors it, and the screen copies a scanned title into the field.
- **Stays in the screen:** navigation, dialogs, confirmations, camera permission, the scanner screen, image picking, the lookup failure messages and the cover-art offer. Which Statuses the selector offers is out of scope.
- **Deleted:** `GameStatusSelector`'s post-frame default and its tracking fields; the Backlog screen's own "added to backlog!" confirmation and the save's return of the new Game only for Backlog Games.
- **Tests:**
  - The edit state, with the lookup fake: a duplicate skips the lookup; Platform matching; the Status rule from the Backlog and main screens; the one title; `canSave` and `offersScan`; `gameToSave` for add and update.
  - The edit screen: scan-flow widget tests that only re-check decisions are trimmed to one per screen reaction (duplicate dialog, a failure message, the cover-art offer, the button switching modes, the permission dialog).
  - The Backlog screen: adding a Game shows one confirmation.
  - Tests of the selector's second default go.
- **Delivery:** branch `refactor/game-edit` from main, one PR.

## Acceptance

- The edit screen widget has no barcode, Platform-matching or save-building logic of its own.
- The title has one source.
- `GameStatusSelector` never changes the Status by itself.
- Adding a Game from the Backlog screen shows one confirmation.
- `flutter analyze` and `flutter test` pass.

## Comments

Implemented in PR #20 (`refactor/game-edit`).
