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
        // Единый скрипт, возвращающий данные с явными префиксами для точного парсинга
        command: ["bash", "-c", `
            echo "CPU $(head -n1 /proc/stat)"
            echo "RAM $(free -m | awk '/Mem:/ {print $2, $3}')"
            echo "DSK $(df / --output=pcent | tail -n1 | tr -dc '0-9')"
            echo "TMP $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0)"
            if command -v nvidia-smi &>/dev/null; then
                echo "GPU $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0)"
            elif [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then
                echo "GPU $(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo 0)"
            else
                echo "GPU 0"
            fi
        `]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length === 0)
                    return;

                const prefix = parts[0];

                if (prefix === "CPU" && parts.length >= 6) {
                    const idle = Number(parts[5]) + Number(parts[6]); // idle + iowait
                    let total = 0;
                    for (let i = 2; i < parts.length; i++)
                        total += Number(parts[i]);

                    const diffIdle = idle - root._prevIdle;
                    const diffTotal = total - root._prevTotal;

                    if (diffTotal > 0)
                        root.cpu = (diffTotal - diffIdle) / diffTotal;

                    root._prevIdle = idle;
                    root._prevTotal = total;
                } else if (prefix === "RAM" && parts.length === 3) {
                    const total = parseFloat(parts[1]);
                    const used = parseFloat(parts[2]);
                    if (total > 0)
                        root.ram = used / total;
                } else if (prefix === "DSK" && parts.length === 2) {
                    root.disk = parseFloat(parts[1]) / 100.0;
                } else if (prefix === "TMP" && parts.length === 2) {
                    let t = parseFloat(parts[1]);
                    root.temp = t > 1000 ? t / 1000.0 : t; // Обработка sysfs (миллиградусы)
                } else if (prefix === "GPU" && parts.length === 2) {
                    root.gpu = parseFloat(parts[1]) / 100.0;
                }
            }
        }
    }

    readonly property Timer updateTimer: Timer {
        interval: 2000 // 2 секунды — оптимально для мониторинга ресурсов
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.statsProc.running = true
    }
}
