import QtQuick
import "../../services/Demons/"

Icon {
    source: "../../assets/icons/power.png"
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: PowerService.openMenu()
    }
}
