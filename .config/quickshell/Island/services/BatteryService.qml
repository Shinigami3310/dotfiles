import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int percent: 0
    property bool isCharging: false
    property string activeProfile: "balanced"

    function setProfile(profileName) {
        if (activeProfile !== profileName) {
            activeProfile = profileName;
            Quickshell.execDetached(["powerprofilesctl", "set", profileName]);
        }
    }

    property Process batteryMonitor: Process {
        command: ["sh", "-c", `
            while true; do
                BAT=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
                if [ -n "$BAT" ]; then
                    echo "$(cat $BAT/capacity 2>/dev/null || echo 100):$(cat $BAT/status 2>/dev/null || echo Discharging)"
                else
                    echo "100:Full"
                fi
                sleep 3
            done
        `]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(":");
                if (parts.length === 2) {
                    const cap = parseInt(parts[0], 10);
                    if (!isNaN(cap)) {
                        root.percent = Math.min(100, Math.max(0, cap));
                    }
                    const status = parts[1].toLowerCase();
                    root.isCharging = ["charging", "full", "not charging"].includes(status);
                }
            }
        }
    }

    property Process profileMonitor: Process {
        command: ["sh", "-c", "while true; do powerprofilesctl get 2>/dev/null || echo balanced; sleep 3; done"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim();
                if (trimmed) {
                    root.activeProfile = trimmed;
                }
            }
        }
    }
}
