pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string font: "Inter"

    readonly property color panelBg: Qt.alpha(Dyn.surfaceContainer, 0.94)
    readonly property color panelBorder: Qt.alpha(Dyn.outline, 0.72)
    readonly property color panelInner: Dyn.surfaceContainerHigh
    readonly property color panelInnerSoft: Dyn.surfaceContainerLow

    readonly property color accent: Dyn.primary
    readonly property color accentSoft: Qt.alpha(Dyn.primary, 0.18)
    readonly property color accentText: Dyn.onPrimaryContainer

    readonly property color text: Dyn.bright
    readonly property color textMuted: Dyn.subtle
    readonly property color textDim: Dyn.dim

    readonly property color surface: Dyn.surface
    readonly property color surface1: Dyn.surfaceContainerLow
    readonly property color surface2: Dyn.surfaceContainer
    readonly property color surface3: Dyn.surfaceContainerHigh
    readonly property color surface4: Dyn.surfaceContainerHighest

    readonly property color separator: Qt.alpha(Dyn.outlineVariant, 0.55)
    readonly property color hover: Qt.alpha(Dyn.primary, 0.12)
    readonly property color pressed: Qt.alpha(Dyn.primary, 0.22)
}
