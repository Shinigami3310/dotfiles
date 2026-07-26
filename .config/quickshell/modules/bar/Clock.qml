import QtQuick
import Quickshell
import "../../Singletons"

Item {
    id: root

    signal clicked

    property real paddingX: 10
    property real paddingY: 5
    property int timePixelSize: 18
    property int datePixelSize: 10

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    implicitWidth: column.implicitWidth + paddingX * 2
    implicitHeight: column.implicitHeight + paddingY * 2

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm")
            font.family: Theme.font
            font.pixelSize: root.timePixelSize
            font.weight: Font.Medium
            color: Theme.text
            antialiasing: true
        }

        Text {
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
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
