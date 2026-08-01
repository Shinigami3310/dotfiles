import "../core"
import "../features/Selectors/"

SurfaceBase {
    surfaceName: "wifiSelector"
    implicitWidth: wifi.implicitWidth
    implicitHeight: wifi.implicitHeight
    WifiSelector {
        id: wifi
        anchors.fill: parent
    }
}
