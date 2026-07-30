import QtQuick
import Quickshell
import "../core"
import "../features/Selectors/"

SurfaceBase {
    surfaceName: "wifi"

    implicitWidth: wifi.implicitWidth
    implicitHeight: wifi.implicitHeight

    WifiSelector {
        id: wifi
        anchors.fill: parent
    }
}
