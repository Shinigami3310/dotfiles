pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: root

    property bool active: true
    property int intervalMs: 10 * 60 * 1000

    signal surfaceRequested(string newName)

    readonly property Timer timer: Timer {
        interval: intervalMs
        repeat: true
        running: active
        onTriggered: surfaceRequested("eye")
    }

    function toggle() {
        active = !active;
    }
}
