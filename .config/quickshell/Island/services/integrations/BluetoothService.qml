pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../../core"

QtObject {
    id: root

    property bool enabled: false
    property string connectingMac: ""
    property int activeClients: 0
    property bool isAwake: false
    readonly property ListModel deviceModel: ListModel {}

    property ListModelDiff listModelDiff: ListModelDiff {}

    property bool _isToggling: false

    property Timer sleepTimer: Timer {
        interval: 1000
        onTriggered: root.isAwake = false
    }

    property Timer updateThrottleTimer: Timer {
        interval: 500
        onTriggered: {
            if (!scanProc.running) {
                scanParser.lines = [];
                scanProc.running = true;
            }
        }
    }

    property Timer stateCheckTimer: Timer {
        interval: 5000
        repeat: true
        onTriggered: checkStateProc.running = true
    }

    // Периодический опрос состояний устройств.
    // continuousScanProc даёт события только для новых/вновь найденных устройств,
    // поэтому для уже известных устройств (в т.ч. реально подключённых) нужно
    // принудительно перечитывать состояние, иначе connected будет устаревшим.
    property Timer stateScanTimer: Timer {
        interval: 3000
        repeat: true
        onTriggered: {
            if (root.isAwake && root.enabled && !root._isToggling && !root.connectingMac) {
                root.scan();
            }
        }
    }

    property Timer retryScanTimer: Timer {
        interval: 1000
        onTriggered: startScan()
    }

    property Process checkStateProc: Process {
        command: ["bash", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo 1 || echo 0"]
        stdout: SplitParser {
            onRead: data => {
                if (root._isToggling)
                    return;
                const newState = data.trim() === "1";
                if (root.enabled !== newState) {
                    root.enabled = newState;
                }
            }
        }
    }

    property Process continuousScanProc: Process {
        command: ["bluetoothctl", "scan", "on"]
        stdout: SplitParser {
            onRead: _ => {
                if (!updateThrottleTimer.running)
                    updateThrottleTimer.start();
            }
        }
        stderr: SplitParser {
            onRead: err => console.error(`[Bluetooth] Scan Error: ${err.trim()}`)
        }
        onExited: exitCode => {
            if (root.isAwake && root.enabled && !root._isToggling) {
                retryScanTimer.start();
            }
        }
    }

    property Process scanProc: Process {
        command: ["bash", "-c", `
            # Точное состояние connected определяется ТОЛЬКО через bluetoothctl info:
            #   - "Connected: yes" — физическое соединение установлено (надёжно);
            #   - НЕ требуем "ServicesResolved: yes" — на многих устройствах профили
            #     не резолвятся даже при рабочем соединении (ложно-отрицательный);
            #   - "bluetoothctl devices Connected" НЕ используется — BlueZ при
            #     авто-reconnect добавляет устройство в этот список даже если
            #     профильный коннект не удался (ложно-положительный).
            p=$(bluetoothctl devices Paired | awk '{print $2}')
            devs=$(bluetoothctl devices | awk '{print $2}')
            c=""
            for mac in $devs; do
                info=$(bluetoothctl info "$mac" | sed 's/\x1b\\[[0-9;]*m//g')
                if echo "$info" | grep -q "Connected: yes"; then
                    c="$c $mac"
                fi
            done
            bluetoothctl devices | awk -v c_list="$c" -v p_list="$p" '
            BEGIN {
                split(c_list, c_arr, " ");
                for (i in c_arr) if (c_arr[i] != "") connected_map[c_arr[i]] = 1;
                split(p_list, p_arr, " ");
                for (i in p_arr) if (p_arr[i] != "") paired_map[p_arr[i]] = 1;
            }
            NF>1 {
                mac = $2;
                $1 = ""; $2 = "";
                sub(/^[ \\t]+/, "");
                name = $0;
                is_c = (mac in connected_map) ? "true" : "false";
                is_p = (mac in paired_map) ? "true" : "false";
                print mac "|" is_c "|" is_p "|" name
            }'
        `]
        stdout: SplitParser {
            id: scanParser
            property var lines: []
            onRead: data => {
                if (data.trim())
                    scanParser.lines.push(data.trim());
            }
        }
        onExited: exitCode => {
            if (exitCode === 0 && root.isAwake) {
                root.updateModel(scanParser.lines);
            }
            scanParser.lines = [];
        }
    }

    property Process toggleProc: Process {
        property string targetState: "on"
        command: ["bluetoothctl", "power", targetState]
        onExited: () => {
            root._isToggling = false;
            if (targetState === "on" && root.isAwake) {
                startScan();
            }
            checkStateProc.running = true;
        }
    }

    property Process connectProc: Process {
        stderr: SplitParser {
            onRead: err => console.error(`[Bluetooth] Connect Error: ${err.trim()}`)
        }
        onExited: () => {
            root.connectingMac = "";
            startScan();
            // Принудительный скан состояний сразу после попытки коннекта,
            // чтобы connected-пометка обновилась немедленно (без ожидания событий).
            stateScanTimer.restart();
            if (!scanProc.running) {
                scanParser.lines = [];
                scanProc.running = true;
            }
        }
    }

    onIsAwakeChanged: {
        if (isAwake) {
            checkStateProc.running = true;
            stateCheckTimer.start();
            stateScanTimer.start();
            if (enabled && !_isToggling)
                startScan();
        } else {
            stateCheckTimer.stop();
            stateScanTimer.stop();
            stopScan();
        }
    }

    onEnabledChanged: {
        if (enabled) {
            // При включении BT сразу же проверяем состояние известных устройств —
            // они могли быть уже подключены (авто-reconnect), а событий сканирования
            // для них не будет.
            updateThrottleTimer.restart();
            if (isAwake && !_isToggling) {
                startScan();
            }
        } else {
            stopScan();
            deviceModel.clear();
        }
    }

    function retain() {
        activeClients++;
        sleepTimer.stop();
        isAwake = true;
    }

    function release() {
        activeClients = Math.max(0, activeClients - 1);
        if (activeClients === 0)
            sleepTimer.restart();
    }

    function toggle() {
        if (_isToggling)
            return;
        _isToggling = true;
        enabled = !enabled;
        toggleProc.targetState = enabled ? "on" : "off";
        toggleProc.running = false;
        toggleProc.running = true;
    }

    function connectToDevice(mac: string) {
        if (connectingMac !== "")
            return;
        connectingMac = mac;

        connectProc.command = ["bash", "-c", "bluetoothctl pair \"$1\"; sleep 0.5; bluetoothctl connect \"$1\"; bluetoothctl info \"$1\" | grep -q 'Connected: yes' && echo OK || echo FAIL", "--", mac];

        connectProc.running = false;
        connectProc.running = true;
    }

    function startScan() {
        if (!enabled || continuousScanProc.running)
            return;
        retryScanTimer.stop();
        continuousScanProc.running = false;
        continuousScanProc.running = true;
        updateThrottleTimer.start();
    }

    function stopScan() {
        retryScanTimer.stop();
        updateThrottleTimer.stop();

        if (continuousScanProc.running) {
            continuousScanProc.running = false;
            Quickshell.execDetached(["bluetoothctl", "scan", "off"]);
        }
    }

    function updateModel(lines: var) {
        const targets = lines.map(line => line.split('|')).filter(parts => parts.length >= 4).map(parts => ({
                    mac: parts[0],
                    connected: parts[1] === "true",
                    paired: parts[2] === "true",
                    name: parts.slice(3).join('|') || "Unknown Device"
                })).sort((a, b) => b.connected - a.connected || b.paired - a.paired || a.name.localeCompare(b.name));

        root.listModelDiff.sync(root.deviceModel, targets, "mac", ["connected", "paired", "name"]);
    }
}