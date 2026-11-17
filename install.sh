#!/bin/bash
# Startup City Snow: the one-line install (no App Store, no security warning):
#   curl -fsSL https://raw.githubusercontent.com/OWNER/startup-city-snow/main/install.sh | bash
# Downloads the latest release, puts the app in Applications and opens it. Files fetched by curl aren't quarantined,
# so macOS opens the app without the "can't be opened" warning a browser download gets (the app isn't notarized yet).
# Uninstall: pkill -x StartupCitySnow; rm -rf "/Applications/Startup City Snow.app"
set -euo pipefail
REPO="${SNOW_REPO:-OWNER/startup-city-snow}"
URL="${SNOW_URL:-https://github.com/$REPO/releases/latest/download/StartupCitySnow.zip}"
NAME="Startup City Snow"

[ "$(uname)" = "Darwin" ] || { echo "Startup City Snow is a Mac app."; exit 1; }
[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 13 ] || { echo "Startup City Snow needs macOS 13 (Ventura) or newer."; exit 1; }

echo "❄  Downloading Startup City Snow (about 180 MB)…"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
curl -fL --progress-bar "$URL" -o "$TMP/snow.zip"
ditto -x -k "$TMP/snow.zip" "$TMP"
[ -d "$TMP/$NAME.app" ] || { echo "The download didn't contain the app. Try again in a minute."; exit 1; }

DEST="/Applications"; [ -w "$DEST" ] || DEST="$HOME/Applications"; mkdir -p "$DEST"
pkill -x StartupCitySnow 2>/dev/null || true
rm -rf "$DEST/$NAME.app"
ditto "$TMP/$NAME.app" "$DEST/$NAME.app"
xattr -dr com.apple.quarantine "$DEST/$NAME.app" 2>/dev/null || true
open "$DEST/$NAME.app"

echo "❄  Done. The snowy town is now your wallpaper."
echo "   Click ❄ in the menu bar for the time of day, pause, and Start at login."
