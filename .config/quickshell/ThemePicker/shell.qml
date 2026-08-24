import QtQuick
import Quickshell
import Quickshell.Wayland
import "./services"

PanelWindow {
    id: themePickerWindow

    focusable: true
    color: "transparent"

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay

    Component.onCompleted: {
        WallpaperService.load();
    }

    ThemePicker {
        id: themePicker
        anchors.fill: parent
    }
}
