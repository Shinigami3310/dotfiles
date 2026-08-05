import "../core"
import "../features/Strip/"

SurfaceBase {
    id: root
    surfaceName: "strip"
    canGoBack: false
    implicitWidth: strip.implicitWidth
    implicitHeight: strip.implicitHeight
    Strip {
        id: strip
        onSurfaceRequested: name => root.surfaceRequested(name)
    }
}
