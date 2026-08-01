import "../core"
import "../features/Sliders/"

SurfaceBase {
    surfaceName: "brightnessSlider"
    implicitWidth: brightness.implicitWidth
    implicitHeight: brightness.implicitHeight
    Brightness {
        id: brightness
        anchors.centerIn: parent
        onCloseRequested: parent.closeRequested()
    }
}
