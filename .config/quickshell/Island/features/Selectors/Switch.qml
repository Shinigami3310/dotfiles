import QtQuick
import "../../theme"

Item {
    id: root

    property bool checked: false
    signal toggled

    implicitWidth: Configs.switchWidth
    implicitHeight: Configs.switchHeight

    scale: mouseArea.pressed ? Configs.clickScale : (mouseArea.containsMouse ? Configs.hoverScale : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Easing.OutBack
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? Theme.accent : Theme.surface2
        border.color: Theme.panelBorder
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: handle
            height: bg.height - 6
            width: height
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? bg.width - width - 3 : 3
            color: Theme.text

            Behavior on x {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.checked = !root.checked;
            root.toggled();
        }
    }
}
