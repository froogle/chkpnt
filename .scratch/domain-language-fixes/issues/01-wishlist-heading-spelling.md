# Spell the Wishlist section heading as one word

Status: needs-triage

The Wishlist screen's section heading reads "Wish List" (`lib/screens/wishlist/wishlist_screen.dart:80`), while every Status label says "Wishlist". `GLOSSARY.md` settles on **Wishlist** and lists "Wish List" under _Avoid_.

The heading string is also the section expansion key in `lib/providers/ui_state_provider.dart` (lines 138, 209, 210, 228) and in `test/providers/ui_state_provider_test.dart`, so all of them change together. The key is held in memory only, so nothing persisted is affected.

## Acceptance

- The heading reads "Wishlist".
- The section key matches everywhere, and the section still expands and collapses.
- `flutter analyze` and `flutter test` pass.
