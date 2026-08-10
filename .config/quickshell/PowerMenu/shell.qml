import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./ui"

PanelWindow {
    id: root

    visible: false
    focusable: true
    color: "#66000000"
    surfaceFormat.opaque: false

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    PowerMenuWindow {
        id: powerMenu
        anchors.fill: parent

        onCloseRequested: {
            root.visible = false;
            Qt.quit();
        }
        onActionRequested: (command) => {
            Quickshell.execDetached(command);
            root.visible = false;
            Qt.quit();
        }
    }

    Component.onCompleted: {
        root.visible = true;
        powerMenu.open();
    }
}