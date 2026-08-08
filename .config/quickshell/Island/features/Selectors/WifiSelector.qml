import QtQuick
import "../../services"
import "../../ui"

BaseSelector {
    id: root

    title: "Wi-Fi"
    iconSource: Qt.resolvedUrl("../../assets/icons/Wifi.png")
    isServiceEnabled: WifiService.enabled
    listModel: WifiService.networkModel

    ServiceClient { service: WifiService }

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
