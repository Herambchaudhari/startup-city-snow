# ❄ Startup City Snow

Columbia's campus as your Mac wallpaper, living through the day: the light follows your clock, the seasons follow the
date, students cross the lawns, and it rains, snows or drops its leaves. A snowy Christmas town comes with it too.

![Startup City Snow](preview.jpg)

## Install (one line)

1. Open **Terminal**: press ⌘ Space, type `Terminal`, press Return.
2. Paste this line and press Return:

```bash
curl -fsSL https://raw.githubusercontent.com/Herambchaudhari/startup-city-snow/main/install.sh | bash
```

3. That's it: a small download (about 30 MB), then Columbia appears behind your desktop and ❄ sits in the menu bar.
   It starts with your Mac from now on (turn that off in ❄ → Settings).

**Needs:** a Mac with macOS 13 (Ventura) or newer. Apple Silicon or Intel.

## The ❄ menu

- **Place:** Columbia, or the Snow town.
- **Season** and **Weather** (Columbia): it follows the date, or pick one; clear or rainy, leaves in fall, snow in winter.
- **Time of day:** follows your clock, or pick morning, afternoon, dusk or night.
- **Zoom:** closer on a spot you pick, with an optional very slow drift.
- **Pause**, and **Settings**: frame around my desktop, snow on windows, start at login, share anonymous usage, the
  films on your Mac, the version, updates and uninstall.

**Privacy:** so we know how many people use it, the app sends an anonymous note when it's installed, once a day while
it runs, and when it's uninstalled: a random id it makes for itself, the app and macOS versions, the chip, and which
place and zoom are on. No name, email, files or IP address are kept. Switch it off in ❄ → Settings → Share anonymous
usage.

Each scene is a film recorded at full quality (4K on Retina and 4K screens). The first time you open one, it downloads
in the background while a picture of it shows; after that it plays straight away, even offline. The first line of the
menu always says what it's doing, or why it's resting.

## Frames itself around your desktop

The picture shifts and zooms a touch so the scene's centrepiece (Alma Mater and the library; the town's tree) stays
clear of your widgets and desktop icons. Move a widget and it glides to the new spot a moment later.

## Light on your Mac

The scene is a film, played the way macOS plays its own moving wallpapers. It rests when your windows cover the
screen, when the screen is locked or asleep, in Low Power Mode, and after 5 minutes without input.

## Updates

❄ → Settings → **Check for updates…** (it also looks once a day and offers a new version at the top of the menu).

## Uninstall

❄ → Settings → **Uninstall Startup City Snow…**, or in Terminal:

```bash
pkill -x StartupCitySnow; rm -rf "/Applications/Startup City Snow.app" ~/Applications/"Startup City Snow.app" ~/Library/LaunchAgents/com.startupcity.snow.plist ~/Library/Caches/com.startupcity.snow
```
