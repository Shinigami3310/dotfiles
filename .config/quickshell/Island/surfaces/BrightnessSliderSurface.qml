import "../core"
import "../features/Sliders/"

SurfaceBase {
    id: root
    surfaceName: "brightnessSlider"
    implicitWidth: brightness.implicitWidth
    implicitHeight: brightness.implicitHeight
    Brightness {
        id: brightness
        onCloseRequested: root.closeRequested()
    }
}
