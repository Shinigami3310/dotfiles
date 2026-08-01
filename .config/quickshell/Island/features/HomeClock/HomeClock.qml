import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: timeText.implicitWidth + (Configs.clockPaddingX * 2)
    implicitHeight: timeText.implicitHeight + (Configs.clockPaddingY * 2)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font {
            family: Theme.font
            pixelSize: Configs.clockPixelSize
            weight: Font.Medium
        }
        color: Theme.text
        antialiasing: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.surfaceRequested("bar")
    }
}
