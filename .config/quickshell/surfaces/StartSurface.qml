import QtQuick
import Quickshell
import "../core"
import "../Singletons"

SurfaceBase {
    id: root

    surfaceName: "start"

    property int paddingX: 30
    property int paddingY: 5
    property int timePixelSize: 18
    property bool hoverArmed: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    implicitWidth: clockText.implicitWidth + paddingX * 2
    implicitHeight: clockText.implicitHeight + paddingY * 2

    Timer {
        id: armTimer
        interval: 150
        repeat: false
        running: false

        onTriggered: root.hoverArmed = true
    }

    Component.onCompleted: armTimer.restart()

    onActiveChanged: {
        if (active) {
            hoverArmed = false;
            armTimer.restart();
        }
    }

    Text {
        id: clockText
        anchors.centerIn: parent

        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.family: Theme.font
        font.pixelSize: root.timePixelSize
        font.weight: Font.Medium
        color: Theme.text
        antialiasing: true
    }

    HoverHandler {
        id: hover

        onHoveredChanged: {
            if (hovered && root.hoverArmed) {
                root.hoverArmed = false;
                root.surfaceRequested("bar", null);
            }
        }
    }
}
