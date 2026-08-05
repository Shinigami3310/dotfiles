import "../core"
import "../features/AppLauncher"

SurfaceBase {
    id: root
    surfaceName: "appLauncher"
    implicitWidth: appLauncher.implicitWidth
    implicitHeight: appLauncher.implicitHeight
    AppLauncher {
        id: appLauncher
        onCloseRequested: root.closeRequested()
    }
}
