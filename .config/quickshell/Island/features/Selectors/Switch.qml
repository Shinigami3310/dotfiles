import QtQuick
import "../../theme"

Item {
    id: root

    property bool checked: false
    signal toggled

    implicitWidth: SelectorConfig.switchWidth
    implicitHeight: SelectorConfig.switchHeight

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? SelectorConfig.switchPressedScale : (hovered ? SelectorConfig.switchHoverScale : 1.0)

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
        border.width: SelectorConfig.switchBorderWidth

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: handle
            height: bg.height - (SelectorConfig.switchHandleMargin * 2)
            width: height
            radius: height / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? (bg.width - width - SelectorConfig.switchHandleMargin) : SelectorConfig.switchHandleMargin
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

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: root.toggled()
    }
}
