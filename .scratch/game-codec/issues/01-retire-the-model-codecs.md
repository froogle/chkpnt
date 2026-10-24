# Retire the generated Game and Guide codecs

Status: resolved

A Game and a Guide each have two JSON encodings. The backup codec, written by hand in `DriftGameRepository.exportDatabaseToJson` and `importFromJson`, is the only one the app uses. It stores Status and the Guide format as indices, as ADR-0001 describes. The generated Freezed codecs on `GameItem`, `GameId`, `GuideItem` and `GuideId` are called only from tests, and they store Status and the Guide format by name. A future caller could pick them up and write backups ADR-0001 forbids.

Their tests also mislead. `guide_models_test.dart` checks that the format round-trips and that a missing format key defaults to a Text Guide, but only through the generated codec. The backup's own format handling has no test, and no backup test covers Guides.

## Decisions

- **Scope:** all four models (`GameItem`, `GameId`, `GuideItem`, `GuideId`).
- **Surviving codec:** the backup codec stays where it is, in the repository's export and import, unchanged.
- **Deleted:**
  - the four `fromJson` factories;
  - the `part 'game_models.g.dart'` and `part 'guide_models.g.dart'` directives and the generated files;
  - the generated-codec tests: "should convert to and from JSON correctly" and "should convert GameId to JSON correctly" in `game_models_test.dart`, and the "GuideItem JSON" group in `guide_models_test.dart`.
- **Kept:** `json_serializable`, which the backup models still use.
- **Tests:** a new `test/repositories/drift_game_repository_guide_backup_test.dart` checks two things through backup and restore, using the temp-file pattern of the other backup tests:
  - a Web Guide's format survives backup and restore;
  - a backup with no `format` key restores the Guide as a Text Guide.
- **No ADR and no guard test:** re-adding a model codec would be easy to undo.
- **Delivery:** branch `refactor/game-codec` from main, one PR.

## Acceptance

- `GameItem`, `GameId`, `GuideItem` and `GuideId` have no JSON codec.
- The backup's Guide format handling is tested through export and import.
- `tool/check.sh` passes.

## Comments

Implemented in PR #24 (`refactor/game-codec`).
