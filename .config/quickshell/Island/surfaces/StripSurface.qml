import "../core"
import "../features/Strip/"

SurfaceBase {
    surfaceName: "strip"
    canGoBack: false
    implicitWidth: strip.implicitWidth
    implicitHeight: strip.implicitHeight
    Strip {
        id: strip
        onSurfaceRequested: name => parent.surfaceRequested(name)
    }
}
