import QtQuick
import "../core"
import "../features/Sliders/"

SurfaceBase {
    id: root

    surfaceName: "brightnessSlider"

    implicitWidth: brightness.implicitWidth
    implicitHeight: brightness.implicitHeight

    Brightness {
        id: brightness

        anchors.centerIn: parent
        active: root.active
        onBackRequested: root.backRequested()
    }
}
