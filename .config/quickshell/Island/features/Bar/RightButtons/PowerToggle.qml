import QtQuick
import "../../../services/"

Icon {
    id: root
    source: "../../../assets/icons/Power.png"

    signal closeRequested

    PowerService {
        id: powerService
        onCloseRequested: root.closeRequested()
    }

    onClicked: powerService.openMenu()
}
