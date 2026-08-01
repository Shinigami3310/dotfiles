import "../core"
import "../features/Selectors/"

SurfaceBase {
    surfaceName: "bluetoothSelector"
    implicitWidth: bluetooth.implicitWidth
    implicitHeight: bluetooth.implicitHeight
    BluetoothSelector {
        id: bluetooth
        anchors.fill: parent
    }
}
