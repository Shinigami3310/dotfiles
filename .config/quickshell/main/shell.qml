import Quickshell
import Quickshell.Widgets
import QtQuick

PanelWindow {
    id: root

    anchors.top: true
    margins.top: 10

    color: "transparent"
    exclusiveZone: 0

    implicitWidth: clock.implicitWidth + 64
    implicitHeight: clock.implicitHeight + 16

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"
        radius: 20
        opacity: 0.8
    }

    Clock {
        id: clock
        anchors.centerIn: parent
    }
}
