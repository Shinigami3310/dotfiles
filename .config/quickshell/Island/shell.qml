import QtQuick
import Quickshell
import Quickshell.Io
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
                    },
                    controlPanel: {
                        component: controlPanelComponent
                    },
                    wifi: {
                        component: wifiSurfaceComponent
                    },
                    bluetooth: {
                        component: bluetoothSurfaceComponent
                    },
                    volume: {
                        component: volumeSurfaceComponent
                    },
                    brightness: {
                        component: brightnessSurfaceComponent
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
    Component {
        id: controlPanelComponent
        ControlPanelSurface {}
    }
    Component {
        id: wifiSurfaceComponent
        WifiSurface {}
    }
    Component {
        id: bluetoothSurfaceComponent
        BluetoothSurface {}
    }
    Component {
        id: volumeSurfaceComponent
        VolumeSurface {}
    }
    Component {
        id: brightnessSurfaceComponent
        BrightnessSurface {}
    }

    IpcHandler {
        target: "island"

        function openVolume(): void {
            if (!root.isFullscreen)
                AudioService.openPanel();
        }

        function openBrightness(): void {
            if (!root.isFullscreen)
                BrightnessService.openPanel();
        }
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
    Connections {
        target: AudioService
        function onSurfaceRequested(newName) {
            if (!isFullscreen)
                host.open(newName);
        }
    }
    Connections {
        target: BrightnessService
        function onSurfaceRequested(newName) {
            if (!isFullscreen)
                host.open(newName);
        }
    }
}
