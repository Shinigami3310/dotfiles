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
    readonly property bool isActive: activeClients > 0

    function retain() {
        activeClients++;
    }
    function release() {
        activeClients = Math.max(0, activeClients - 1);
    }

    ListModel {
        id: deviceModel
    }

    onEnabledChanged: {
        if (enabled && isActive) {
            scan();
        } else if (!enabled) {
            deviceModel.clear();
        }
    }

    onIsActiveChanged: {
        if (isActive) {
            checkState();
            syncTimer.start();
        } else {
            syncTimer.stop();
            statusProc.running = false;
            scanProc.running = false;
        }
    }

    // 1. Проверка питания адаптера
    Process {
        id: statusProc
        command: ["bluetoothctl", "show"]
        stdout: SplitParser {
            id: statusParser
            property bool powered: false
            onRead: data => {
                if (data.includes("Powered: yes"))
                    powered = true;
                else if (data.includes("Powered: no"))
                    powered = false;
            }
        }
        onExited: {
            root.enabled = statusParser.powered;
        }
    }

    function checkState() {
        statusProc.running = false;
        statusProc.running = true;
    }

    // 2. Получение списка устройств
    Process {
        id: scanProc
        command: ["bluetoothctl", "devices"]
        stdout: SplitParser {
            id: btScanParser
            property var devList: []
            onRead: data => {
                let parts = data.trim().split(" ");
                if (parts.length >= 3 && parts[0] === "Device") {
                    let mac = parts[1];
                    let name = parts.slice(2).join(" ");
                    devList.push({
                        mac: mac,
                        name: name,
                        connected: false
                    });
                }
            }
        }
        onExited: {
            if (root.isActive && root.enabled) {
                root.updateDevices(btScanParser.devList);
            }
            btScanParser.devList = [];
        }
    }

    function scan() {
        if (!root.enabled || scanProc.running)
            return;
        btScanParser.devList = [];
        scanProc.running = false;
        scanProc.running = true;
    }

    function updateDevices(list) {
        deviceModel.clear();
        for (let dev of list) {
            deviceModel.append(dev);
        }
    }

    Timer {
        id: syncTimer
        interval: 10000
        repeat: true
        onTriggered: {
            root.checkState();
            if (root.enabled)
                root.scan();
        }
    }

    Process {
        id: btToggleProc
        property string action: "off"
        command: ["bluetoothctl", "power", action]
        onExited: root.checkState()
    }

    function toggle() {
        btToggleProc.action = root.enabled ? "off" : "on";
        btToggleProc.running = false;
        btToggleProc.running = true;
    }

    Process {
        id: btConnectProc
        onExited: {
            root.connectingMac = "";
            root.scan();
        }
    }

    function connectToDevice(mac) {
        root.connectingMac = mac;
        btConnectProc.command = ["bluetoothctl", "connect", mac];
        btConnectProc.running = false;
        btConnectProc.running = true;
    }
}
