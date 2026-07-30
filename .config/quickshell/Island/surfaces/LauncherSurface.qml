import QtQuick
import Quickshell
import "../core"
import "../modules/Launcher"
import "../Singletons/"

SurfaceBase {
    id: root

    surfaceName: "appLauncher"

    implicitWidth: launcher.implicitWidth
    implicitHeight: launcher.implicitHeight

    AppLauncher {
        id: launcher
        anchors.fill: parent
        onCloseRequested: root.closeRequested()
    }

    function enter() {
        active = true;
        Qt.callLater(launcher.focusSearch);
    }
}
