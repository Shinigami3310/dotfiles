pragma Singleton
import QtQuick

QtObject {
    readonly property string font: "Inter"

    readonly property color panelBg: Qt.alpha(Palette.surfaceContainer, 0.96)
    readonly property color panelBorder: Qt.alpha(Palette.outline, 0.40)
    readonly property color panelInner: Palette.surfaceContainerHigh
    readonly property color panelInnerSoft: Palette.surfaceContainerLow

    readonly property color accent: Palette.primary
    readonly property color accentSoft: Qt.alpha(Palette.primary, 0.18)
    readonly property color accentText: Palette.onPrimaryContainer

    readonly property color text: Palette.bright
    readonly property color textMuted: Qt.alpha(Palette.bright, 0.72)
    readonly property color textDim: Qt.alpha(Palette.bright, 0.52)

    readonly property color surface: Palette.surface
    readonly property color surface1: Palette.surfaceContainerLow
    readonly property color surface2: Palette.surfaceContainer
    readonly property color surface3: Palette.surfaceContainerHigh
    readonly property color surface4: Palette.surfaceContainerHighest

    readonly property color separator: Qt.alpha(Palette.outlineVariant, 0.55)
    readonly property color hover: Qt.alpha(Palette.primary, 0.12)
    readonly property color pressed: Qt.alpha(Palette.primary, 0.22)
}
