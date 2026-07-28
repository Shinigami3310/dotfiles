import QtQuick
import "../../services/Demons/"

Icon {
    source: "../../assets/icons/eye.png"
    active: EyeService.active
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: EyeService.toggle()
    }
}
