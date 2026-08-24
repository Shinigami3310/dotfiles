import QtQuick
import Quickshell
import "../../shared/theme"
import "../../core"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: contentColumn.implicitWidth + (BarConfig.clockPaddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (BarConfig.clockPaddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: BarConfig.clockSpacing

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatTime(clock.date, "hh:mm")
            color: ThemeColor.on_surface
            font {
                family: Theme.font
                pixelSize: BarConfig.clockTimeSize
                weight: Font.Normal
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(clock.date, "ddd dd MMM").toUpperCase()
            color: ThemeColor.on_surface
            font {
                family: Theme.font
                pixelSize: BarConfig.clockDateSize
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
