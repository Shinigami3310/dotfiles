pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real level: 0.8

    function setLevel(val) {
        let percent = Math.round(Math.max(0.01, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["brightnessctl", "set", percent + "%"]);
        level = val;
    }

    readonly property Process brightProc: Process {
        command: ["brightnessctl", "-m"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(",");
                if (parts.length >= 4) {
                    let current = parseFloat(parts[2]);
                    let max = parseFloat(parts[4]);
                    if (max > 0)
                        root.level = current / max;
                }
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.brightProc.running = true
    }
}
