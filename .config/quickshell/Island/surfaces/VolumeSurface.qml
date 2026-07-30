import QtQuick
import "../core"
import "../modules/Volume"

SurfaceBase {
    id: root

    surfaceName: "volume"

    implicitWidth: volume.implicitWidth
    implicitHeight: volume.implicitHeight

    Volume {
        id: volume

        anchors.centerIn: parent
        active: root.active
        onBackRequested: root.backRequested()
    }
}
