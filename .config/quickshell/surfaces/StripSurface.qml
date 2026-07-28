import QtQuick
import Quickshell
import "../core"

SurfaceBase {
    surfaceName: "strip"
    canGoBack: false

    implicitWidth: 60
    implicitHeight: 12

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: surfaceRequested("clock")
    }
}
