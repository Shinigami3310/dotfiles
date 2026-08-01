pragma Singleton
import QtQuick

QtObject {
    readonly property string font: "Inter"

    // Fallback-значения — те же, что в JsonAdapter
    readonly property color panelBg: Qt.alpha(Palette.surfaceContainer || "#342b25", 0.96)
    readonly property color panelBorder: Qt.alpha(Palette.outline || "#78675c", 0.40)
    readonly property color panelInner: Palette.surfaceContainerHigh || "#40352f"
    readonly property color panelInnerSoft: Palette.surfaceContainerLow || "#2b241f"

    readonly property color accent: Palette.primary || "#c97b4f"
    readonly property color accentSoft: Qt.alpha(Palette.primary || "#c97b4f", 0.18)
    readonly property color accentText: Palette.onPrimaryContainer || "#f4e6dd"

    readonly property color text: Palette.bright || "#fff7f1"
    readonly property color textMuted: Qt.alpha(Palette.bright || "#fff7f1", 0.72)
    readonly property color textDim: Qt.alpha(Palette.bright || "#fff7f1", 0.52)

    readonly property color surface: Palette.surface || "#1f1a16"
    readonly property color surface1: Palette.surfaceContainerLow || "#2b241f"
    readonly property color surface2: Palette.surfaceContainer || "#342b25"
    readonly property color surface3: Palette.surfaceContainerHigh || "#40352f"
    readonly property color surface4: Palette.surfaceContainerHighest || "#4b3f38"

    readonly property color separator: Qt.alpha(Palette.outlineVariant || "#5b4c42", 0.55)
    readonly property color hover: Qt.alpha(Palette.primary || "#c97b4f", 0.12)
    readonly property color pressed: Qt.alpha(Palette.primary || "#c97b4f", 0.22)
}
