pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real volume: 0.5
    property bool muted: false

    function toggleMute() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        syncTimer.triggered();
    }

    function setVolume(val) {
        let percent = Math.round(Math.max(0.0, Math.min(1.0, val)) * 100);
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", percent + "%"]);
        volume = val;
    }

    // Периодическое считывание громкости через wpctl
    readonly property Process volProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    root.volume = parseFloat(parts[1]);
                    root.muted = data.includes("[MUTED]");
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
