pragma Singleton
import QtQuick

QtObject {
    // Основные роли Matugen M3
    readonly property color surface: "#111318"
    readonly property color surfaceVariant: "#1d2026"
    readonly property color surfaceContainer: "#232830"

    readonly property color textOnSurface: "#e2e2e9"
    readonly property color textOnSurfaceVariant: "#8e9199"

    // Акцентные цвета
    readonly property color primary: "#a8c7ff"
    readonly property color secondary: "#bec6dc"
    readonly property color error: "#ffb4ab"
    readonly property color outlineVariant: "#333842"

    // Привязки UI
    readonly property color panel: surface
    readonly property color panelAlt: surfaceVariant
    readonly property color text: textOnSurface
    readonly property color muted: textOnSurfaceVariant

    // Границы уведомлений по важности
    readonly property color borderLow: outlineVariant
    readonly property color borderNormal: secondary
    readonly property color borderCritical: error
}
