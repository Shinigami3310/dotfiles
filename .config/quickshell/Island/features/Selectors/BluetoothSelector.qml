import QtQuick
import "../../services"

BaseSelector {
    id: root

    title: "Bluetooth"
    iconSource: Qt.resolvedUrl("../../assets/icons/Bluetooth.png")
    isServiceEnabled: BluetoothService.enabled
    listModel: BluetoothService.deviceModel

    Component.onCompleted: BluetoothService.retain()
    Component.onDestruction: BluetoothService.release()

    onToggleRequested: BluetoothService.toggle()

    delegate: Component {
        SelectorItemCard {
            name: model.name
            security: ""
            isConnected: model.connected
            isConnecting: BluetoothService.connectingMac === model.mac

            onConnectRequested: password => {
                BluetoothService.connectToDevice(model.mac);
            }
        }
    }
}
