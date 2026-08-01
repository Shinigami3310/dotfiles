import "../core"
import "../features/HomeClock"

SurfaceBase {
    id: root
    surfaceName: "homeClock"
    implicitWidth: clock.implicitWidth
    implicitHeight: clock.implicitHeight
    onBackRequested: root.surfaceRequested("strip")
    HomeClock {
        id: clock
        anchors.centerIn: parent
        onSurfaceRequested: name => parent.surfaceRequested(name)
    }
}
