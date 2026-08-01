import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real volume: 0.5
    property bool muted: false
    property bool suppressSurfaceRequest: false
    property bool initialized: false

    signal surfaceRequested(string newName)

    function toggleMute() {
        requestInteraction();
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        volProc.running = true;
    }

    function setVolume(val) {
        requestInteraction();
        const percent = Math.round(Math.max(0.0, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", `${percent}%`]);
        volume = val;
    }

    function openPanel() {
        requestInteraction();
        volProc.running = true;
        surfaceRequested("volume");
    }

    function requestInteraction() {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
    }

    readonly property Timer suppressTimer: Timer {
        interval: 700
        onTriggered: root.suppressSurfaceRequest = false
    }

    readonly property Process volProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length < 2)
                    return;

                const newVolume = parseFloat(parts[1]);
                const newMuted = data.includes("[MUTED]");

                const changed = Math.abs(newVolume - root.volume) > 0.005 || newMuted !== root.muted;

                root.volume = newVolume;
                root.muted = newMuted;

                if (!root.initialized) {
                    root.initialized = true;
                } else if (changed && !root.suppressSurfaceRequest) {
                    root.surfaceRequested("volume");
                }
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 100
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.volProc.running = true
    }
}
