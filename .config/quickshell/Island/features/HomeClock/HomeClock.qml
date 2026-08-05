import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    readonly property int paddingX: 40
    readonly property int paddingY: 12

    implicitWidth: timeText.implicitWidth + (paddingX * 2)
    implicitHeight: timeText.implicitHeight + (paddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatTime(clock.date, "hh:mm")
        font {
            family: Theme.font
            pixelSize: 18
            weight: Font.Normal
        }
        color: ThemeColor.on_surface
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested("bar")
    }
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
