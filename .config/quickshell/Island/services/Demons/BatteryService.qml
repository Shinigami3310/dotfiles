pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    // Динамические свойства состояния батареи
    property int percent: 100
    property bool isCharging: false
    property string statusText: "Загрузка..."

    // Текущий активный профиль питания ("power-saver", "balanced", "performance")
    property string activeProfile: "balanced"

    // Переключение профиля питания
    function setProfile(profileName) {
        if (activeProfile !== profileName) {
            activeProfile = profileName;
            Quickshell.execDetached(["powerprofilesctl", "set", profileName]);
        }
    }

    // Фоновый процесс считывания состояния батареи из sysfs
    property Process batteryMonitor: Process {
        command: ["sh", "-c", "while true; do " + "  BAT=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1); " + "  if [ -n \"$BAT\" ]; then " + "    CAP=$(cat \"$BAT/capacity\" 2>/dev/null || echo 100); " + "    STAT=$(cat \"$BAT/status\" 2>/dev/null || echo Discharging); " + "    echo \"$CAP:$STAT\"; " + "  else " + "    echo \"100:Full\"; " + "  fi; " + "  sleep 3; " + "done"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(":");
                if (parts.length === 2) {
                    var p = parseInt(parts[0]);
                    if (!isNaN(p))
                        root.percent = Math.min(100, Math.max(0, p));

                    var st = parts[1].trim().toLowerCase();
                    if (st === "charging") {
                        root.isCharging = true;
                        root.statusText = "Заряжается";
                    } else if (st === "full" || st === "not charging") {
                        root.isCharging = true;
                        root.statusText = "Питание от сети";
                    } else {
                        root.isCharging = false;
                        root.statusText = "От батареи";
                    }
                }
            }
        }
    }

    // Фоновый процесс синхронизации с powerprofilesctl
    property Process profileMonitor: Process {
        command: ["sh", "-c", "while true; do " + "  powerprofilesctl get 2>/dev/null || echo balanced; " + "  sleep 3; " + "done"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                if (trimmed !== "") {
                    root.activeProfile = trimmed;
                }
            }
        }
    }
}
