import QtQuick
import "../../../services"
import "../../../core"
import "../../../ui"

ControlButton {
    id: root
    signal surfaceRequested(string newName)
    ServiceClient { service: BluetoothService }
    icon: "Bluetooth.png"
    active: BluetoothService.enabled
    enableRightClick: true

    onClicked: BluetoothService.toggle()
    onRightClicked: root.surfaceRequested(SurfaceNames.bluetoothSelector)
}
