pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../core"

QtObject {
    id: root

    signal surfaceRequested(string componentName)

    property real volume: 0.5
    property bool muted: false
    property bool firstRun: true

    property bool _isInternalChange: false

    Component.onCompleted: volProc.running = true

    function toggleMute() {
        _isInternalChange = true;
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        resetInternalFlagTimer.restart();
    }

    function setVolume(val: real) {
        _isInternalChange = true;

        const safeVal = Math.max(0.0, Math.min(1.0, val));
        const percent = Math.round(safeVal * 100);

        Quickshell.execDetached(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", `${percent}%`]);

        if (muted && safeVal > 0) {
            Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "0"]);
        }

        resetInternalFlagTimer.restart();
    }

    // Защита от эхо: после set-операции (toggleMute/setVolume) игнорируем
    // собственные события от pactl в течение этого окна.
    property Timer resetInternalFlagTimer: Timer {
        interval: ServiceConfig.audioResetFlagMs
        onTriggered: root._isInternalChange = false
    }

    // Дебаунс событий pactl: pactl subscribe может прислать пачку событий,
    // группируем их и читаем состояние не чаще, чем раз в 30 мс.
    property Timer debounceTimer: Timer {
        interval: ServiceConfig.audioDebounceMs
        onTriggered: volProc.running ? restart() : (volProc.running = true)
    }

    property Process eventListener: Process {
        command: ["pactl", "subscribe"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data.includes("sink")) {
                    debounceTimer.restart();
                }
            }
        }
    }

    property Process volProc: Process {
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length < 2)
                    return;

                const newVol = parseFloat(parts[1]);
                const newMuted = data.includes("[MUTED]");

                if (!isNaN(newVol) && (newVol !== root.volume || newMuted !== root.muted)) {
                    root.volume = Math.min(newVol, 1.0);
                    root.muted = newMuted;

                    if (!root._isInternalChange && !root.firstRun) {
                        root.surfaceRequested(SurfaceNames.volumeSlider);
                    }
                    root.firstRun = false;
                }
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0) {
                console.warn(`[AudioService] wpctl get-volume завершился с кодом ${exitCode}`);
            }
        }
    }
}
