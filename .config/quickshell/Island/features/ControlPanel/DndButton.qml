import QtQuick
import "../../services/"

ControlButton {
    icon: "DND.png"
    text: "DND"
    active: DndService.active

    onClicked: DndService.toggle()
}
