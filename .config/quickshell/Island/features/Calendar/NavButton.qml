import QtQuick
import "../../theme"

Item {
    id: root

    property alias text: label.text
    signal clicked

    width: Configs.calNavButtonSize
    height: Configs.calNavButtonSize

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? 0.9 : (hovered ? 1.2 : 1.0)

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
            pixelSize: Configs.calNavIconSize
            weight: Font.DemiBold
        }
        color: root.hovered ? Theme.text : Theme.textMuted

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
