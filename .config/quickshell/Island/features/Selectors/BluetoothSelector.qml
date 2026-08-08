import QtQuick
import "../../services"
import "../../ui"

BaseSelector {
    id: root

    title: "Bluetooth"
    iconSource: Qt.resolvedUrl("../../assets/icons/Bluetooth.png")
    isServiceEnabled: BluetoothService.enabled
    listModel: BluetoothService.deviceModel

    ServiceClient { service: BluetoothService }

    onToggleRequested: BluetoothService.toggle()

    delegate: Component {
        SelectorItemCard {
            name: model.name
            isConnected: model.connected
            isConnecting: BluetoothService.connectingMac === model.mac

            onConnectRequested: password => {
                BluetoothService.connectToDevice(model.mac);
            }
        }
    }
}
