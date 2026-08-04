import QtQuick
import "../../theme"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: 60
    implicitHeight: 12

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested("homeClock")
    }
}
