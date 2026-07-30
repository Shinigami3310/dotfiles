pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real cpu: 0.0
    property real ram: 0.0
    property real gpu: 0.0
    property real disk: 0.0
    property real temp: 0.0

    property real _prevIdle: 0
    property real _prevTotal: 0

    readonly property Process statsProc: Process {
        // Универсальный Bash-скрипт с фолбэками для Arch Linux
        command: ["bash", "-c", "cat /proc/stat | grep 'cpu '; " + "free -m | grep Mem; " + "df / --output=pcent | tail -n 1; " +
            // 1. Температура CPU через sysfs
            "if [ -f /sys/class/thermal/thermal_zone0/temp ]; then cat /sys/class/thermal/thermal_zone0/temp; else echo 0; fi; " +
            // 2. Загрузка GPU (Nvidia / AMD sysfs / Intel)
            "if command -v nvidia-smi &>/dev/null; then nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0; " + "elif [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then cat /sys/class/drm/card0/device/gpu_busy_percent; " + "else echo 0; fi"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let line = data.trim();
                if (!line)
                    return;
                if (line.startsWith("cpu ")) {
                    // CPU usage
                    let p = line.split(/\s+/).slice(1).map(Number);
                    let idle = p[3] + p[4];
                    let total = p.reduce((a, b) => a + b, 0);
                    let diffIdle = idle - root._prevIdle;
                    let diffTotal = total - root._prevTotal;
                    if (diffTotal > 0)
                        root.cpu = (diffTotal - diffIdle) / diffTotal;
                    root._prevIdle = idle;
                    root._prevTotal = total;
                } else if (line.startsWith("Mem:")) {
                    // RAM usage
                    let p = line.split(/\s+/);
                    let total = parseFloat(p[1]);
                    let used = parseFloat(p[2]);
                    if (total > 0)
                        root.ram = used / total;
                } else if (line.endsWith("%")) {
                    // DISK usage
                    root.disk = parseFloat(line.replace("%", "").trim()) / 100.0;
                } else {
                    // Числовые значения (Temp или GPU)
                    let num = parseFloat(line);
                    if (!isNaN(num)) {
                        if (num > 1000) {
                            // Температура из sysfs отдается в миллиградусах (например, 45000 = 45°C)
                            root.temp = num / 1000.0;
                        } else if (num <= 100 && root.temp > 0) {
                            // Если температура уже получена, следующее число — загрузка GPU (0-100%)
                            root.gpu = num / 100.0;
                        } else if (root.temp === 0) {
                            // Фолбэк, если температура измеряется в обычных градусах
                            root.temp = num;
                        }
                    }
                }
            }
        }
    }

    readonly property Timer updateTimer: Timer {
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.statsProc.running = true
    }
}
