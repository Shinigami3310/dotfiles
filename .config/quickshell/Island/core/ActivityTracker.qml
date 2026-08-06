import QtQuick

// Универсальный трекер активности с подсчётом клиентов,
// автоматическим засыпанием и пробуждением.
// Используется в WifiService и BluetoothService.
QtObject {
    id: root

    property bool isAwake: false
    property int activeClients: 0

    // Сигнал о том, что состояние изменилось
    signal awakeChanged(bool awake)

    // Таймер автоматического засыпания
    property Timer sleepTimer: Timer {
        interval: 1000
        onTriggered: {
            root.isAwake = false;
            root.awakeChanged(false);
        }
    }

    function retain() {
        activeClients++;
        sleepTimer.stop();
        if (!isAwake) {
            isAwake = true;
            root.awakeChanged(true);
        }
    }

    function release() {
        activeClients = Math.max(0, activeClients - 1);
        if (activeClients === 0) {
            sleepTimer.restart();
        }
    }
}