import QtQuick
import Quickshell
import "../core"
import "../modules/Selectors/"

SurfaceBase {
    surfaceName: "Wifi"

    implicitWidth: wifi.implicitWidth
    implicitHeight: wifi.implicitHeight

    WifiSelector {
        id: wifi
        anchors.centerIn: parent
    }
}
