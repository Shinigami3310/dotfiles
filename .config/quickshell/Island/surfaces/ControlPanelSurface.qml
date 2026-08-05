import "../core"
import "../features/ControlPanel"

SurfaceBase {
    id: root
    surfaceName: "controlPanel"
    implicitWidth: controlPanel.implicitWidth
    implicitHeight: controlPanel.implicitHeight
    ControlPanel {
        id: controlPanel
        onSurfaceRequested: name => root.surfaceRequested(name)
    }
}
