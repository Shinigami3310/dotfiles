import "../core"
import "../features/Calendar"

SurfaceBase {
    id: root
    surfaceName: "calendar"
    implicitWidth: calendar.implicitWidth
    implicitHeight: calendar.implicitHeight
    Calendar {
        id: calendar
    }
}
