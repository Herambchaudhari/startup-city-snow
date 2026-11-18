#!/bin/bash
# Startup City Snow: the one-line install (no App Store, no security warning):
#   curl -fsSL https://raw.githubusercontent.com/Herambchaudhari/startup-city-snow/main/install.sh | bash
# Downloads the app (three pieces in this repo, joined and checked against its fingerprint), puts the app in Applications and opens it. Files fetched by curl aren't quarantined,
# so macOS opens the app without the "can't be opened" warning a browser download gets (the app isn't notarized yet).
# Uninstall: pkill -x StartupCitySnow; rm -rf "/Applications/Startup City Snow.app" ~/Applications/"Startup City Snow.app" ~/Library/LaunchAgents/com.startupcity.snow.plist
set -euo pipefail
REPO="${SNOW_REPO:-Herambchaudhari/startup-city-snow}"
BASE="${SNOW_BASE:-https://raw.githubusercontent.com/$REPO/main/app}/StartupCitySnow.zip.part-"   # SNOW_BASE: tools/ci tests
PARTS="aa ab ac"
# the download's fingerprint: if the file was damaged or swapped, nothing is installed (update it with each release)
SHA256="c5c77e4795977538ced591c96c448b952113b2f95f8a5ed120abe5e9f9aa7bf1"
NAME="Startup City Snow"

[ "$(uname)" = "Darwin" ] || { echo "Startup City Snow is a Mac app."; exit 1; }
[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 13 ] || { echo "Startup City Snow needs macOS 13 (Ventura) or newer."; exit 1; }

echo "❄  Downloading Startup City Snow (about 180 MB)…"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
offline() { echo "Couldn't download Startup City Snow. Check your internet connection and run the line again."; exit 1; }
if [ -n "${SNOW_URL:-}" ]; then curl -fL --retry 3 --progress-bar "$SNOW_URL" -o "$TMP/snow.zip" || offline   # testing: one local zip
else for p in $PARTS; do curl -fL --retry 3 --progress-bar "$BASE$p" >> "$TMP/snow.zip" || offline; done; fi
[ "$(shasum -a 256 "$TMP/snow.zip" | cut -d' ' -f1)" = "$SHA256" ] || { echo "The download doesn't match the published app, so nothing was installed."; exit 1; }
ditto -x -k "$TMP/snow.zip" "$TMP"
[ -d "$TMP/$NAME.app" ] || { echo "The download didn't contain the app. Try again in a minute."; exit 1; }

DEST="${SNOW_DEST:-/Applications}"; mkdir -p "$DEST" 2>/dev/null; [ -w "$DEST" ] || DEST="$HOME/Applications"; mkdir -p "$DEST"   # SNOW_DEST: tools/ci tests
pkill -x StartupCitySnow 2>/dev/null || true
rm -rf "$DEST/$NAME.app"
ditto "$TMP/$NAME.app" "$DEST/$NAME.app"
xattr -dr com.apple.quarantine "$DEST/$NAME.app" 2>/dev/null || true
open "$DEST/$NAME.app"

echo "❄  Done. The snowy town is now your wallpaper."
echo "   Click ❄ in the menu bar for the time of day, pause, and Start at login."
