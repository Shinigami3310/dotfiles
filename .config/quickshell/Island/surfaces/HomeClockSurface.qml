import QtQuick
import Quickshell
import "../core"
import "../features/HomeClock"

SurfaceBase {
    surfaceName: "clock"

    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight

    HomeClock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: parent.surfaceRequested("bar")
    }
}
