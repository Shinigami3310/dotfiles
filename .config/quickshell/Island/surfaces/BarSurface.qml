import "../core"
import "../features/Bar"

SurfaceBase {
    id: root
    surfaceName: "bar"
    implicitWidth: bar.implicitWidth
    implicitHeight: bar.implicitHeight
    Bar {
        id: bar
        onSurfaceRequested: name => root.surfaceRequested(name)
        onCloseRequested: root.closeRequested()
    }
}
