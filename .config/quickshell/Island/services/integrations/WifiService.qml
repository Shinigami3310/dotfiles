pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../../core"

QtObject {
    id: root

    property bool enabled: false
    property string connectingBssid: ""
    readonly property ListModel networkModel: ListModel {}

    property int activeClients: 0
    property bool isAwake: false

    property ListModelDiff listModelDiff: ListModelDiff {}

    property bool _isScanning: false
    property bool _isToggling: false

    property Timer sleepTimer: Timer {
        interval: 1000
        onTriggered: root.isAwake = false
    }

    property Timer syncTimer: Timer {
        interval: 5000
        repeat: true
        onTriggered: {
            root.checkStateProc.running = true;
            if (root.enabled) {
                root.scan();
            }
        }
    }

    property Process checkStateProc: Process {
        command: ["nmcli", "-t", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                if (!root._isToggling) {
                    root.enabled = (data.trim() === "enabled");
                }
            }
        }
    }

    property Process scanProc: Process {
        command: ["nmcli", "-t", "-f", "SSID,BSSID,SECURITY,IN-USE,SIGNAL", "dev", "wifi", "list"]
        stdout: SplitParser {
            id: scanParser
            property var lines: []
            onRead: data => {
                let trimmed = data.trim();
                if (trimmed !== "") {
                    lines.push(trimmed);
                }
            }
        }
        onExited: code => {
            root._isScanning = false;
            if (code === 0 && root.isAwake) {
                root.updateModel(scanParser.lines);
            }
            scanParser.lines = [];
        }
    }

    property Process toggleProc: Process {
        property string targetState: "on"
        command: ["nmcli", "radio", "wifi", targetState]
        onExited: {
            root._isToggling = false;
            root.checkStateProc.running = true;
        }
    }

    property Process connectProc: Process {
        onExited: {
            root.connectingBssid = "";
            root.scan();
        }
    }

    onIsAwakeChanged: {
        if (isAwake) {
            checkStateProc.running = true;
            syncTimer.start();
        } else {
            syncTimer.stop();
        }
    }

    onEnabledChanged: {
        if (enabled && isAwake) {
            scan();
        } else if (!enabled) {
            networkModel.clear();
        }
    }

    function retain() {
        activeClients++;
        sleepTimer.stop();
        isAwake = true;
    }

    function release() {
        activeClients = Math.max(0, activeClients - 1);
        if (activeClients === 0) {
            sleepTimer.restart();
        }
    }

    function scan() {
        if (!enabled || _isScanning)
            return;
        _isScanning = true;

        scanParser.lines = [];

        scanProc.running = false;
        scanProc.running = true;
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

    function connectToNetwork(bssid: string, password: string) {
        if (connectingBssid !== "")
            return;
        connectingBssid = bssid;

        connectProc.command = password.length > 0 ? ["nmcli", "dev", "wifi", "connect", bssid, "password", password] : ["nmcli", "dev", "wifi", "connect", bssid];

        connectProc.running = false;
        connectProc.running = true;
    }

    function updateModel(lines: var) {
        const targets = [];
        const unescapeColon = str => str.replace(/___COLON___/g, ":");

        for (let i = 0; i < lines.length; i++) {
            const safeLine = lines[i].replace(/\\:/g, "___COLON___");
            const parts = safeLine.split(":");
            if (parts.length < 5)
                continue;

            const ssid = unescapeColon(parts[0]);
            if (ssid === "")
                continue;

            targets.push({
                ssid: ssid,
                bssid: unescapeColon(parts[1]),
                security: unescapeColon(parts[2]),
                connected: parts[3] === "*",
                signal: parseInt(parts[4], 10) || 0
            });
        }

        targets.sort((a, b) => (b.connected - a.connected) || (b.signal - a.signal));

        root.listModelDiff.sync(root.networkModel, targets, "bssid", ["connected", "signal", "security"]);
    }
}