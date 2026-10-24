#!/usr/bin/env bash
set -euo pipefail

sdk="${ANDROID_HOME:-$HOME/Android/Sdk}"
export ANDROID_AVD_HOME="${ANDROID_AVD_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/.android/avd}"
avd=chkpnt_android_13
image='system-images;android-33;google_apis;x86_64'
port=5584
serial="emulator-$port"

if ! "$sdk/emulator/emulator" -list-avds | grep -qx "$avd"; then
  echo "No $avd emulator. Create it with:" >&2
  echo "  $sdk/cmdline-tools/latest/bin/sdkmanager --install '$image'" >&2
  echo "  echo no | $sdk/cmdline-tools/latest/bin/avdmanager create avd -n $avd -k '$image' -d pixel_6" >&2
  exit 1
fi

if ! adb devices | grep -q "^$serial[[:space:]]*device"; then
  nohup "$sdk/emulator/emulator" -avd "$avd" -port "$port" -no-window -no-audio -no-boot-anim >/dev/null 2>&1 &
fi

adb -s "$serial" wait-for-device
until [ "$(adb -s "$serial" shell getprop sys.boot_completed | tr -d '\r')" = 1 ]; do
  sleep 2
done
echo "$serial"
