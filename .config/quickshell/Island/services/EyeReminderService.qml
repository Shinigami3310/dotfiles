pragma Singleton
import QtQuick
import "../theme"
import "../core"

QtObject {
    id: root

    property bool active: true
    signal surfaceRequested(newName: string)

    readonly property Timer timer: Timer {
        interval: ServiceConfig.eyeReminderIntervalMs
        repeat: true
        running: root.active
        onTriggered: root.surfaceRequested(SurfaceNames.eyeReminder)
    }

    function toggle() {
        active = !active;
    }
}
