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
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font {
            family: Theme.font
            pixelSize: Configs.clockPixelSize
            weight: Font.Normal
        }
        color: ThemeColor.on_surface
        antialiasing: true
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested("bar")
    }
}
