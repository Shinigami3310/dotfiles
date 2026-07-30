import QtQuick
import "../core"
import "../features/AppLauncher"

SurfaceBase {
    id: root
    surfaceName: "appLauncher"

    implicitWidth: appLauncher.implicitWidth
    implicitHeight: appLauncher.implicitHeight

    AppLauncher {
        id: appLauncher
        anchors.fill: parent
        onCloseRequested: root.closeRequested()
    }

    function enter() {
        active = true;
        Qt.callLater(launcher.focusSearch);
    }
}
