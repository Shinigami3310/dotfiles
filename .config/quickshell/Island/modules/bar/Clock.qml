import QtQuick
import Quickshell
import "../../Singletons"

Item {
    id: root

    signal surfaceRequested(string newName, var payload)

    property real paddingX: 10
    property real paddingY: 5
    property int timePixelSize: 18
    property int datePixelSize: 10

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    implicitWidth: contentColumn.implicitWidth + paddingX * 2
    implicitHeight: contentColumn.implicitHeight + paddingY * 2

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 2

        Text {
            id: timeLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "hh:mm")
            font.family: Theme.font
            font.pixelSize: root.timePixelSize
            font.weight: Font.Medium
            color: Theme.text
            antialiasing: true
        }

        Text {
            id: dateLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "ddd dd MMM").toUpperCase()
            font.family: Theme.font
            font.pixelSize: root.datePixelSize
            font.weight: Font.Medium
            color: Theme.textMuted
            antialiasing: true
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.surfaceRequested("calendar", null)
    }
}
