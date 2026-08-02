import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "core"
import "theme"
import "services"
import "services/integrations"

PanelWindow {
    id: root

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors.top: true
    WlrLayershell.keyboardFocus: needFocus ? WlrKeyboardFocus.None : WlrKeyboardFocus.Exclusive

    mask: Region {
        item: island
    }

    readonly property var nonFocusSurfaces: ["eyeReminder", "brightnessSlider", "volumeSlider", "strip"]
    readonly property bool needFocus: host.currentName === host.initialSurfaceName || nonFocusSurfaces.includes(host.currentName)
    readonly property bool isFullscreen: modeController.isFullscreen

    function requestSurface(name) {
        if (!root.isFullscreen) {
            host.open(name);
        }
    }

    ModeController {
        id: modeController
        host: host
    }

    SurfaceCatalog {
        id: catalog
    }

    Island {
        id: island

        SurfaceHost {
            id: host
            initialSurfaceName: root.isFullscreen ? "strip" : "homeClock"
            surfaces: catalog
        }
    }

    IpcHandler {
        target: "island"
        function openSurface(name: string) {
            root.requestSurface(name);
        }
    }

    Connections {
        target: EyeReminderService
        function onSurfaceRequested(name) {
            root.requestSurface(name);
        }
    }
    Connections {
        target: BrightnessService
        function onSurfaceRequested(name) {
            root.requestSurface(name);
        }
    }
    Connections {
        target: AudioService
        function onSurfaceRequested(name) {
            root.requestSurface(name);
        }
    }
}
