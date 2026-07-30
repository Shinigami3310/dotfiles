import QtQuick
import Quickshell
import "../core"
import "../modules/Selectors/"

SurfaceBase {
    surfaceName: "Bluetooth"

    implicitWidth: bluetooth.implicitWidth
    implicitHeight: bluetooth.implicitHeight

    BluetoothSelector {
        id: bluetooth
        anchors.fill: parent
    }
}
