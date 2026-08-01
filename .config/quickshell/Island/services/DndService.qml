import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false

    function toggle() {
        Quickshell.execDetached(["qs", "-c", "NotificationCenter", "ipc", "call", "notification-center", "toggleDnd"]);
        Qt.callLater(() => getActive());
    }

    function getActive() {
        if (!checkProc.running) {
            checkProc.running = true;
        }
    }

    readonly property Process checkProc: Process {
        command: ["qs", "-c", "NotificationCenter", "ipc", "call", "notification-center", "getDndState"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const text = data.trim().toLowerCase();
                if (text === "true")
                    root.active = true;
                else if (text === "false")
                    root.active = false;
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 300
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.getActive()
    }
}
