import QtQuick
import Quickshell
import "../core"
import "../modules/start"

SurfaceBase {
    surfaceName: "clock"
    canGoBack: false

    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

    StartClock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: parent.surfaceRequested("bar")
    }
}
