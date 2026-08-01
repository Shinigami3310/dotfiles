import "../core"
import "../features/Bar"

SurfaceBase {
    surfaceName: "bar"
    implicitWidth: bar.implicitWidth
    implicitHeight: bar.implicitHeight

    Bar {
        id: bar
        anchors.centerIn: parent
        onSurfaceRequested: name => parent.surfaceRequested(name)
        onCloseRequested: closeRequested()
    }
}
