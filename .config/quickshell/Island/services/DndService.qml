pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../shared/theme"
import "../theme"

QtObject {
    id: root

    property bool active: false
    property int _activeClients: 0
    property bool isAwake: false

    function toggle() {
        active = !active;
        Quickshell.execDetached(["qs", "-c", Paths.notificationCenterConfig, "ipc", "call", "notification-center", "toggleDnd"]);
    }

    property Timer sleepTimer: Timer {
        interval: ServiceConfig.dndSleepMs
        onTriggered: root.isAwake = false
    }

    property Process initCheck: Process {
        command: ["qs", "-c", Paths.notificationCenterConfig, "ipc", "call", "notification-center", "getDndState"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                root.active = (data.trim() === "true");
            }
        }
    }

    onIsAwakeChanged: {
        if (isAwake) {
            initCheck.running = true;
        }
    }

    function retain() {
        _activeClients++;
        sleepTimer.stop();
        isAwake = true;
    }

    function release() {
        _activeClients = Math.max(0, _activeClients - 1);
        if (_activeClients === 0)
            sleepTimer.restart();
    }
}
