import QtQuick
import "../../theme"

Item {
    id: root

    property alias text: label.text
    signal clicked

    width: CalendarConfig.navBtnSize
    height: CalendarConfig.navBtnSize

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed

    scale: pressed ? Theme.scalePressed : (hovered ? CalendarConfig.navBtnHoverScale : 1.0)

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        font {
            family: Theme.font
            pixelSize: CalendarConfig.navBtnTextSize
            weight: Font.Bold
        }
        color: root.hovered ? ThemeColor.primary : ThemeColor.on_surface

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: tapHandler
        onTapped: root.clicked()
    }
}
