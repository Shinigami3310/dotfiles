import QtQuick
import Quickshell
import "../core"
import "../modules/Battery"

SurfaceBase {
    id: root

    surfaceName: "battery"

    implicitWidth: battery.implicitWidth
    implicitHeight: battery.implicitHeight

    Battery {
        id: battery
        anchors.centerIn: parent
    }
}
