import QtQuick
import QtQuick.Effects
import "../../services"
import "../../theme"

Rectangle {
    id: root

    readonly property int profileBtnSize: 68
    readonly property int profileBtnRadius: 16
    readonly property int profileIconSize: 24

    required property string profileId
    required property url iconSource
    property BatteryService service: null

    readonly property bool isActive: service?.activeProfile === profileId
    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    implicitWidth: profileBtnSize
    implicitHeight: profileBtnSize
    radius: profileBtnRadius

    color: hovered ? ThemeColor.surface_container_high : ThemeColor.surface_container

    border {
        color: isActive || hovered ? ThemeColor.primary : "transparent"
        width: isActive ? 2 : 0
    }

    scale: pressed ? Configs.scalePressed : (hovered ? Configs.scaleHover : 1.0)

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

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: root.service?.setProfile(root.profileId)
    }

    Item {
        anchors.centerIn: parent
        width: profileIconSize
        height: profileIconSize

        Image {
            id: iconImage
            anchors.fill: parent
            source: root.iconSource
            visible: false
            asynchronous: true
            smooth: true
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(width, height)
        }

        MultiEffect {
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: (root.isActive || root.pressed) ? ThemeColor.primary : ThemeColor.on_surface

            Behavior on colorizationColor {
                ColorAnimation {
                    duration: Motion.fast
                }
            }
        }
    }
}
