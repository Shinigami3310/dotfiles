import Quickshell
import QtQuick

PanelWindow {
    id: root

    anchors.top: true
    color: "transparent"
    exclusiveZone: 0

    width: switcher.width + 84
    height: switcher.height + 36

    Rectangle {
        anchors.fill: parent
        anchors.margins: 5
        color: "black"
        radius: 24
        opacity: 0.8
    }

    AnimatedSwitcher {
        id: switcher

        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)

        expanded: mouse.containsMouse
        collapsedComponent: clockComponent
        expandedComponent: barComponent
    }

    Component {
        id: clockComponent
        Clock {}
    }

    Component {
        id: barComponent
        Bar {}
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
    }
}
