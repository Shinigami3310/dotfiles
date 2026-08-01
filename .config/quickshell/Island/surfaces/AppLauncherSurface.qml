import "../core"
import "../features/AppLauncher"

SurfaceBase {
    surfaceName: "appLauncher"
    implicitWidth: appLauncher.implicitWidth
    implicitHeight: appLauncher.implicitHeight
    AppLauncher {
        id: appLauncher
        anchors.fill: parent
        onCloseRequested: parent.closeRequested()
    }
}
