import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "core"
import "theme"
import "surfaces"
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

    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.anchors.top: true
    WlrLayershell.keyboardFocus: host.currentName === "launcher" ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

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
            initialSurfaceName: isFullscreen ? "strip" : "homeClock"   // изменено с "clock"
            surfaces: catalog
        }
    }

    // Экземпляр каталога (синглтон)
    SurfaceCatalog {
        id: catalog
    }

    IpcHandler {
        target: "island"
        function openVolume() {
            if (!root.isFullscreen)
                AudioService.openPanel();   // внутри сервиса должно вызывать surfaceRequested("volumeSlider")
        }
        function openBrightness() {
            if (!root.isFullscreen)
                BrightnessService.openPanel(); // внутри должно быть "brightnessSlider"
        }
        function openLauncher() {
            if (!root.isFullscreen)
                host.open("appLauncher");   // изменено с "launcher"
        }
    }

    // Хелпер для открытия поверхностей по запросу сервисов
    QtObject {
        id: surfaceOpener
        function open(name) {
            if (!root.isFullscreen)
                host.open(name);
        }
    }

    Connections {
        target: PowerService
        function onCloseRequested() {
            host.close();
        }
    }
    Connections {
        target: EyeReminderService
        function onSurfaceRequested(n) {
            surfaceOpener.open("eyeReminder");
        }
    }  // принудительно маппим
    Connections {
        target: AudioService
        function onSurfaceRequested(n) {
            surfaceOpener.open("volumeSlider");
        }
    }
    Connections {
        target: BrightnessService
        function onSurfaceRequested(n) {
            surfaceOpener.open("brightnessSlider");
        }
    }
}
