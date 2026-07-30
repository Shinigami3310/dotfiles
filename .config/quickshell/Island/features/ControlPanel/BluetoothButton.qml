import QtQuick
import "../../services/"

ControlButton {
    id: root

    signal surfaceRequested(string newName)

    icon: "Bluetooth.png" // NF icon for Bluetooth
    text: "Bluetooth"
    active: BluetoothService.enabled
    enableRightClick: true

    onClicked: BluetoothService.toggle()
    onRightClicked: root.surfaceRequested("bluetooth")
}
