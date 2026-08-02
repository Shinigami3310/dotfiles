import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: contentColumn.implicitWidth + (Configs.barClockPaddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (Configs.barClockPaddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: Configs.barClockSpacing

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm")
            color: Theme.text
            font {
                family: Theme.font
                pixelSize: Configs.barClockTimeSize
                weight: Font.Medium
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "ddd dd MMM").toUpperCase()
            color: Theme.textMuted
            font {
                family: Theme.font
                pixelSize: Configs.barClockDateSize
                weight: Font.Medium
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.surfaceRequested("calendar")
    }
}
