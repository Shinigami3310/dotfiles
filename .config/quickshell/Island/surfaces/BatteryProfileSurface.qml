import QtQuick
import "../core"
import "../features/Battery"

SurfaceBase {
    id: root
    surfaceName: "batteryProfile"

    implicitWidth: batteryProfile.implicitWidth
    implicitHeight: batteryProfile.implicitHeight

    Battery {
        id: batteryProfile
        anchors.centerIn: parent
    }
}
