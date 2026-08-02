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

    readonly property Process statsProc: Process {
        command: ["bash", "-c", `
            # 1. Единократная инициализация тяжелых метрик (Disk, GPU)
            disk=$(df / --output=pcent 2>/dev/null | tail -n1 | tr -dc '0-9')
            if [ -z "$disk" ]; then disk=0; fi

            gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0)

            # 2. Динамический поиск сенсора температуры
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


            # Главный событийный цикл
            while true; do
                sleep 2

                # CPU
                read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat
                total=$((user + nice + system + idle + iowait + irq + softirq + steal))
                curr_idle=$((idle + iowait))
                d_tot=$((total - prev_total))
                d_id=$((curr_idle - prev_idle))
                prev_total=$total; prev_idle=$curr_idle

                # RAM
                while read -r key val _; do
                    if [ "$key" = "MemTotal:" ]; then memtotal=$val; fi
                    if [ "$key" = "MemAvailable:" ]; then memavail=$val; break; fi
                done < /proc/meminfo

                # Temp
                    read -r tmp < "$temp_path" 2>/dev/null || tmp=0

                # Отправляем сырые данные в stdout
                echo "$d_tot $d_id $memtotal $memavail $disk $tmp $gpu"
            done
        `]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length < 7)
                    return;

                const d_tot = parseInt(parts[0], 10);
                const d_id = parseInt(parts[1], 10);
                const m_tot = parseInt(parts[2], 10);
                const m_av = parseInt(parts[3], 10);
                const dsk = parseInt(parts[4], 10);
                const tmp = parseInt(parts[5], 10);
                const gp = parseInt(parts[6], 10);

                if (d_tot > 0)
                    root.cpu = (d_tot - d_id) / d_tot;
                if (m_tot > 0)
                    root.ram = (m_tot - m_av) / m_tot;

                root.disk = dsk / 100.0;
                root.temp = tmp / 1000.0;
                root.gpu = gp / 100.0;
            }
        }
    }
}
