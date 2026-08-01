import QtQuick
import "../../../services/"

ControlButton {
    DndService {
        id: dndService
    }
    icon: "Dnd.png"
    active: dndService.active
    onClicked: dndService.toggle()
}
