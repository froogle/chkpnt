# CLAUDE.md

ChkPnt is a Flutter app for tracking the Games a player owns or wants and the Status of each. Its domain language is in `GLOSSARY.md`, and its recorded decisions in `docs/adr/`.

## Commands

- `tool/check.sh` runs everything CI runs: generated code up to date, formatting, `flutter analyze` and `flutter test`. Run it before every commit; it must pass.
- `dart run build_runner build --delete-conflicting-outputs` regenerates code after any change to a Riverpod, Freezed or Drift source. Commit the regenerated files with the change.
- `flutter test --reporter=failures-only <path>` runs tests and prints only failures plus a one-line summary.

## Code

Read `CODING_STANDARDS.md` before writing or reviewing Dart code. It holds the styling rules (explicit colours for Android 13), state, layout and test rules.

- State: generated Riverpod providers in `lib/providers/`.
- Data: the Drift repository in `lib/repositories/`.
- Models: Freezed classes in `lib/models/`.
- Styles: `lib/styles/`.

## Agent skills

### Issue tracker

Issues live as local markdown files under `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default triage roles (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`), recorded as a `Status:` line in each issue file. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
