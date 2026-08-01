import QtQuick
import Qt5Compat.GraphicalEffects
import "../../services"
import "../../theme"

Rectangle {
    id: root

    required property string profileId
    required property url iconSource
    property BatteryService service: null

    readonly property bool isActive: service?.activeProfile === profileId
    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    implicitWidth: Configs.batteryProfileBtnSize
    implicitHeight: Configs.batteryProfileBtnSize
    radius: Configs.batteryProfileBtnRadius

    color: isActive ? Theme.surface2 : (hovered ? Theme.hover : Theme.surface1)

    border {
        color: isActive ? Theme.accent : "transparent"
        width: isActive ? 2 : 0
    }

    scale: pressed ? 0.95 : (hovered && !isActive ? 1.05 : 1.0)

    Behavior on color {
        ColorAnimation {
            duration: Motion.fast
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: Motion.fast
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Item {
        anchors.centerIn: parent
        width: Configs.batteryProfileIconSize
        height: Configs.batteryProfileIconSize

        Image {
            id: iconImage
            anchors.fill: parent
            source: root.iconSource
            visible: false
            asynchronous: true
            smooth: true
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(width * 2, height * 2)
        }

        ColorOverlay {
            anchors.fill: iconImage
            source: iconImage
            color: (root.isActive || root.pressed) ? Theme.accent : (root.hovered ? Theme.text : Theme.textMuted)
            antialiasing: true

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
            if (root.service) {
                root.service.setProfile(root.profileId);
            }
        }
    }
}
