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

    property string tempPath: ""
    property int _prevTotal: 0
    property int _prevIdle: 0

    // Единократная инициализация тяжёлых метрик (Disk, GPU, поиск сенсора температуры).
    // По завершении запускает statsTimer.
    property Process initProc: Process {
        command: ["bash", "-c", `
            disk=$(df / --output=pcent 2>/dev/null | tail -n1 | tr -dc '0-9')
            [ -z "$disk" ] && disk=0

            gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0)

            temp_path=""
            for f in /sys/class/thermal/thermal_zone*/temp; do
                if [ -f "$f" ]; then
                    zone=\${f%/temp}
                    read -r t < "$zone/type" 2>/dev/null
                    if echo "$t" | grep -qi "cpu\|x86_pkg"; then
                        temp_path="$f"; break
                    fi
                fi
            done
            [ -z "$temp_path" ] && [ -f /sys/class/thermal/thermal_zone0/temp ] && temp_path=/sys/class/thermal/thermal_zone0/temp

            echo "$disk|$gpu|$temp_path"
        `]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split("|");
                if (parts.length >= 3) {
                    const dsk = parseInt(parts[0], 10);
                    const gp = parseInt(parts[1], 10);
                    const tPath = parts[2];

                    if (!isNaN(dsk))
                        root.disk = dsk / 100.0;
                    if (!isNaN(gp))
                        root.gpu = gp / 100.0;
                    if (tPath)
                        root.tempPath = tPath;
                }
                root.statsTimer.start();
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn(`[SystemStats] init-процесс завершился с кодом ${exitCode}`);
            // Гарантируем запуск периодического опроса даже если init не дал вывода
            root.statsTimer.start();
        }
    }

    // Чтение CPU из /proc/stat. QML хранит предыдущие значения для расчёта дельты.
    // Выводим: <общее время> <idle время> (все поля /proc/stat).
    property Process cpuProc: Process {
        command: ["bash", "-c", "read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat; echo \"$((user+nice+system+idle+iowait+irq+softirq+steal)) $((idle+iowait))\""]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length >= 2) {
                    const total = parseInt(parts[0], 10);
                    const idle = parseInt(parts[1], 10);
                    if (!isNaN(total) && !isNaN(idle) && root._prevTotal > 0) {
                        const dTot = total - root._prevTotal;
                        const dIdle = idle - root._prevIdle;
                        if (dTot > 0) {
                            const cpu = (dTot - dIdle) / dTot;
                            root.cpu = Math.max(0.0, Math.min(1.0, cpu));
                        }
                    }
                    root._prevTotal = total;
                    root._prevIdle = idle;
                }
            }
        }
    }

    // Чтение RAM (MemTotal и MemAvailable) из /proc/meminfo.
    property Process ramProc: Process {
        command: ["bash", "-c", "awk '/MemTotal:/ {t=$2} /MemAvailable:/ {a=$2} END {print t, a}' /proc/meminfo"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length >= 2) {
                    const mTot = parseInt(parts[0], 10);
                    const mAv = parseInt(parts[1], 10);
                    if (!isNaN(mTot) && mTot > 0 && !isNaN(mAv)) {
                        root.ram = Math.max(0.0, Math.min(1.0, (mTot - mAv) / mTot));
                    }
                }
            }
        }
    }

    // Чтение температуры из сохранённого пути сенсора.
    // Команда устанавливается динамически в statsTimer.onTriggered.
    property Process tempProc: Process {
        command: []
        stdout: SplitParser {
            onRead: data => {
                const tmp = parseInt(data.trim(), 10);
                if (!isNaN(tmp))
                    root.temp = tmp / 1000.0;
            }
        }
    }

    // Периодический опрос метрик (кроме disk/gpu — они считаются разово в initProc).
    property Timer statsTimer: Timer {
        interval: 2000
        repeat: true
        running: false
        onTriggered: {
            if (!cpuProc.running)
                cpuProc.running = true;
            if (!ramProc.running)
                ramProc.running = true;
            if (root.tempPath && !tempProc.running) {
                tempProc.command = ["cat", root.tempPath];
                tempProc.running = true;
            }
        }
    }

    Component.onCompleted: initProc.running = true
}