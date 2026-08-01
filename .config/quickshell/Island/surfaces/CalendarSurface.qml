import "../core"
import "../features/Calendar"

SurfaceBase {
    surfaceName: "calendar"
    implicitWidth: calendar.implicitWidth
    implicitHeight: calendar.implicitHeight
    Calendar {
        id: calendar
        anchors.centerIn: parent
    }
}
