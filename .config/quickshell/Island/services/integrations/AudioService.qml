pragma Singleton
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
        suppressSurfaceRequest = true;
        suppressTimer.restart();
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        syncTimer.triggered();
    }

    function setVolume(val) {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
        let percent = Math.round(Math.max(0.0, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", percent + "%"]);
        volume = val;
    }

    function sync() {
        volProc.running = true;
    }

    function openPanel() {
        suppressSurfaceRequest = true;
        suppressTimer.restart();
        sync();
        surfaceRequested("volume");
    }

    readonly property Timer suppressTimer: Timer {
        interval: 700
        repeat: false
        onTriggered: root.suppressSurfaceRequest = false
    }

    // Периодическое считывание громкости через wpctl
    readonly property Process volProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    let newVolume = parseFloat(parts[1]);
                    let newMuted = data.includes("[MUTED]");
                    let volumeChanged = Math.abs(newVolume - root.volume) > 0.005;
                    let mutedChanged = newMuted !== root.muted;
                    root.volume = newVolume;
                    root.muted = newMuted;
                    if (!root.initialized) {
                        root.initialized = true;
                        return;
                    }
                    if (!root.suppressSurfaceRequest && (volumeChanged || mutedChanged))
                        root.surfaceRequested("volume");
                }
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.volProc.running = true
    }
}
