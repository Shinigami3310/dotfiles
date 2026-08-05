import "../core"
import "../features/Eye"

SurfaceBase {
    id: root
    surfaceName: "eyeReminder"
    canGoBack: false
    implicitWidth: eye.implicitWidth
    implicitHeight: eye.implicitHeight
    Eye {
        id: eye
        onBackRequested: root.backRequested()
    }
}
