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

    readonly property list<string> nonFocusSurfaces: ["eyeReminder", "brightnessSlider", "volumeSlider", "strip", "homeClock"]
    readonly property bool requiresFocus: host.currentName !== host.initialSurfaceName && !nonFocusSurfaces.includes(host.currentName)
    readonly property bool isFullscreen: modeController.isFullscreen

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
    WlrLayershell.keyboardFocus: requiresFocus ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    mask: Region {
        item: requiresFocus ? root.contentItem : island
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped: eventPoint => {
            if (!island.contains(island.mapFromItem(root.contentItem, eventPoint.position))) {
                host.close();
            }
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
        anchors.topMargin: root.isFullscreen ? 0 : 8

        SurfaceHost {
            id: host
            initialSurfaceName: root.isFullscreen ? "strip" : "homeClock"
            surfaces: catalog
        }
    }

    function requestSurface(name) {
        if (!root.isFullscreen) {
            host.open(name);
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
        function onSurfaceRequested(name: string) {
            root.requestSurface(name);
        }
    }
    Connections {
        target: BrightnessService
        function onSurfaceRequested(name: string) {
            // Не открываем OSD, если активна controlPanel (у неё свои слайдеры)
            if (host.currentName !== "controlPanel")
                host.open(name);
        }
    }
    Connections {
        target: AudioService
        function onSurfaceRequested(name: string) {
            // Не открываем OSD, если активна controlPanel (у неё свои слайдеры)
            if (host.currentName !== "controlPanel")
                host.open(name);
        }
    }
}
