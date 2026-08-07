import QtQuick
import "../../../services"
import "../../../core"

ControlButton {
    id: root
    signal surfaceRequested(string newName)
    Component.onCompleted: WifiService.retain()
    Component.onDestruction: WifiService.release()
    icon: "Wifi.png"
    active: WifiService.enabled
    enableRightClick: true

    onClicked: WifiService.toggle()
    onRightClicked: root.surfaceRequested(SurfaceNames.wifiSelector)
}
