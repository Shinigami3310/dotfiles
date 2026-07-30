pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real level: 0.8
    property bool suppressSurfaceRequest: false
    property bool initialized: false

    signal surfaceRequested(string newName)

    function setLevel(val) {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
        let percent = Math.round(Math.max(0.0, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["brightnessctl", "-e4", "-n2", "set", percent + "%"]);
        level = val;
    }

    function sync() {
        brightProc.running = true;
    }

    function openPanel() {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
        sync();
        surfaceRequested("brightness");
    }

    function parseLevel(data) {
        let parts = data.trim().split(",");
        for (let i = 0; i < parts.length; i++) {
            if (parts[i].includes("%"))
                return Math.max(0.0, Math.min(1.0, parseFloat(parts[i]) / 100.0));
        }
        if (parts.length >= 5) {
            let current = parseFloat(parts[2]);
            let max = parseFloat(parts[4]);
            if (max > 0)
                return Math.max(0.0, Math.min(1.0, current / max));
        }
        return null;
    }

    readonly property Timer suppressTimer: Timer {
        interval: 700
        repeat: false
        onTriggered: root.suppressSurfaceRequest = false
    }

    readonly property Process brightProc: Process {
        command: ["brightnessctl", "-e4", "-n2", "-m"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let newLevel = root.parseLevel(data);
                if (newLevel === null)
                    return;
                let levelChanged = Math.abs(newLevel - root.level) > 0.005;
                root.level = newLevel;
                if (!root.initialized) {
                    root.initialized = true;
                    return;
                }
                if (!root.suppressSurfaceRequest && levelChanged)
                    root.surfaceRequested("brightness");
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
