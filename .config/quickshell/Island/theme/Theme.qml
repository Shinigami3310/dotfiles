pragma Singleton
import QtQuick

QtObject {
    readonly property string font: "JetBrains Mono"

    readonly property color panelBg: Qt.alpha("#342b25", 0.96)
    readonly property color panelBorder: Qt.alpha("#78675c", 0.40)
    readonly property color panelInner: "#40352f"
    readonly property color panelInnerSoft: "#2b241f"

    readonly property color accent: "#c97b4f"
    readonly property color accentSoft: Qt.alpha("#c97b4f", 0.18)
    readonly property color accentText: "#f4e6dd"

    readonly property color text: "#fff7f1"
    readonly property color textMuted: Qt.alpha("#fff7f1", 0.72)
    readonly property color textDim: Qt.alpha("#fff7f1", 0.52)

    readonly property color surface: "#1f1a16"
    readonly property color surface1: "#2b241f"
    readonly property color surface2: "#342b25"
    readonly property color surface3: "#40352f"
    readonly property color surface4: "#4b3f38"

    readonly property color separator: Qt.alpha("#5b4c42", 0.55)
    readonly property color hover: Qt.alpha("#c97b4f", 0.12)
    readonly property color pressed: Qt.alpha("#c97b4f", 0.22)
}
