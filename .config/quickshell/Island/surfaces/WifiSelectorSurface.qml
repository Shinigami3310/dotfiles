import "../core"
import "../features/Selectors/"

SurfaceBase {
    id: root
    surfaceName: "wifiSelector"
    implicitWidth: wifi.implicitWidth
    implicitHeight: wifi.implicitHeight
    WifiSelector {
        id: wifi
    }
}
