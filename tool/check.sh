#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

generated_code_fingerprint() {
  find lib test -name '*.g.dart' -o -name '*.freezed.dart' \
    | sort | xargs sha256sum | sha256sum
}

before=$(generated_code_fingerprint)
dart run build_runner build --delete-conflicting-outputs
if [ "$(generated_code_fingerprint)" != "$before" ]; then
  echo "Generated code was out of date. build_runner has regenerated it; review and commit the changes." >&2
  exit 1
fi

dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test --reporter=failures-only
