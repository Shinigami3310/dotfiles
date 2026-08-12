pragma Singleton

import QtQuick

QtObject {
    // Global UI scale factor (1.2 = 20% larger)
    readonly property real uiScale: 1.25

    property real scaleHover: 1.1
    property real scalePressed: 0.9

    property real buttonWidth: 112 * uiScale
    property real buttonHeight: 124 * uiScale
    property real buttonBodySize: 96 * uiScale
    property real buttonRadius: 26 * uiScale
    property real buttonIconSize: 32 * uiScale
    property real buttonSpacing: 8 * uiScale
    property real buttonBorderWidth: 1 * uiScale
    property real buttonBorderWidthActive: 2 * uiScale
    property real buttonAlpha: 0.65
    property real buttonFontSize: 13 * uiScale
    property string buttonFontFamily: "JetBrains Mono"
}
