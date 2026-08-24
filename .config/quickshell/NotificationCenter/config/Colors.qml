pragma Singleton
import QtQuick
import "../shared/theme"

QtObject {
    readonly property color surface: ThemeColor.surface
    readonly property color surfaceVariant: ThemeColor.surface_container_high
    readonly property color surfaceContainer: ThemeColor.surface_container

    readonly property color textOnSurface: ThemeColor.on_surface
    readonly property color textOnSurfaceVariant: ThemeColor.on_surface_variant

    readonly property color primary: ThemeColor.primary
    readonly property color secondary: ThemeColor.secondary
    readonly property color error: ThemeColor.error
    readonly property color outlineVariant: ThemeColor.outline_variant

    readonly property color panel: surface
    readonly property color panelAlt: surfaceVariant
    readonly property color text: textOnSurface
    readonly property color muted: textOnSurfaceVariant

    readonly property color borderLow: ThemeColor.outline
    readonly property color borderNormal: ThemeColor.secondary
    readonly property color borderCritical: ThemeColor.error
}
