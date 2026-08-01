import "../core"
import "../features/ControlPanel"

SurfaceBase {
    surfaceName: "controlPanel"
    implicitWidth: controlPanel.implicitWidth
    implicitHeight: controlPanel.implicitHeight
    ControlPanel {
        id: controlPanel
        anchors.centerIn: parent
        onSurfaceRequested: name => parent.surfaceRequested(name)
    }
}
