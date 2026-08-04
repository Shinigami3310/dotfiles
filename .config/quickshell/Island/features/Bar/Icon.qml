import QtQuick
import QtQuick.Effects
import "../../theme"

Item {
    id: root

    property url source: ""
    property bool active: false

    signal clicked

    implicitWidth: 24
    implicitHeight: 24

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? Configs.scalePressed : (hovered ? Configs.scaleHover : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Image {
        id: iconImage
        anchors.fill: parent
        source: root.source
        visible: false
        asynchronous: true
        cache: true
        smooth: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(width, height)
    }

    MultiEffect {
        anchors.fill: iconImage
        source: iconImage
        colorization: 1.0
        colorizationColor: (root.active || root.pressed) ? ThemeColor.primary : ThemeColor.on_surface

        Behavior on colorizationColor {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton
        onTapped: root.clicked()
    }
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
}
