import QtQuick
import "../../services/"

Icon {
    source: "../../assets/icons/power.png"
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: PowerService.openMenu()
    }
}
