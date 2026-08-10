import QtQuick
import "../../../services"
import "../../../core"
import "../../../ui"

ControlButton {
    id: root
    signal surfaceRequested(string newName)
    ServiceClient { service: WifiService }
    icon: "Wifi.png"
    active: WifiService.enabled
    enableRightClick: true

    onClicked: WifiService.toggle()
    onRightClicked: root.surfaceRequested(SurfaceNames.wifiSelector)
}
