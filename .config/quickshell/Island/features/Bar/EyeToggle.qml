import QtQuick
import "../../services/integrations/"

Icon {
    source: "../../assets/icons/Eye.png"
    active: EyeReminderService.active
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: EyeReminderService.toggle()
    }
}
