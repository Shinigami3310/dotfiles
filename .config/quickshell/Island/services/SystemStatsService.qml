pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Синглтон мониторинга ресурсов. Периодический опрос (CPU/RAM/Temp) идёт
// ТОЛЬКО пока поверхность ControlPanel «держится» за сервис через retain().
// При выгрузке поверхности (release, счётчик клиентов = 0) все процессы и таймер
// останавливаются, чтобы не тратить ресурсы в простое.
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
    property int _activeClients: 0
    property bool isAwake: false
    property bool _initialized: false

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

    function _stopProcesses() {
        for (let i = 0; i < _procs.length; i++) {
            const proc = _procs[i];
            // _procs объявлен раньше процессов в тексте файла — если QML ещё
            // не связал ссылки, элемент может быть null. Защищаемся.
            if (proc && proc.running)
                proc.running = false;
        }
    }

    readonly property list<Process> _procs: [initProc, cpuProc, ramProc, tempProc]

    onIsAwakeChanged: {
        if (isAwake) {
            if (_initialized) {
                statsTimer.start();
            } else if (!initProc.running) {
                // Разовый сбор тяжёлых метрик (Disk, GPU, путь сенсора)
                initProc.running = true;
            }
        } else {
            statsTimer.stop();
            _stopProcesses();
        }
    }

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
        running: false
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
                root._initialized = true;
                root.statsTimer.start();
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn(`[SystemStats] init-процесс завершился с кодом ${exitCode}`);
            // Гарантируем запуск периодического опроса даже если init не дал вывода
            root._initialized = true;
            root.statsTimer.start();
        }
    }

    // /proc/stat даёт накопленные счётчики, а не мгновенную загрузку.
    // Считаем дельту между опросами, иначе CPU всегда будет ~100% на старте.
    property Process cpuProc: Process {
        command: ["bash", "-c", "read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat; echo \"$((user+nice+system+idle+iowait+irq+softirq+steal)) $((idle+iowait))\""]
        running: false
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

    // MemAvailable учитывает кэш/буферы, которые ядро может освободить —
    // это точнее, чем просто MemFree, для оценки реально занятой памяти.
    property Process ramProc: Process {
        command: ["bash", "-c", "awk '/MemTotal:/ {t=$2} /MemAvailable:/ {a=$2} END {print t, a}' /proc/meminfo"]
        running: false
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

    // Путь сенсора определяется разово в initProc (он может отличаться
    // между машинами), поэтому команда подставляется динамически.
    property Process tempProc: Process {
        command: []
        running: false
        stdout: SplitParser {
            onRead: data => {
                const tmp = parseInt(data.trim(), 10);
                if (!isNaN(tmp))
                    root.temp = tmp / 1000.0;
            }
        }
    }

    // Disk/GPU считаются разово (они редко меняются), а CPU/RAM/Temp
    // опрашиваем периодически — это баланс между свежестью и нагрузкой.
    property Timer statsTimer: Timer {
        interval: ServiceConfig.statsPollMs
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
}