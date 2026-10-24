#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

apk=build/app/outputs/flutter-apk/app-release.apk
serial="${1:-}"

if [ -z "$serial" ]; then
  mapfile -t serials < <(adb devices | awk 'NR > 1 && $2 == "device" { print $1 }')
  if [ "${#serials[@]}" -ne 1 ]; then
    echo "Found ${#serials[@]} attached devices; pass one serial: $0 <serial>" >&2
    adb devices -l >&2
    exit 1
  fi
  serial="${serials[0]}"
fi

flutter build apk --release

if ! adb -s "$serial" install -r "$apk"; then
  echo "Install on $serial failed. The installed app and its data were left in place." >&2
  exit 1
fi

adb -s "$serial" shell monkey -p com.frooglesim.chkpnt -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
echo "Installed and opened ChkPnt on $serial."
