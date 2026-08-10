pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int percent: 0
    property bool isCharging: false
    property string activeProfile: "balanced"
    property bool hasBattery: false

    property int _activeClients: 0
    property bool isAwake: false

    function setProfile(profileName: string) {
        if (activeProfile !== profileName) {
            activeProfile = profileName;
            Quickshell.execDetached(["powerprofilesctl", "set", profileName]);
        }
    }

    // Мониторинг udev и poll-опрос — это постоянные процессы. Держим их
    // активными только пока открыта поверхность BatteryProfile, иначе
    // батарея опрашивается в фоне даже когда UI не виден.
    function retain() {
        _activeClients++;
        isAwake = true;
    }

    function release() {
        _activeClients = Math.max(0, _activeClients - 1);
        if (_activeClients === 0) {
            isAwake = false;
        }
    }

    property Process eventListener: Process {
        command: ["udevadm", "monitor", "-s", "power_supply"]
        running: false
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
        interval: ServiceConfig.batteryPollMs
        repeat: true
        running: false
        onTriggered: {
            if (!batProc.running)
                batProc.running = true;
        }
    }

    property Process batProc: Process {
        command: ["sh", "-c", "b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1); [ -n \"$b\" ] && echo \"$(cat $b/capacity 2>/dev/null):$(cat $b/status 2>/dev/null)\" || echo ':None'"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(":");
                if (parts.length === 2) {
                    if (parts[1] === "None") {
                        root.hasBattery = false;
                        return;
                    }
                    root.hasBattery = true;
                    root.percent = parseInt(parts[0], 10) || 0;
                    root.isCharging = ["Charging", "Full", "Not charging"].includes(parts[1]);
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0) {
                console.warn(`[BatteryService] чтение батареи завершилось с кодом ${exitCode}`);
            }
        }
    }

    property Process profileProc: Process {
        command: ["powerprofilesctl", "get"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed)
                    root.activeProfile = trimmed;
            }
        }
    }

    onIsAwakeChanged: {
        // При каждом пробуждении перечитываем состояние с нуля — счётчик
        // батареи мог измениться, пока сервис спал.
        if (isAwake) {
            eventListener.running = true;
            pollTimer.start();
            if (!batProc.running)
                batProc.running = true;
            if (!profileProc.running)
                profileProc.running = true;
        } else {
            eventListener.running = false;
            pollTimer.stop();
            if (batProc.running)
                batProc.running = false;
        }
    }
}
