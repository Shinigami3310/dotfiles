import QtQuick
import "../../../services/"

ControlButton {
    icon: "Dnd.png"
    active: DndService.active
    onClicked: DndService.toggle()
}
