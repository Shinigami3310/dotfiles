pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool enabled: false
    property bool isToggling: false
    property string connectingMac: ""

    readonly property ListModel deviceModel: ListModel {}

    function log(msg) {
        console.log("[BT-Service] " + new Date().toLocaleTimeString() + " | " + msg);
    }
    function logError(msg) {
        console.error("[BT-Service ERR] " + new Date().toLocaleTimeString() + " | " + msg);
    }

    // 1. Включение / выключение демона и адаптера
    function toggle() {
        if (isToggling)
            return;
        isToggling = true;
        let target = !enabled;
        enabled = target;
        connectingMac = "";

        log("toggle() -> " + target);

        if (target) {
            toggleProc.command = ["bash", "-c", "systemctl start bluetooth.service && sleep 0.3 && bluetoothctl power on"];
        } else {
            deviceModel.clear();
            toggleProc.command = ["bash", "-c", "bluetoothctl power off 2>/dev/null; systemctl stop bluetooth.service"];
        }
        toggleProc.running = true;
    }

    readonly property Process toggleProc: Process {
        running: false
        stderr: SplitParser {
            splitMarker: "\n"
            onRead: data => root.logError("toggleProc: " + data)
        }
        onExited: exitCode => {
            root.isToggling = false;
            if (exitCode !== 0)
                root.logError("toggleProc завершился с кодом: " + exitCode);
            root.checkPowerProc.running = true;
        }
    }

    function connectToDevice(mac) {
        log("Подключение к: " + mac);
        connectingMac = mac;
        connectionTimeout.restart();
        Quickshell.execDetached(["bash", "-c", "bluetoothctl connect " + mac]);
    }

    readonly property Timer connectionTimeout: Timer {
        interval: 15000
        onTriggered: {
            root.connectingMac = "";
        }
    }

    // 2. Проверка активности службы и адаптера
    readonly property Process checkPowerProc: Process {
        command: ["bash", "-c", "systemctl is-active --quiet bluetooth.service && bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo 'ON' || echo 'OFF'"]
        running: false
        property string outputText: ""

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => checkPowerProc.outputText = data.trim()
        }

        onExited: () => {
            if (root.isToggling)
                return;
            let isPowered = (checkPowerProc.outputText === "ON");

            if (root.enabled !== isPowered) {
                root.enabled = isPowered;
                if (!isPowered)
                    root.deviceModel.clear();
            }
            if (isPowered && !root.scanProc.running) {
                root.scanProc.running = true;
            }
        }
    }

    // 3. Безопасное сканирование и парсинг (без мусорных логов)
    readonly property Process scanProc: Process {
        command: ["bash", "-c", "bluetoothctl --timeout 2 scan on >/dev/null 2>&1; " + "conn=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'); " + "bluetoothctl devices 2>/dev/null | grep '^Device ' | while read -r _ mac name; do " + "  [ -z \"$mac\" ] && continue; " + "  is_conn=$(echo \"$conn\" | grep -q \"^$mac$\" && echo 1 || echo 0); " + "  echo \"$is_conn|$mac|$name\"; " + "done"]
        running: false
        property var rawLines: []

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let line = data.trim();
                if (line.length > 0)
                    scanProc.rawLines.push(line);
            }
        }

        onExited: () => {
            let lines = scanProc.rawLines;
            scanProc.rawLines = [];

            if (root.isToggling || !root.enabled)
                return;
            let newDevices = [];
            for (let i = 0; i < lines.length; i++) {
                let parts = lines[i].split("|");
                if (parts.length >= 3) {
                    let isConn = (parts[0] === "1");
                    let mac = parts[1];
                    let name = parts.slice(2).join("|");

                    if (mac === root.connectingMac && isConn) {
                        root.connectingMac = "";
                        root.connectionTimeout.stop();
                    }
                    newDevices.push({
                        connected: isConn,
                        mac: mac,
                        name: name
                    });
                }
            }

            // Сортировка: подключенные устройства СТРОГО НАВЕРХ
            newDevices.sort((a, b) => (b.connected ? 1 : 0) - (a.connected ? 1 : 0));

            // Безопасное обновление ListModel без вылетов за пределы индексов
            for (let i = root.deviceModel.count - 1; i >= 0; i--) {
                let mac = root.deviceModel.get(i).mac;
                if (!newDevices.some(d => d.mac === mac))
                    root.deviceModel.remove(i);
            }

            for (let i = 0; i < newDevices.length; i++) {
                let dev = newDevices[i];
                let existingIdx = -1;
                for (let k = 0; k < root.deviceModel.count; k++) {
                    if (root.deviceModel.get(k).mac === dev.mac) {
                        existingIdx = k;
                        break;
                    }
                }

                if (existingIdx !== -1) {
                    root.deviceModel.setProperty(existingIdx, "connected", dev.connected);
                    root.deviceModel.setProperty(existingIdx, "name", dev.name);
                    if (existingIdx !== i)
                        root.deviceModel.move(existingIdx, i, 1);
                } else {
                    root.deviceModel.insert(Math.min(i, root.deviceModel.count), dev);
                }
            }
        }
    }

    // 4. Периодический таймер синхронизации
    readonly property Timer syncTimer: Timer {
        interval: 6000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!root.isToggling && !root.checkPowerProc.running && !root.scanProc.running && !root.toggleProc.running) {
                root.checkPowerProc.running = true;
            }
        }
    }
}
