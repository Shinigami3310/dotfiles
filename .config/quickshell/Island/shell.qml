import QtQuick
import Quickshell
import Quickshell.Wayland
import "core"
import "Singletons"
import "surfaces"
import "services"
import "services/Demons"

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
    WlrLayershell.layer: WlrLayer.Overlay

    focusable: true

    mask: Region {
        item: island
    }

    readonly property bool isFullscreen: modeController.isFullscreen

    ModeController {
        id: modeController
        host: host
    }

    Island {
        id: island

        anchors.top: parent.top
        anchors.topMargin: isFullscreen ? 0 : 8
        anchors.horizontalCenter: parent.horizontalCenter

        backgroundColor: Theme.panelBg
        borderColor: Theme.panelBorder

        SurfaceHost {
            id: host
            initialSurfaceName: isFullscreen ? "strip" : "clock"

            surfaces: ({
                    clock: {
                        component: startSurfaceComponent
                    },
                    strip: {
                        component: stripSurfaceComponent
                    },
                    bar: {
                        component: barSurfaceComponent
                    },
                    calendar: {
                        component: calendarSurfaceComponent
                    },
                    eye: {
                        component: eyeSurfaceComponent
                    }
                })
        }
    }

    Component {
        id: stripSurfaceComponent
        StripSurface {}
    }

    Component {
        id: startSurfaceComponent
        ClockSurface {}
    }

    Component {
        id: barSurfaceComponent
        BarSurface {}
    }

    Component {
        id: calendarSurfaceComponent
        CalendarSurface {}
    }

    Component {
        id: eyeSurfaceComponent
        EyeSurface {}
    }
    Connections {
        target: PowerService
        function onCloseRequested() {
            host.close();
        }
    }
    Connections {
        target: EyeService
        function onSurfaceRequested(newName) {
            if (!isFullscreen)
                host.open(newName);
        }
    }
}
