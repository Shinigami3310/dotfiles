pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool enabled: false
    property string connectingMac: ""
    property alias deviceModel: deviceModel

    property int activeClients: 0
    property bool isAwake: false

    property bool _isScanning: false
    property bool _isToggling: false

    ListModel {
        id: deviceModel
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
            scanProc.running = false;
        }
    }

    onEnabledChanged: {
        if (enabled && isAwake)
            scan();
        else if (!enabled)
            deviceModel.clear();
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
        command: ["bash", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo enabled || echo disabled"]
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
        command: ["bash", "-c", "bluetoothctl --timeout 3 scan on >/dev/null 2>&1; bluetoothctl devices | while read -r _ mac name; do info=$(bluetoothctl info \"$mac\"); if echo \"$info\" | grep -q 'Connected: yes'; then c='true'; else c='false'; fi; if echo \"$info\" | grep -q 'Paired: yes'; then p='true'; else p='false'; fi; echo \"$mac|$c|$p|$name\"; done"]
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
        command: ["bluetoothctl", "power", targetState]
        onExited: {
            root._isToggling = false;
            checkStateProc.running = true;
        }
    }

    Process {
        id: connectProc
        onExited: {
            root.connectingMac = "";
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

    function connectToDevice(mac) {
        if (connectingMac !== "")
            return;
        connectingMac = mac;

        connectProc.command = ["bash", "-c", `bluetoothctl pair ${mac}; bluetoothctl connect ${mac}`];
        connectProc.running = false;
        connectProc.running = true;
    }

    function updateModel(lines) {
        let targets = [];

        for (let i = 0; i < lines.length; i++) {
            let parts = lines[i].split('|');
            if (parts.length < 4)
                continue;

            targets.push({
                mac: parts[0],
                connected: (parts[1] === "true"),
                paired: (parts[2] === "true"),
                name: parts.slice(3).join('|') || "Неизвестное устройство"
            });
        }

        targets.sort((a, b) => b.connected - a.connected || b.paired - a.paired || a.name.localeCompare(b.name));

        let targetMap = {};
        for (let i = 0; i < targets.length; i++) {
            targetMap[targets[i].mac] = targets[i];
        }

        for (let i = deviceModel.count - 1; i >= 0; i--) {
            if (!targetMap[deviceModel.get(i).mac]) {
                deviceModel.remove(i);
            }
        }

        for (let i = 0; i < targets.length; i++) {
            let t = targets[i];
            let foundIdx = -1;

            for (let j = i; j < deviceModel.count; j++) {
                if (deviceModel.get(j).mac === t.mac) {
                    foundIdx = j;
                    break;
                }
            }

            if (foundIdx !== -1) {
                let item = deviceModel.get(foundIdx);
                if (item.connected !== t.connected)
                    deviceModel.setProperty(foundIdx, "connected", t.connected);
                if (item.paired !== t.paired)
                    deviceModel.setProperty(foundIdx, "paired", t.paired);
                if (item.name !== t.name)
                    deviceModel.setProperty(foundIdx, "name", t.name);

                if (foundIdx !== i) {
                    deviceModel.move(foundIdx, i, 1);
                }
            } else {
                deviceModel.insert(i, t);
            }
        }
    }
}
