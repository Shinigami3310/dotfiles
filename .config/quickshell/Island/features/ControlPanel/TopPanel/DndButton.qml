import QtQuick
import "../../../services/"
import "../../../ui"

ControlButton {
    icon: "Dnd.png"
    active: DndService.active
    onClicked: DndService.toggle()

    ServiceClient { service: DndService }
}
