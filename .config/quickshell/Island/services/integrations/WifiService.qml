pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool enabled: false
    property string connectingBssid: ""
    property alias networkModel: networkModel

    property int activeClients: 0
    property bool isAwake: false

    property bool _isScanning: false
    property bool _isToggling: false

    ListModel {
        id: networkModel
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

    Timer {
        id: sleepTimer
        interval: 1000
        onTriggered: root.isAwake = false
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
        if (enabled && isAwake)
            scan();
        else if (!enabled)
            networkModel.clear();
    }

    Timer {
        id: syncTimer
        interval: 5000
        repeat: true
        onTriggered: {
            checkStateProc.running = true;
            if (root.enabled)
                root.scan();
        }
    }

    Process {
        id: checkStateProc
        command: ["nmcli", "-t", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                if (!root._isToggling) {
                    root.enabled = (data.trim() === "enabled");
                }
            }
        }
    }

    Process {
        id: scanProc
        command: ["nmcli", "-t", "-f", "SSID,BSSID,SECURITY,IN-USE,SIGNAL", "dev", "wifi", "list"]
        stdout: SplitParser {
            id: scanParser
            property var lines: []
            onRead: data => {
                if (data.trim() !== "")
                    lines.push(data.trim());
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

    Process {
        id: toggleProc
        property string targetState: "on"
        command: ["nmcli", "radio", "wifi", targetState]
        onExited: {
            root._isToggling = false;
            checkStateProc.running = true;
        }
    }

    Process {
        id: connectProc
        onExited: {
            root.connectingBssid = "";
            root.scan();
        }
    }

    function scan() {
        if (!enabled || _isScanning)
            return;
        _isScanning = true;
        scanProc.running = false;
        scanProc.running = true;
    }

    function toggle() {
        if (_isToggling)
            return;
        _isToggling = true;

        root.enabled = !root.enabled;
        toggleProc.targetState = root.enabled ? "on" : "off";
        toggleProc.running = false;
        toggleProc.running = true;
    }

    function connectToNetwork(bssid, password) {
        if (connectingBssid !== "")
            return;
        connectingBssid = bssid;

        connectProc.command = (password !== "") ? ["nmcli", "dev", "wifi", "connect", bssid, "password", password] : ["nmcli", "dev", "wifi", "connect", bssid];
        connectProc.running = false;
        connectProc.running = true;
    }

    function updateModel(lines) {
        let targets = [];

        for (let i = 0; i < lines.length; i++) {
            let safeLine = lines[i].replace(/\\:/g, "___COLON___");
            let parts = safeLine.split(":");
            if (parts.length < 5)
                continue;
            let ssid = parts[0].replace(/___COLON___/g, ":");
            if (ssid === "")
                continue;

            targets.push({
                ssid: parts[0].replace(/___COLON___/g, ":") || "Hidden network",
                bssid: parts[1].replace(/___COLON___/g, ":"),
                security: parts[2].replace(/___COLON___/g, ":"),
                connected: (parts[3] === "*"),
                signal: parseInt(parts[4]) || 0
            });
        }

        targets.sort((a, b) => b.connected - a.connected || b.signal - a.signal);

        let targetMap = {};
        for (let i = 0; i < targets.length; i++) {
            targetMap[targets[i].bssid] = targets[i];
        }

        for (let i = networkModel.count - 1; i >= 0; i--) {
            if (!targetMap[networkModel.get(i).bssid]) {
                networkModel.remove(i);
            }
        }

        for (let i = 0; i < targets.length; i++) {
            let t = targets[i];
            let foundIdx = -1;

            for (let j = i; j < networkModel.count; j++) {
                if (networkModel.get(j).bssid === t.bssid) {
                    foundIdx = j;
                    break;
                }
            }

            if (foundIdx !== -1) {
                let item = networkModel.get(foundIdx);
                if (item.connected !== t.connected)
                    networkModel.setProperty(foundIdx, "connected", t.connected);
                if (item.signal !== t.signal)
                    networkModel.setProperty(foundIdx, "signal", t.signal);
                if (item.security !== t.security)
                    networkModel.setProperty(foundIdx, "security", t.security);

                if (foundIdx !== i) {
                    networkModel.move(foundIdx, i, 1);
                }
            } else {
                networkModel.insert(i, t);
            }
        }
    }
}
