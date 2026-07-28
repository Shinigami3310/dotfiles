import QtQuick
import Quickshell
import "../core"
import "../modules/start"

SurfaceBase {
    surfaceName: "clock"

    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

    StartClock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: parent.surfaceRequested("bar")
    }
}
