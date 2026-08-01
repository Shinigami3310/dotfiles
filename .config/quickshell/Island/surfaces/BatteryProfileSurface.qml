import "../core"
import "../features/Battery"

SurfaceBase {
    surfaceName: "batteryProfile"
    implicitWidth: battery.implicitWidth
    implicitHeight: battery.implicitHeight
    Battery {
        id: battery
        anchors.centerIn: parent
    }
}
