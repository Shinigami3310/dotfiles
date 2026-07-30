import QtQuick
import Quickshell
import "../core"
import "../features/Eye"

SurfaceBase {
    surfaceName: "eye"
    canGoBack: false

    implicitWidth: eye.implicitWidth
    implicitHeight: eye.implicitHeight

    Eye {
        id: eye
        anchors.centerIn: parent
        onBackRequested: parent.backRequested()
    }
}
