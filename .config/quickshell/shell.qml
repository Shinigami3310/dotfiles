import QtQuick
import Quickshell
import Quickshell.Wayland
import "core"
import "Singletons"
import "surfaces"

PanelWindow {
    id: root

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    exclusiveZone: 0
    color: "transparent"

    focusable: true

    mask: Region {
        item: island
    }

    Island {
        id: island

        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        backgroundColor: Theme.panelBg
        borderColor: Theme.panelBorder

        SurfaceHost {
            id: host
            initialSurfaceName: "start"

            surfaces: ({
                    start: {
                        component: startSurfaceComponent,
                        escapePolicy: 0
                    },
                    bar: {
                        component: barSurfaceComponent,
                        wantsKeyboardFocus: true
                    },
                    calendar: {
                        component: calendarSurfaceComponent,
                        wantsKeyboardFocus: true
                    }
                })
        }
    }

    Component {
        id: startSurfaceComponent
        StartSurface {}
    }

    Component {
        id: barSurfaceComponent
        BarSurface {}
    }

    Component {
        id: calendarSurfaceComponent
        CalendarSurface {}
    }
}
