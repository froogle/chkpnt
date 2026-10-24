# Coding standards

The rules every change to ChkPnt follows, and the rules `/code-review` checks a diff against. Anything a tool can enforce lives in `tool/check.sh` instead.

## Styling

ChkPnt gives every widget an explicit colour, because Material defaults render invisible text on Android 13.

- Set the colour of every text style and background explicitly, from the classes in `lib/styles/`. A `Card` gets an explicit `color`.
- Read colours and text styles from `lib/styles/` (`AppColors`, the screen's style class), never from `Theme.of(context)`.
- Put styling in the centralised style classes rather than inline, and name every number as a constant there.
- Check a new or changed screen by eye on Android 13.

The explicit-colour rule is a deliberate exception to "Avoiding over-engineering" below: it addresses a real Android 13 rendering issue.

## Code

- **Self-explanatory code, no comments.** When code seems to need a comment, simplify the code instead.
- **British English** in identifiers, strings and docs (colour, centre, organisation).
- **Domain language** from `GLOSSARY.md` in identifiers, user-facing text and test names (Game, Platform, Status, Collection).
- **`_buildXXX()` extraction:** split any build method that nests deeply into named `_buildXXX()` methods.
- **Error handling** ends in a user-friendly message.

## Layout

- Feature screens live in `lib/screens/<feature>/`, their own widgets in `lib/screens/<feature>/widgets/`, and their animations in `lib/screens/<feature>/widgets/animations/`.
- A widget moves to `lib/shared/widgets/` once two or more screens use it.

## State

- **Streaming providers** for all data access, through the repository in `lib/repositories/`.
- **Family providers** for context-dependent state: pass the context as the family argument rather than initialising the provider from a widget's lifecycle. A family argument class implements `==` and `hashCode` over every field.
- **Async work in an auto-disposed provider ends with its listeners.** After an `await`, check whether the provider was disposed and drop the result if so. Keeping the provider alive instead hands a stale result to the next screen that builds the same family key.

## Avoiding over-engineering

This codebase has a history of custom machinery that fights normal Android and Flutter behaviour instead of using it. Before adding any workaround, confirm the framework does not already solve the problem.

- **Prefer stock Flutter behaviour.** Reach for a platform channel, native code or manual state tracking only after the built-in approach has been shown to fail. `keyboardDismissBehavior` replacing a hand-rolled keyboard hack is the reference example.
- **One mechanism per job.** Layering several fallbacks for the same effect hides which one actually works and lets them fight each other.
- **Work through framework state.** Driving the platform directly (for example hiding the keyboard through `InputMethodManager`) leaves Flutter's own focus state untouched, so the framework can simply undo the change. This class of workaround tends to cause the bug it was meant to fix.
- **Treat existing workarounds as suspects.** When fixing a bug near one, first check whether the workaround is the cause, and remove it if the framework now handles the case.
- **When a fix grows, stop and reconsider.** A bug fix that needs new abstractions is usually solving the wrong problem.

## Tests

- Every new widget and every new behaviour gets a test.
- Provider tests use `TestHelpers.createTestContainer()`, unless the test needs an exact Game list; then it overrides `gameListProvider` with a fixed list.
- Test through the public interface: what a provider returns, or what a screen shows and does. A decision that lives in a provider is tested there, not again through widgets.
- A test of a fix fails when the fix is undone.
