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
    readonly property bool isActive: activeClients > 0

    function retain() {
        activeClients++;
    }
    function release() {
        activeClients = Math.max(0, activeClients - 1);
    }

    ListModel {
        id: networkModel
    }

    // При включении Wi-Fi модуля сразу запускаем сканирование
    onEnabledChanged: {
        if (enabled && isActive) {
            scan();
        } else if (!enabled) {
            networkModel.clear();
        }
    }

    onIsActiveChanged: {
        if (isActive) {
            checkState();
            syncTimer.start();
        } else {
            syncTimer.stop();
            scanProc.running = false;
            statusProc.running = false;
        }
    }

    // 1. Проверка состояния Wi-Fi
    Process {
        id: statusProc
        command: ["nmcli", "radio", "wifi"]
        stdout: SplitParser {
            onRead: data => {
                root.enabled = (data.trim() === "enabled");
            }
        }
    }

    function checkState() {
        statusProc.running = false;
        statusProc.running = true;
    }

    // 2. Сканирование сетей (Стандартный terse-формат nmcli с разделителем :)
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
            if (code === 0 && root.isActive) {
                root.updateModel(scanParser.lines);
            }
            scanParser.lines = [];
        }
    }

    function scan() {
        if (!root.enabled || scanProc.running)
            return;
        scanParser.lines = [];
        scanProc.running = false;
        scanProc.running = true;
    }

    // Корректный парсинг вывода nmcli (учитывает экранированные двоеточия)
    function updateModel(lines) {
        let parsedList = [];

        for (let i = 0; i < lines.length; i++) {
            let line = lines[i];
            if (!line)
                continue;

            // nmcli -t экранирует двоеточия внутри полей как \:
            let safeLine = line.replace(/\\:/g, "___COLON___");
            let parts = safeLine.split(":");
            if (parts.length < 5)
                continue;

            let ssid = parts[0].replace(/___COLON___/g, ":") || "Скрытая сеть";
            let bssid = parts[1].replace(/___COLON___/g, ":");
            let security = parts[2].replace(/___COLON___/g, ":");
            let connected = (parts[3] === "*");
            let signal = parseInt(parts[4]) || 0;

            parsedList.push({
                ssid: ssid,
                bssid: bssid,
                security: security,
                connected: connected,
                signal: signal
            });
        }

        networkModel.clear();
        for (let item of parsedList) {
            networkModel.append(item);
        }
    }

    Timer {
        id: syncTimer
        interval: 8000
        repeat: true
        onTriggered: {
            root.checkState();
            if (root.enabled)
                root.scan();
        }
    }

    // Безопасный процесс переключения
    Process {
        id: toggleProc
        property string targetState: "on"
        command: ["nmcli", "radio", "wifi", targetState]
        onExited: {
            root.checkState();
        }
    }

    function toggle() {
        toggleProc.targetState = !root.enabled ? "on" : "off";
        toggleProc.running = false;
        toggleProc.running = true;
    }

    // Безопасный процесс подключения
    Process {
        id: connectProc
        onExited: {
            root.connectingBssid = "";
            root.scan();
        }
    }

    function connectToNetwork(bssid, password) {
        root.connectingBssid = bssid;
        connectProc.command = password !== "" ? ["nmcli", "dev", "wifi", "connect", bssid, "password", password] : ["nmcli", "dev", "wifi", "connect", bssid];
        connectProc.running = false;
        connectProc.running = true;
    }
}
