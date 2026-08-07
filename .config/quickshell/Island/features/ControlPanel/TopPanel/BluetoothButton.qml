import QtQuick
import "../../../services"
import "../../../core"

ControlButton {
    id: root
    signal surfaceRequested(string newName)
    Component.onCompleted: BluetoothService.retain()
    Component.onDestruction: BluetoothService.release()
    icon: "Bluetooth.png"
    active: BluetoothService.enabled
    enableRightClick: true

    onClicked: BluetoothService.toggle()
    onRightClicked: root.surfaceRequested(SurfaceNames.bluetoothSelector)
}
