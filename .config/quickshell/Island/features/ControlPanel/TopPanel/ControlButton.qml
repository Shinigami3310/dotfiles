import QtQuick
import Qt5Compat.GraphicalEffects
import "../../../theme"

Item {
    id: root

    property string icon: ""
    property bool active: false
    property bool enableRightClick: false

    signal clicked
    signal rightClicked

    implicitWidth: Configs.controlButtonSize
    implicitHeight: Configs.controlButtonSize

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 12

        border.color: Theme.panelBorder
        border.width: 1

        color: Theme.surface1

        scale: mouseArea.pressed ? 0.95 : (mouseArea.containsMouse ? 1.05 : 1.0)

        Behavior on color {
            ColorAnimation {
                duration: Motion.standard
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Motion.standard
                easing.type: Easing.OutBack
            }
        }

        Image {
            id: iconImage
            anchors.centerIn: parent
            width: Configs.controlImageSize
            height: Configs.controlImageSize
            sourceSize: Qt.size(width * 2, height * 2)
            source: root.icon !== "" ? Qt.resolvedUrl("../../../assets/icons/" + root.icon) : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: false
        }

        ColorOverlay {
            anchors.fill: iconImage
            source: iconImage
            color: (mouseArea.pressed || root.active) ? Theme.accent : Theme.textMuted
            antialiasing: true

            Behavior on color {
                ColorAnimation {
                    duration: Motion.standard
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: root.enableRightClick ? (Qt.LeftButton | Qt.RightButton) : Qt.LeftButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.clicked();
            else if (mouse.button === Qt.RightButton)
                root.rightClicked();
        }
    }
}
