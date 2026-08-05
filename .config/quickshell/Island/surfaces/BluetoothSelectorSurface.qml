import "../core"
import "../features/Selectors/"

SurfaceBase {
    id: root
    surfaceName: "bluetoothSelector"
    implicitWidth: bluetooth.implicitWidth
    implicitHeight: bluetooth.implicitHeight
    BluetoothSelector {
        id: bluetooth
    }
}
