pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"
import "helpers"

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
        // Сканер вынесен в services/scripts/bt_scan.sh
        command: ["bash", Paths.scriptsDir + "bt_scan.sh"]
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