pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../shared/theme"
import "../theme"
import "helpers"

// Управление Bluetooth: состояние, сканирование, подключение.
// Монолитный сервис: все процессы (bluetoothctl) и таймеры живут здесь,
// чтобы UI был тонким, а логика не размазывалась по модулям.
QtObject {
    id: root

    property bool enabled: false
    property string connectingMac: ""
    property int _activeClients: 0
    property bool isAwake: false
    readonly property ListModel deviceModel: ListModel {}

    property ListModelDiff listModelDiff: ListModelDiff {}

    property bool _isToggling: false

    property Timer sleepTimer: Timer {
        interval: ServiceConfig.bluetoothSleepMs
        onTriggered: root.isAwake = false
    }

    property Timer updateThrottleTimer: Timer {
        interval: ServiceConfig.bluetoothThrottleMs
        onTriggered: {
            if (!scanProc.running) {
                scanParser._lines = [];
                scanProc.running = true;
            }
        }
    }

    property Timer stateCheckTimer: Timer {
        interval: ServiceConfig.bluetoothStateCheckMs
        repeat: true
        onTriggered: checkStateProc.running = true
    }

    property Timer retryScanTimer: Timer {
        interval: ServiceConfig.bluetoothRetryMs
        onTriggered: startScan()
    }

    // Периодический опрос bt_scan.sh, чтобы список устройств не «замирал»
    // (bluetoothctl scan on молчит на уже известных устройствах).
    property Timer scanRefreshTimer: Timer {
        interval: ServiceConfig.bluetoothThrottleMs
        repeat: true
        onTriggered: {
            if (scanProc.running)
                return;
            scanParser._lines = [];
            scanProc.running = true;
        }
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
        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn(`[BluetoothService] bluetoothctl show завершился с кодом ${exitCode}`);
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
        // Сканер вынесен в services/scripts/bt_scan.sh
        command: ["bash", Paths.scriptsDir + "bt_scan.sh"]
        stdout: SplitParser {
            id: scanParser
            property list<string> _lines: []
            onRead: data => {
                if (data.trim())
                    scanParser._lines.push(data.trim());
            }
        }
        onExited: exitCode => {
            if (exitCode === 0 && root.isAwake) {
                root.updateModel(scanParser._lines);
            } else if (exitCode !== 0) {
                console.warn(`[BluetoothService] bt_scan.sh завершился с кодом ${exitCode}`);
            }
            scanParser._lines = [];
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
        }
    }

    onIsAwakeChanged: {
        if (isAwake) {
            checkStateProc.running = true;
            stateCheckTimer.start();
            if (enabled && !_isToggling)
                startScan();
        } else {
            stateCheckTimer.stop();
            stopScan();
        }
    }

    onEnabledChanged: {
        if (enabled && isAwake && !_isToggling) {
            startScan();
        } else if (!enabled) {
            stopScan();
            deviceModel.clear();
        }
    }

    function retain() {
        _activeClients++;
        sleepTimer.stop();
        isAwake = true;
    }

    function release() {
        _activeClients = Math.max(0, _activeClients - 1);
        if (_activeClients === 0)
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
        scanRefreshTimer.start();
    }

    function stopScan() {
        retryScanTimer.stop();
        updateThrottleTimer.stop();
        scanRefreshTimer.stop();

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