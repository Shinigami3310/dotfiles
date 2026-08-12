pragma Singleton
import QtQuick
import "helpers"
import "Bluetooth"

// Оркестратор Bluetooth: состояние (вкл/выкл, подключение, активность),
// модель устройств и связка сканера/процессов.
// Сырые процессы вынесены в BluetoothScanner (скан) и BluetoothProcesses
// (power/connect), чтобы сервис оставался тонким и читаемым.
QtObject {
    id: root

    property bool enabled: false
    property string connectingMac: ""
    property int _activeClients: 0
    property bool isAwake: false
    readonly property ListModel deviceModel: ListModel {}

    property bool _isToggling: false

    property Timer sleepTimer: Timer {
        interval: ServiceConfig.bluetoothSleepMs
        onTriggered: root.isAwake = false
    }

    property Timer stateCheckTimer: Timer {
        interval: ServiceConfig.bluetoothStateCheckMs
        repeat: true
        onTriggered: processes.checkStateProc.running = true
    }

    property ListModelDiff listModelDiff: ListModelDiff {}

    // Сканер (непрерывный bluetoothctl scan on + bt_scan.sh)
    readonly property BluetoothScanner scanner: BluetoothScanner {
        isAwake: root.isAwake
        isEnabled: root.enabled
        isToggling: root._isToggling
        throttleMs: ServiceConfig.bluetoothThrottleMs
        retryMs: ServiceConfig.bluetoothRetryMs
        onScanData: lines => root.updateModel(lines)
    }

    // Процессы управления (power, state, connect)
    readonly property BluetoothProcesses processes: BluetoothProcesses {
        isToggling: root._isToggling
        onStateChanged: newState => {
            if (root.enabled !== newState) {
                root.enabled = newState;
            }
        }
        onToggleComplete: (enabled) => {
            root._isToggling = false;
            if (enabled && root.isAwake) {
                scanner.startScan();
            }
            processes.checkStateProc.running = true;
        }
        onConnectComplete: () => {
            root.connectingMac = "";
            scanner.startScan();
        }
    }

    onIsAwakeChanged: {
        if (isAwake) {
            processes.checkStateProc.running = true;
            stateCheckTimer.start();
            if (enabled && !_isToggling)
                scanner.startScan();
        } else {
            stateCheckTimer.stop();
            scanner.stopScan();
        }
    }

    onEnabledChanged: {
        if (enabled && isAwake && !_isToggling) {
            scanner.startScan();
        } else if (!enabled) {
            scanner.stopScan();
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
        processes.toggle(enabled);
    }

    function connectToDevice(mac: string) {
        if (connectingMac !== "")
            return;
        connectingMac = mac;
        processes.connectToDevice(mac);
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