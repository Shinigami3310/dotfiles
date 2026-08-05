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
        onSurfaceRequested: name => root.surfaceRequested(name)
    }
}
