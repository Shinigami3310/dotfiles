import QtQuick
import "../../theme"

Item {
    id: root

    // Локальные константы
    readonly property real switchWidth: 44
    readonly property real switchHeight: 24
    readonly property real scaleHover: 1.05
    readonly property real scalePressed: 0.95

    property bool checked: false
    signal toggled

    implicitWidth: switchWidth
    implicitHeight: switchHeight

    scale: mouseArea.pressed ? scalePressed : (mouseArea.containsMouse ? scaleHover : 1.0)

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
        color: root.checked ? ThemeColor.primary : ThemeColor.surface_container_high
        border.color: ThemeColor.outline_variant
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
            color: root.checked ? ThemeColor.on_primary : ThemeColor.on_surface

            Behavior on x {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Easing.OutBack
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: Motion.fast
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
