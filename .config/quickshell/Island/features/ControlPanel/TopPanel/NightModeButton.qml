import QtQuick
import "../../../services/"

ControlButton {
    icon: "NightMode.png"
    active: NightModeService.active

    onClicked: NightModeService.toggle()
}
