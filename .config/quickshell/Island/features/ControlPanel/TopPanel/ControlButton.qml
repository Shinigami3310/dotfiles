import QtQuick
import QtQuick.Effects
import "../../../theme"
import "../"

Item {
    id: root

    property string icon: ""
    property bool active: false
    property bool enableRightClick: false

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: leftTap.pressed || rightTap.pressed

    signal clicked
    signal rightClicked

    implicitWidth: ControlPanelConfig.buttonSize
    implicitHeight: ControlPanelConfig.buttonSize

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: ControlPanelConfig.buttonRadius
        color: "transparent"
        border.color: root.active || root.pressed ? ThemeColor.primary : ThemeColor.outline_variant
        border.width: 1

        scale: root.pressed ? ControlPanelConfig.buttonPressedScale : (root.hovered ? ControlPanelConfig.buttonHoverScale : 1.0)

        Behavior on border.color {
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
            width: ControlPanelConfig.buttonIconSize
            height: ControlPanelConfig.buttonIconSize
            sourceSize: Qt.size(width * 2, height * 2)
            source: root.icon !== "" ? Qt.resolvedUrl("../../../assets/icons/" + root.icon) : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            visible: false
        }

        MultiEffect {
            anchors.fill: iconImage
            source: iconImage
            colorization: 1.0
            colorizationColor: (root.pressed || root.active) ? ThemeColor.primary : ThemeColor.on_surface

            Behavior on colorizationColor {
                ColorAnimation {
                    duration: Motion.standard
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: leftTap
        acceptedButtons: Qt.LeftButton
        onTapped: root.clicked()
    }

    TapHandler {
        id: rightTap
        enabled: root.enableRightClick
        acceptedButtons: Qt.RightButton
        onTapped: root.rightClicked()
    }
}
