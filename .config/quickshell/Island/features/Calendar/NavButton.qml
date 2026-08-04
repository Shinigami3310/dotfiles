import QtQuick
import "../../theme"

Item {
    id: root

    property alias text: label.text
    signal clicked

    width: 20
    height: 20

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? Configs.scalePressed : (hovered ? 1.2 : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        font {
            family: Theme.font
            pixelSize: 20
            weight: Font.Bold
        }
        color: root.hovered ? ThemeColor.primary : ThemeColor.on_surface

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: root.clicked()
    }
}
