import QtQuick
import QtQuick.Effects
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

    color: isActive ? Theme.surface2 : Theme.surface1

    border {
        color: isActive || hovered ? Theme.accent : "transparent"
        width: isActive ? 2 : 0
    }

    scale: pressed ? 0.9 : (hovered ? 1.1 : 1.0)

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

        MultiEffect {
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: (root.isActive || root.pressed) ? Theme.accent : (root.hovered ? Theme.text : Theme.textMuted)

            Behavior on colorizationColor {
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
        onClicked: root.service?.setProfile(root.profileId)
    }
}
