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
        requestInteraction();
        const percent = Math.round(Math.max(0.0, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["brightnessctl", "-e4", "-n2", "set", `${percent}%`]);
        level = val;
    }

    function openPanel() {
        requestInteraction();
        brightProc.running = true;
        surfaceRequested("brightness");
    }

    function requestInteraction() {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
    }

    readonly property Timer suppressTimer: Timer {
        interval: 700
        onTriggered: root.suppressSurfaceRequest = false
    }

    readonly property Process brightProc: Process {
        command: ["brightnessctl", "-e4", "-n2", "-m"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",");
                if (parts.length < 4)
                    return;

                const newLevel = parseFloat(parts[3]) / 100.0;

                if (isNaN(newLevel))
                    return;

                const changed = Math.abs(newLevel - root.level) > 0.005;
                root.level = newLevel;

                if (!root.initialized) {
                    root.initialized = true;
                } else if (changed && !root.suppressSurfaceRequest) {
                    root.surfaceRequested("brightness");
                }
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 100
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.brightProc.running = true
    }
}
