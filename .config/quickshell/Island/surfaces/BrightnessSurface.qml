import QtQuick
import "../core"
import "../modules/Brightness"

SurfaceBase {
    id: root

    surfaceName: "brightness"

    implicitWidth: brightness.implicitWidth
    implicitHeight: brightness.implicitHeight

    Brightness {
        id: brightness

        anchors.centerIn: parent
        active: root.active
        onBackRequested: root.backRequested()
    }
}
