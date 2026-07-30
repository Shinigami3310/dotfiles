import QtQuick
import "../core"
import "../features/Selectors/"

SurfaceBase {
    id: root
    surfaceName: "bluetooth"

    implicitWidth: bluetooth.implicitWidth
    implicitHeight: bluetooth.implicitHeight

    BluetoothSelector {
        id: bluetooth
        anchors.fill: parent
    }
}
