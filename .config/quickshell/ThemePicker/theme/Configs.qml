pragma Singleton

import QtQuick
import Quickshell

// Carousel layout and scaling constants.
// All "magic numbers" live here for easy tuning.
QtObject {
    // --- Paths (single source of truth for QML) ---
    // Read from environment variables with defaults as fallback,
    // so QML doesn't need patching when moving to another system.
    readonly property string wallpaperDir: Quickshell.env("WALLPAPER_DIR") || "/home/Rostislav/Pictures/Wallpapers"
    readonly property string setThemeScriptPath: Quickshell.env("SET_THEME_SCRIPT") || "/home/Rostislav/.config/quickshell/ThemePicker/scripts/set-theme"
    readonly property string palettePath: Quickshell.env("PALETTE_PATH") || "/home/Rostislav/.config/quickshell/colors.json"

    // Card height as a fraction of screen height (~1/3)
    readonly property real cardHeightRatio: 0.3

    // Card aspect ratio (width / height)
    readonly property real cardAspect: 1.6

    // Horizontal step between card centers as a fraction of card width
    readonly property real spacingRatio: 0.8

    // Parallelogram bevel as a fraction of card height.
    // Edge angle from horizontal: bevelRatio = tan(90° - angle).
    // 60° → tan(30°) ≈ 0.577. Tune this to change the angle.
    readonly property real bevelRatio: 0.7

    // Scale factor: only the center card is scaled, others stay at 1.0
    readonly property real centerScaleFactor: 1.5

    // Overlay dimming (0x99 ≈ 0.6 opacity)
    readonly property color overlayColor: Qt.rgba(0, 0, 0, 0.6)

    // --- Navigation constants ---
    // Auto-repeat delay while a key is held (ms)
    readonly property int navRepeatDelay: 80

    // --- Theme application constants ---
    // Timeout for scripts/set-theme (ms)
    readonly property int themeApplyTimeout: 10000

    // --- Carousel rendering constants ---
    // Base z-index of a card and step for conflict resolution
    readonly property int zBase: 100
    readonly property int zStep: 10
}