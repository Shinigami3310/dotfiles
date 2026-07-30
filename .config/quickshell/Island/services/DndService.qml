pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false

    function toggle() {
        Quickshell.execDetached(["qs", "-c", "NotificationCenter", "ipc", "call", "notification-center", "toggleDnd"]);
        syncTimer.triggered();
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
            splitMarker: "\n"
            onRead: data => {
                let line = data.trim().toLowerCase();
                if (line === "true") {
                    root.active = true;
                } else if (line === "false") {
                    root.active = false;
                }
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
