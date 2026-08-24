import QtQuick
import "../../shared/theme"

Item {
    id: root

    signal clicked
    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? Theme.scalePressed : (hovered ? Theme.scaleHover : 1.0)
    Behavior on scale {
        NumberAnimation {
            duration: Motion.durationFast
            easing.type: Motion.curveScaleRelease
        }
    }

    TapHandler {
        id: tapHandler
        cursorShape: Qt.PointingHandCursor
        onTapped: root.clicked()
    }

    HoverHandler {
        id: hoverHandler
    }
}
