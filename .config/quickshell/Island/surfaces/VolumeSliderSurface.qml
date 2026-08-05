import "../core"
import "../features/Sliders/"

SurfaceBase {
    id: root
    surfaceName: "volumeSlider"
    implicitWidth: volume.implicitWidth
    implicitHeight: volume.implicitHeight
    Volume {
        id: volume
        onCloseRequested: root.closeRequested()
    }
}
