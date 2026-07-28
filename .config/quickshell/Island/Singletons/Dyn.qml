pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    // Keep this path aligned with the external palette writer.
    // In your archive the file lives in ~/.cache/ricelin/colors.json.
    readonly property string palettePath: (Quickshell.env("XDG_CACHE_HOME") || (Quickshell.env("HOME") + "/.cache")) + "/ricelin/colors.json"

    readonly property string surface: palette.surface
    readonly property string surfaceContainerLow: palette.surface_container_low
    readonly property string surfaceContainer: palette.surface_container
    readonly property string surfaceContainerHigh: palette.surface_container_high
    readonly property string surfaceContainerHighest: palette.surface_container_highest
    readonly property string outline: palette.outline
    readonly property string outlineVariant: palette.outline_variant

    readonly property string primary: palette.primary
    readonly property string primaryContainer: palette.primary_container
    readonly property string onPrimaryContainer: palette.on_primary_container

    readonly property string cream: palette.cream
    readonly property string bright: palette.bright
    readonly property string subtle: palette.subtle
    readonly property string dim: palette.dim
    readonly property string faint: palette.faint
    readonly property string iconDim: palette.icon_dim
    readonly property string tickRest: palette.tick_rest

    FileView {
        id: paletteFile
        path: Dyn.palettePath
        blockLoading: true
        watchChanges: true
        printErrors: false

        onFileChanged: reload()

        JsonAdapter {
            id: palette

            property string surface: "#1f1a16"
            property string surface_container_low: "#2b241f"
            property string surface_container: "#342b25"
            property string surface_container_high: "#40352f"
            property string surface_container_highest: "#4b3f38"
            property string outline: "#78675c"
            property string outline_variant: "#5b4c42"

            property string primary: "#c97b4f"
            property string primary_container: "#5a3224"
            property string on_primary_container: "#f4e6dd"

            property string cream: "#e9d9cf"
            property string bright: "#fff7f1"
            property string subtle: "#c4b2a5"
            property string dim: "#938174"
            property string faint: "#6e5f55"
            property string icon_dim: "#857568"
            property string tick_rest: "#c8baa9"
        }
    }
}
