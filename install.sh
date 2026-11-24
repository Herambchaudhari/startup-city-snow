#!/bin/bash
# Startup City Snow: the one-line install (no App Store, no security warning):
#   curl -fsSL https://raw.githubusercontent.com/Herambchaudhari/startup-city-snow/main/install.sh | bash
# Downloads the app (three pieces in this repo, joined and checked against its fingerprint), puts the app in Applications and opens it. Files fetched by curl aren't quarantined,
# so macOS opens the app without the "can't be opened" warning a browser download gets (the app isn't notarized yet).
# Uninstall: pkill -x StartupCitySnow; rm -rf "/Applications/Startup City Snow.app" ~/Applications/"Startup City Snow.app" ~/Library/LaunchAgents/com.startupcity.snow.plist ~/Library/Caches/com.startupcity.snow
set -euo pipefail
REPO="${SNOW_REPO:-Herambchaudhari/startup-city-snow}"
BASE="${SNOW_BASE:-https://raw.githubusercontent.com/$REPO/main/app}/StartupCitySnow.zip.part-"   # SNOW_BASE: tools/ci tests
PARTS="aa"
# the download's fingerprint: if the file was damaged or swapped, nothing is installed (update it with each release)
SHA256="5d34732280498b7364b4acc2a67058732c4df9034fd31d6989a2d394d3ed4363"
NAME="Startup City Snow"

[ "$(uname)" = "Darwin" ] || { echo "Startup City Snow is a Mac app."; exit 1; }
[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 13 ] || { echo "Startup City Snow needs macOS 13 (Ventura) or newer."; exit 1; }

echo "❄  Downloading Startup City Snow (about 30 MB)…"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
offline() { echo "Couldn't download Startup City Snow. Check your internet connection and run the line again."; exit 1; }
if [ -n "${SNOW_URL:-}" ]; then curl -fL --retry 3 --progress-bar "$SNOW_URL" -o "$TMP/snow.zip" || offline   # testing: one local zip
else for p in $PARTS; do curl -fL --retry 3 --progress-bar "$BASE$p" >> "$TMP/snow.zip" || offline; done; fi
[ "$(shasum -a 256 "$TMP/snow.zip" | cut -d' ' -f1)" = "$SHA256" ] || { echo "The download doesn't match the published app, so nothing was installed."; exit 1; }
ditto -x -k "$TMP/snow.zip" "$TMP"
[ -d "$TMP/$NAME.app" ] || { echo "The download didn't contain the app. Try again in a minute."; exit 1; }

DEST="${SNOW_DEST:-/Applications}"; mkdir -p "$DEST" 2>/dev/null; [ -w "$DEST" ] || DEST="$HOME/Applications"; mkdir -p "$DEST"   # SNOW_DEST: tools/ci tests
# an older copy that's running quits first (and is really gone before its files are replaced)
pkill -x StartupCitySnow 2>/dev/null || true
for i in $(seq 1 50); do pgrep -x StartupCitySnow >/dev/null || break; sleep 0.1; done
rm -rf "$DEST/$NAME.app"
ditto "$TMP/$NAME.app" "$DEST/$NAME.app"
xattr -dr com.apple.quarantine "$DEST/$NAME.app" 2>/dev/null || true
# tell Launch Services about the new copy, then open it; a Mac that's still settling gets two more tries
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$DEST/$NAME.app" 2>/dev/null || true
started=0
for i in 1 2 3; do
  open "$DEST/$NAME.app" 2>/dev/null || true
  for j in $(seq 1 30); do pgrep -x StartupCitySnow >/dev/null && { started=1; break; }; sleep 0.2; done
  [ "$started" = 1 ] && break
done
[ "$started" = 1 ] || { echo "❄  Installed in $DEST, but it didn't start by itself: open \"$NAME\" from there."; exit 1; }

echo "❄  Done. Columbia is now your wallpaper (the Snow town is in ❄ → Place)."
echo "   Click ❄ in the menu bar for the season, weather, time of day and Settings."
