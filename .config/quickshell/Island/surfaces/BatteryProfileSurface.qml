import "../core"
import "../features/Battery"

SurfaceBase {
    id: root
    surfaceName: "batteryProfile"
    implicitWidth: battery.implicitWidth
    implicitHeight: battery.implicitHeight
    Battery {
        id: battery
    }
}
