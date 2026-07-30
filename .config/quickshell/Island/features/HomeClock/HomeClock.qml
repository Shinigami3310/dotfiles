import QtQuick
import Quickshell
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string newName, var payload)

    property real paddingX: 40
    property real paddingY: 8
    property int timePixelSize: 18
    property bool ready: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    implicitWidth: timeText.implicitWidth + paddingX * 2
    implicitHeight: timeText.implicitHeight + paddingY * 2

    Timer {
        id: hoverDelay
        interval: 250
        repeat: false
        onTriggered: root.surfaceRequested("bar", null)
    }

    Timer {
        id: initTimer
        interval: Motion.standard + Motion.fade
        running: true
        repeat: false
        onTriggered: root.ready = true
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.family: Theme.font
        font.pixelSize: root.timePixelSize
        font.weight: Font.Medium
        color: Theme.text
        antialiasing: true
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onEntered: {
            if (root.ready)
                hoverDelay.restart();
        }
        onExited: hoverDelay.stop()
    }
}
