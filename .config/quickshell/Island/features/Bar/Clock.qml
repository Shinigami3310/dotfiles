import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    property real paddingX: 10
    property real paddingY: 5
    property int timePixelSize: 18
    property int datePixelSize: 10

    implicitWidth: contentColumn.implicitWidth + (paddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (paddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm")
            font {
                family: Theme.font
                pixelSize: root.timePixelSize
                weight: Font.Medium
            }
            color: Theme.text
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "ddd dd MMM").toUpperCase()
            font {
                family: Theme.font
                pixelSize: root.datePixelSize
                weight: Font.Medium
            }
            color: Theme.textMuted
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.surfaceRequested("calendar")
    }
}
