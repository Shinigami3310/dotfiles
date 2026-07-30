import QtQuick
import "../../services/Demons/"

ControlButton {
    id: root

    signal surfaceRequested(string newName)

    icon: "Wifi.png"
    text: "Wi-Fi"
    active: WifiService.enabled
    enableRightClick: true

    onClicked: WifiService.toggle()
    onRightClicked: root.surfaceRequested("wifi")
}
