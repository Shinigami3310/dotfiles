import QtQuick
import "../../shared/theme"
import "../../core"

Item {
    id: root

    signal surfaceRequested(string name)

    implicitWidth: 60
    implicitHeight: 12

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.surfaceRequested(SurfaceNames.homeClock)
    }
}
