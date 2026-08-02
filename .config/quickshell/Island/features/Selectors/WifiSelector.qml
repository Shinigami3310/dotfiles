import QtQuick
import "../../services/integrations"

BaseSelector {
    id: root

    title: "Wi-Fi"
    iconSource: Qt.resolvedUrl("../../assets/icons/Wifi.png")
    isServiceEnabled: WifiService.enabled
    listModel: WifiService.networkModel

    Component.onCompleted: WifiService.retain()
    Component.onDestruction: WifiService.release()

    onToggleRequested: WifiService.toggle()

    delegate: Component {
        SelectorItemCard {
            name: model.ssid
            security: model.security
            isConnected: model.connected
            isConnecting: WifiService.connectingBssid === model.bssid

            onConnectRequested: password => {
                WifiService.connectToNetwork(model.bssid, password);
            }
        }
    }
}
