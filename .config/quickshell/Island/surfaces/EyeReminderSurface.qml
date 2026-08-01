import "../core"
import "../features/Eye"

SurfaceBase {
    surfaceName: "eyeReminder"
    canGoBack: false
    implicitWidth: eye.implicitWidth
    implicitHeight: eye.implicitHeight
    Eye {
        id: eye
        anchors.centerIn: parent
        onBackRequested: parent.backRequested()
    }
}
