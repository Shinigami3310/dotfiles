pragma Singleton
import QtQuick
import "../../theme"

QtObject {
    id: root

    property bool active: true
    signal surfaceRequested(string newName)

    readonly property Timer timer: Timer {
        interval: Configs.eyeReminderInterval
        repeat: true
        running: root.active
        onTriggered: root.surfaceRequested("eyeReminder")
    }

    function toggle() {
        active = !active;
    }
}
