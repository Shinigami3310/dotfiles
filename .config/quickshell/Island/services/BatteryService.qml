import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int percent: 0
    property bool isCharging: false
    property string activeProfile: "balanced"

    function setProfile(profileName: string) {
        if (activeProfile !== profileName) {
            activeProfile = profileName;
            Quickshell.execDetached(["powerprofilesctl", "set", profileName]);
        }
    }

    property Process eventListener: Process {
        command: ["udevadm", "monitor", "-s", "power_supply"]
        running: true
        stdout: SplitParser {
            onRead: _ => {
                if (!batProc.running)
                    batProc.running = true;
            }
        }
    }

    // Fallback: периодический опрос состояния батареи.
    // udevadm monitor не всегда доставляет события при подключении зарядки,
    // поэтому гарантируем обновление isCharging/percent даже без событий.
    property Timer pollTimer: Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: {
            if (!batProc.running)
                batProc.running = true;
        }
    }

    property Process batProc: Process {
        command: ["sh", "-c", "b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1); [ -n \"$b\" ] && echo \"$(cat $b/capacity 2>/dev/null):$(cat $b/status 2>/dev/null)\" || echo '100:Full'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(":");
                if (parts.length === 2) {
                    root.percent = parseInt(parts[0], 10) || 100;
                    root.isCharging = ["Charging", "Full"].includes(parts[1]);
                }
            }
        }
    }

    property Process profileProc: Process {
        command: ["powerprofilesctl", "get"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed)
                    root.activeProfile = trimmed;
            }
        }
    }
}
