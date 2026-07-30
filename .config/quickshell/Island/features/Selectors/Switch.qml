import QtQuick
import "../../Singletons/"

Item {
    id: root

    property bool checked: false
    signal toggled

    implicitWidth: 44
    implicitHeight: 24

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
                easing.type: Easing.OutQuad // Используем встроенный Easing вместо undefined
            }
        }

        Rectangle {
            id: handle
            width: 18
            height: 18
            radius: 9
            color: Theme.text
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? parent.width - width - 3 : 3

            Behavior on x {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack // Используем встроенный Easing вместо undefined
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.checked = !root.checked;
            root.toggled();
        }
    }
}
