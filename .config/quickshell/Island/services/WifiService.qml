pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool enabled: false
    property string connectingBssid: "" // Идентификатор подключаемой сети

    readonly property ListModel networkModel: ListModel {}

    function toggle() {
        let newState = !enabled;
        Quickshell.execDetached(["nmcli", "radio", "wifi", newState ? "on" : "off"]);
        enabled = newState;
        connectingBssid = "";
        if (newState)
            scanProc.running = true;
        else
            networkModel.clear();
    }

    function connectToNetwork(bssid, password) {
        connectingBssid = bssid;
        connectionTimeout.restart(); // Запускаем страховку от бесконечного зависания

        if (password && password.length > 0) {
            Quickshell.execDetached(["nmcli", "dev", "wifi", "connect", bssid, "password", password]);
        } else {
            Quickshell.execDetached(["nmcli", "dev", "wifi", "connect", bssid]);
        }
        delayedScan.start();
    }

    // Таймаут подключения (15 секунд): сбрасывает статус "Подключение...", если nmcli завис или выдал ошибку
    readonly property Timer connectionTimeout: Timer {
        interval: 15000
        onTriggered: {
            root.connectingBssid = "";
            if (!root.scanProc.running)
                root.scanProc.running = true;
        }
    }

    readonly property Timer delayedScan: Timer {
        interval: 3500
        onTriggered: if (!root.scanProc.running)
            root.scanProc.running = true
    }

    readonly property Process checkPowerProc: Process {
        command: ["nmcli", "radio", "wifi"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let isPowered = (data.trim().toLowerCase() === "enabled");
                if (root.enabled !== isPowered)
                    root.enabled = isPowered;
                if (isPowered && root.networkModel.count === 0 && !root.scanProc.running)
                    root.scanProc.running = true;
            }
        }
    }

    readonly property Process scanProc: Process {
        command: ["nmcli", "-t", "-f", "IN-USE,BSSID,SECURITY,SSID", "dev", "wifi", "list"]
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

        onExited: exitCode => {
            let lines = scanProc.rawLines;
            scanProc.rawLines = [];
            if (exitCode !== 0 || lines.length === 0)
                return;
            let newNetworks = [];
            let seenSsids = {};

            for (let i = 0; i < lines.length; i++) {
                let line = lines[i];
                let parts = [];
                let curr = "";
                for (let j = 0; j < line.length; j++) {
                    if (line[j] === '\\' && j + 1 < line.length && line[j + 1] === ':') {
                        curr += ':';
                        j++;
                    } else if (line[j] === ':') {
                        parts.push(curr);
                        curr = "";
                    } else {
                        curr += line[j];
                    }
                }
                parts.push(curr);

                if (parts.length >= 4) {
                    let isConn = (parts[0] === "*");
                    let bssid = parts[1];
                    let sec = parts[2];
                    let ssid = parts[3];

                    // Если сеть, к которой мы подключались, успешно подключена — снимаем статус ожидания
                    if (bssid === root.connectingBssid && isConn) {
                        root.connectingBssid = "";
                        root.connectionTimeout.stop();
                    }

                    if (ssid.length > 0 && !seenSsids[ssid]) {
                        seenSsids[ssid] = true;
                        newNetworks.push({
                            connected: isConn,
                            bssid: bssid,
                            security: sec,
                            ssid: ssid
                        });
                    }
                }
            }

            newNetworks.sort((a, b) => b.connected - a.connected);

            // Реактивное обновление модели без сброса скролла
            for (let i = root.networkModel.count - 1; i >= 0; i--) {
                let found = false;
                for (let j = 0; j < newNetworks.length; j++) {
                    if (root.networkModel.get(i).ssid === newNetworks[j].ssid) {
                        found = true;
                        break;
                    }
                }
                if (!found)
                    root.networkModel.remove(i);
            }

            for (let j = 0; j < newNetworks.length; j++) {
                let net = newNetworks[j];
                let foundIdx = -1;
                for (let i = 0; i < root.networkModel.count; i++) {
                    if (root.networkModel.get(i).ssid === net.ssid) {
                        foundIdx = i;
                        break;
                    }
                }
                if (foundIdx !== -1) {
                    root.networkModel.setProperty(foundIdx, "connected", net.connected);
                    root.networkModel.setProperty(foundIdx, "security", net.security);
                    root.networkModel.setProperty(foundIdx, "bssid", net.bssid);
                    if (foundIdx !== j)
                        root.networkModel.move(foundIdx, j, 1);
                } else {
                    root.networkModel.insert(j, net);
                }
            }
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!root.checkPowerProc.running)
                root.checkPowerProc.running = true;
            if (root.enabled && !root.scanProc.running)
                root.scanProc.running = true;
        }
    }
}
