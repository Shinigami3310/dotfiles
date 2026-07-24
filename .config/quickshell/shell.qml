import Quickshell
import QtQuick
import "core"
import "Singletons"
import "bar"

PanelWindow {
    id: root

    anchors.top: true
    margins.top: 10
    exclusiveZone: 0
    color: "transparent"

    implicitWidth: 500 // change on max possible size
    implicitHeight: 500 // change on max possible size

    mask: Region {
        item: island
    }

    IslandFrame {
        id: island

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: switcher.implicitWidth
        implicitHeight: switcher.implicitHeight

        backgroundColor: Theme.panelBg

        IslandTransition {
            id: switcher
            anchors.fill: parent
            expanded: hover.containsMouse
            collapsedComponent: startClockComponent
            expandedComponent: barComponent
        }

        MouseArea {
            id: hover
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Component {
        id: startClockComponent
        StartClock {
            dateTime: clock.date
        }
    }

    Component {
        id: barComponent
        Bar {
            dateTime: clock.date
        }
    }
}
