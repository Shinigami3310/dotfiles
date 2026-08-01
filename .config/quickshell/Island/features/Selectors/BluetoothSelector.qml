import QtQuick
import "../../services/integrations"

BaseSelector {
    id: root

    title: "Bluetooth"
    iconSource: Qt.resolvedUrl("../../assets/icons/Bluetooth.png")
    isServiceEnabled: BluetoothService.enabled
    listModel: BluetoothService.deviceModel

    // Управление активностью фонового сервиса!
    Component.onCompleted: BluetoothService.retain()
    Component.onDestruction: BluetoothService.release()

    onToggleRequested: BluetoothService.toggle()

    delegate: Component {
        SelectorItemCard {
            name: model.name
            security: ""
            isConnected: model.connected
            isConnecting: BluetoothService.connectingMac === model.mac

            onConnectRequested: {
                BluetoothService.connectToDevice(model.mac);
            }
        }
    }
}
