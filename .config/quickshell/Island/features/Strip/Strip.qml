import QtQuick
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: Configs.stripWidth
    implicitHeight: Configs.stripHeight

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: root.surfaceRequested("homeClock")
    }
}
