import QtQuick
import "../../../services/"

ControlButton {
    NightModeService {
        id: nightModeService
    }
    icon: "NightMode.png"
    active: nightModeService.active

    onClicked: nightModeService.toggle()
}
