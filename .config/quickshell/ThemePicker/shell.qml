import QtQuick
import Quickshell
import Quickshell.Wayland
import "./services"

PanelWindow {
    id: themePickerWindow

    visible: false
    focusable: true
    color: "transparent"
    surfaceFormat.opaque: false

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    property alias contentRootItem: themePicker.contentRootItem
    property alias fadeAnimation: themePicker.fadeAnimation

    Component.onCompleted: {
        ThemePickerController.view = themePickerWindow;
        WallpaperService.load();
        ThemePickerController.open();
    }

    ThemePicker {
        id: themePicker
        anchors.fill: parent
    }
}