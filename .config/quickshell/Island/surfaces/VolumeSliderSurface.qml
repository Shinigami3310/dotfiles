import "../core"
import "../features/Sliders/"

SurfaceBase {
    surfaceName: "volumeSlider"
    implicitWidth: volume.implicitWidth
    implicitHeight: volume.implicitHeight
    Volume {
        id: volume
        anchors.centerIn: parent
        onCloseRequested: parent.closeRequested()
    }
}
