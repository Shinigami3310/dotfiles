import QtQuick
import "../../services/"

ControlButton {
    icon: "NightMode.png"
    text: "Night"
    active: NightModeService.active

    onClicked: NightModeService.toggle()
}
