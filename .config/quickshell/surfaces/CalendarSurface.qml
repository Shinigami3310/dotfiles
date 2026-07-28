import QtQuick
import Quickshell
import "../core"
import "../Singletons"
import "../modules/calendar"

SurfaceBase {
    surfaceName: "calendar"

    implicitWidth: calendar.implicitWidth
    implicitHeight: calendar.implicitHeight

    Calendar {
        id: calendar
        anchors.centerIn: parent
    }
}
