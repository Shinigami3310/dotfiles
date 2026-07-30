import QtQuick
import "../../services/Demons/"

ControlButton {
    icon: "DND.png"
    text: "DND"
    active: DndService.active

    onClicked: DndService.toggle()
}
