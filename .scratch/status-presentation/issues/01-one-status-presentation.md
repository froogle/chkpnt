# Present every Status from one place

Status: ready-for-agent

Each Status's label, icon and colour are defined separately in four label maps, four icon maps and three colour maps across eight files, and the copies disagree in at least seven places. One module, `lib/styles/status_styles.dart`, becomes the only place that says how a Status is presented.

## Decisions

- **Scope:** label, icon and colour for every Status, and how a Game with no Status is presented. Section titles use the label. The detail sheet's status-row icon tint stays in the detail sheet. Which Statuses can be picked is out of scope.
- **Colours:** Playing orange, Completed green, Backlog blue, Abandoned grey, Wishlist pink, Ordered purple, Ongoing `0xFF06B6D4`, no Status `AppColors.emptyStateIcon`. These apply everywhere, including the Profile chart. The "start playing" and "completed!" confirmations use their Status's colour.
- **Icons:** one per Status. Backlog is `Icons.schedule` and Playing is `Icons.play_circle_fill`. No Status has no icon.
- **Labels:** Ongoing is "Ongoing" everywhere, including its section title and expansion key. No Status reads "In Collection".
- **Shape:** callers ask once per Status and get its label, icon and colour together. No Status is the answer for `GameStatus.owned`, which stays the stored form per ADR-0001.
- **Chart:** it asks by Status, not by label. `ProfileStyles.statusColors` is deleted, and `chartColors` stays because the platform chart uses it.
- **Tests:** `test/styles/status_styles_test.dart` pins every Status's presentation once. Caller tests check that callers show what Status presentation returns, and keep only the checks for decisions the caller makes itself.
- **Section expansion:** only the "Ongoing" key rename happens here. Re-keying sections is a separate candidate.

## Acceptance

- No `switch` over `GameStatus` that returns a label, icon or colour remains outside `status_styles.dart`.
- `ProfileStyles.statusColors` is gone.
- "Ongoing/Frequently Played" no longer appears anywhere.
- `flutter analyze` and `flutter test` pass.
