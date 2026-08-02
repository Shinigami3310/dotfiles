import QtQuick
import "../../theme"

Item {
    id: root

    property alias text: label.text
    signal clicked

    width: 22
    height: 22

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
