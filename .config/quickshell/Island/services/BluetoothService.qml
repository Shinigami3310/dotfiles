pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

QtObject {
    id: root

    property bool enabled: false
    property string connectingMac: ""
    readonly property ListModel deviceModel: ListModel {}
    property bool isAwake: false

    readonly property QtObject adapter: Bluetooth.defaultAdapter

    Component.onCompleted: {
        console.log("[BT Service] Запуск. Адаптер найден:", !!root.adapter);
        if (root.adapter) {
            root.enabled = root.adapter.enabled;
            console.log("[BT Service] Статус адаптера (enabled):", root.enabled);
            
            // Проверяем, поддерживает ли адаптер свойство discovering
            if (root.adapter.discovering !== undefined) {
                console.log("[BT Service] Режим сканирования (discovering):", root.adapter.discovering);
            } else {
                console.log("[BT Service] Свойство 'discovering' у адаптера не найдено.");
            }
            
            root._syncDevices();
        }
    }

    onAdapterChanged: {
        console.log("[BT Service] Сменился адаптер:", !!root.adapter);
        if (root.adapter) {
            root.enabled = root.adapter.enabled;
            root._syncDevices();
        } else {
            root.enabled = false;
            root.deviceModel.clear();
        }
    }

    property Connections adapterConnections: Connections {
        target: root.adapter
        enabled: root.adapter != null
        
        function onEnabledChanged() { 
            console.log("[BT Service] Адаптер вкл/выкл изменился на:", root.adapter.enabled);
            root.enabled = root.adapter.enabled;
        }
        
        // Если у адаптера есть сигнал onDiscoveringChanged, раскомментируйте код ниже:
        /*
        function onDiscoveringChanged() {
            console.log("[BT Service] Состояние сканирования изменилось на:", root.adapter.discovering);
        }
        */
    }

    property Connections devicesConnections: Connections {
        target: root.adapter ? root.adapter.devices : null
        
        function onValuesChanged() { 
            console.log("[BT Service] Список устройств в адаптере изменился (onValuesChanged)!");
            root._syncDevices();
        }
    }

    function toggle() {
        console.log("[BT Service] Вызван toggle()");
        if (root.adapter)
            root.adapter.enabled = !root.adapter.enabled;
    }

    // Добавим функцию-помощник для попытки запустить сканирование.
    // Если она выдаст ошибку, значит API в Quickshell отличается.
    function startScan() {
        console.log("[BT Service] Попытка запустить сканирование...");
        if (!root.adapter) return;
        
        try {
            // Попробуем два самых частых варианта API:
            if (typeof root.adapter.startDiscovery === "function") {
                root.adapter.startDiscovery();
                console.log("[BT Service] Вызван метод startDiscovery()");
            } else {
                root.adapter.discovering = true;
                console.log("[BT Service] Установлено свойство discovering = true");
            }
        } catch (e) {
            console.error("[BT Service] Ошибка при запуске сканирования:", e);
        }
    }
    
    function stopScan() {
        console.log("[BT Service] Попытка остановить сканирование...");
        if (!root.adapter) return;
        
        try {
            if (typeof root.adapter.stopDiscovery === "function") {
                root.adapter.stopDiscovery();
            } else {
                root.adapter.discovering = false;
            }
        } catch (e) {}
    }

    function connectToDevice(mac: string) {
        console.log("[BT Service] Попытка подключения к:", mac);
        if (root.connectingMac !== "") {
            console.log("[BT Service] Уже идет подключение к", root.connectingMac);
            return;
        }
        
        const d = root._findDevice(mac);
        if (!d) {
            console.log("[BT Service] ОШИБКА: Устройство", mac, "не найдено");
            return;
        }
        
        root.connectingMac = mac;
        d.connect();
        connectingTimer.restart();
    }

    function _findDevice(mac: string): QtObject {
        const devs = root.adapter ? root.adapter.devices.values : null;
        if (!devs) return null;
        
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].address === mac) 
                return devs[i];
        }
        return null;
    }

    function _syncDevices() {
        console.log("[BT Service] --- Начало _syncDevices ---");
        const devs = root.adapter ? root.adapter.devices.values : null;
        
        if (!devs) {
            console.log("[BT Service] Нет устройств (devs is null)");
            return;
        }

        console.log("[BT Service] Всего устройств получено от BlueZ:", devs.length);

        const targets = [];
        for (let i = 0; i < devs.length; i++) {
            const d = devs[i];
            
            console.log(`[BT Service] Устройство [${i}]: MAC=${d.address} Name="${d.name || d.deviceName}" Paired=${d.paired} Connected=${d.connected}`);

            targets.push({
                mac: d.address,
                name: d.name || d.deviceName || "Unknown Device",
                connected: !!d.connected,
                paired: !!d.paired,
                object: d
            });
        }

        targets.sort((x, y) => (y.connected - x.connected) || (y.paired - x.paired) || x.name.localeCompare(y.name));

        const keyMap = {};
        for (let i = 0; i < targets.length; i++)
            keyMap[targets[i].mac] = targets[i];

        let removed = 0;
        for (let i = root.deviceModel.count - 1; i >= 0; i--) {
            if (!keyMap[root.deviceModel.get(i).mac]) {
                root.deviceModel.remove(i);
                removed++;
            }
        }

        let added = 0;
        let updated = 0;
        for (let i = 0; i < targets.length; i++) {
            const target = targets[i];
            let found = -1;
            for (let j = 0; j < root.deviceModel.count; j++) {
                if (root.deviceModel.get(j).mac === target.mac) {
                    found = j;
                    root.deviceModel.setProperty(j, "connected", target.connected);
                    root.deviceModel.setProperty(j, "paired", target.paired);
                    updated++;
                    break;
                }
            }
            if (found === -1) {
                root.deviceModel.append(target);
                added++;
            }
        }
        
        console.log(`[BT Service] --- Итог _syncDevices: Добавлено ${added}, Обновлено ${updated}, Удалено ${removed}. Итого в модели: ${root.deviceModel.count} ---`);
    }

    property Timer connectingTimer: Timer {
        interval: 10000
        repeat: false
        onTriggered: root.connectingMac = ""
    }

    property Connections deviceStateConn: Connections {
        target: null
        enabled: false
    }

    function retain() {}
    function release() {}
}
