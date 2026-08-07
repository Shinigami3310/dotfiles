import QtQuick
import Quickshell
import "../../theme"
import "../../core"

Item {
    id: root

    signal surfaceRequested(string name)

    readonly property int paddingX: 12
    readonly property int paddingY: 8
    readonly property int spacing: 8
    readonly property int dateSize: 10
    readonly property int timeSize: 18

    implicitWidth: contentColumn.implicitWidth + (paddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (paddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: spacing

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(clock.date, "hh:mm")
            color: ThemeColor.on_surface
            font {
                family: Theme.font
                pixelSize: root.timeSize
                weight: Font.Normal
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(clock.date, "ddd dd MMM").toUpperCase()
            color: ThemeColor.on_surface
            font {
                family: Theme.font
                pixelSize: root.dateSize
                weight: Font.Normal
            }
        }
    }

    TapHandler {
        onTapped: root.surfaceRequested(SurfaceNames.calendar)
    }
    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
