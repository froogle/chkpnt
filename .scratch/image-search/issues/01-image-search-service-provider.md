# Provide the image search service through Riverpod

Status: resolved

`ImageSearchScreen` takes an optional `searchService` and falls back to creating a real `WebImageSearchService` (`lib/screens/image_search/image_search_screen.dart:41`). `GameEditScreen` pushes the screen without one (`lib/screens/edit/game_edit_screen.dart:382, 484`), so any test that reaches the image search from the edit screen runs the real service and attempts real HTTP calls. "cover art offer answering yes opens the image search" in `test/screens/edit/game_edit_scan_flow_test.dart` does, and its `[ImageSearch]` log lines are the only output left in `tool/check.sh` runs.

## Decisions

- **Seam:** a `webImageSearchServiceProvider` beside the service in `lib/services/web_image_search_service.dart`, in the same style as `guideStorageServiceProvider`.
- **Screen:** `ImageSearchScreen` becomes a `ConsumerStatefulWidget` that reads the provider. Its `searchService` parameter is deleted.
- **Tests:**
  - `test/screens/image_search/image_search_screen_test.dart` overrides the provider with its existing `StubImageSearchService` and `FailingImageSearchService` instead of passing them in.
  - `game_edit_scan_flow_test.dart` overrides the provider with a stub, so it makes no HTTP calls.
- **Delivery:** branch `refactor/image-search-provider` from main, one PR.

## Acceptance

- No test runs the real `WebImageSearchService`.
- `tool/check.sh` prints no `[ImageSearch]` lines.
- `tool/check.sh` passes.

## Comments

Implemented in PR #26 (`refactor/image-search-provider`).
