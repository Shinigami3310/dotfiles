import QtQuick
import "../../theme"

Item {
    id: root

    property int dayNumber: 0
    property bool inMonth: false
    property bool selected: false
    property bool isToday: false
    property bool isPast: false

    signal clicked

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    width: 30
    height: 30
    transformOrigin: Item.Center

    scale: pressed ? Configs.scalePressed : (hovered ? Configs.scaleHover : 1.0)
    opacity: isPast ? 0.5 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeStandard
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: root.selected || root.hovered ? ThemeColor.surface_container_high : "transparent"

        border {
            width: (root.selected || root.isToday || root.hovered) ? 1 : 0
            color: (root.selected || root.isToday) ? ThemeColor.primary : ThemeColor.outline
        }

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.inMonth ? root.dayNumber.toString() : ""
        font {
            family: Theme.font
            pixelSize: 12
            weight: root.selected ? Font.Bold : Font.Normal
        }
        color: root.selected || root.isToday ? ThemeColor.primary : ThemeColor.on_surface
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.inMonth
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        enabled: root.inMonth
        onTapped: root.clicked()
    }
}
