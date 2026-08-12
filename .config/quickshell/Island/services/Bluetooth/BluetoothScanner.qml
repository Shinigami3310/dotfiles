import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"

// Сканирование bluetooth: непрерывный `bluetoothctl scan on` + периодический
// запуск скрипта bt_scan.sh для снятия списка устройств.
// Выделен из BluetoothService, чтобы разделить «сырые» процессы
// (низкоуровневая логика) от оркестрации (состояние, модель).
// Значения интервалов передаются свойствами — как и в MpvEngine (без
// циклической зависимости от services-модуля).
QtObject {
    id: root

    signal scanData(var lines)

    property bool isAwake: false
    property bool isEnabled: false
    property bool isToggling: false
    property int throttleMs: 3000
    property int retryMs: 5000

    property Timer updateThrottleTimer: Timer {
        interval: root.throttleMs
        onTriggered: {
            if (!scanProc.running) {
                scanParser._lines = [];
                scanProc.running = true;
            }
        }
    }

    property Timer retryScanTimer: Timer {
        interval: root.retryMs
        onTriggered: startScan()
    }

    property Process continuousScanProc: Process {
        command: ["bluetoothctl", "scan", "on"]
        stdout: SplitParser {
            onRead: _ => {
                if (!root.updateThrottleTimer.running)
                    root.updateThrottleTimer.start();
            }
        }
        stderr: SplitParser {
            onRead: err => console.error(`[Bluetooth] Scan Error: ${err.trim()}`)
        }
        onExited: exitCode => {
            if (root.isAwake && root.isEnabled && !root.isToggling) {
                retryScanTimer.start();
            }
        }
    }

    property Process scanProc: Process {
        // Сканер вынесен в services/scripts/bt_scan.sh
        command: ["bash", Paths.scriptsDir + "bt_scan.sh"]
        stdout: SplitParser {
            id: scanParser
            property list<string> _lines: []
            onRead: data => {
                if (data.trim())
                    scanParser._lines.push(data.trim());
            }
        }
        onExited: exitCode => {
            if (exitCode === 0 && root.isAwake) {
                root.scanData(scanParser._lines);
            } else if (exitCode !== 0) {
                console.warn(`[Bluetooth] bt_scan.sh завершился с кодом ${exitCode}`);
            }
            scanParser._lines = [];
        }
    }

    function startScan() {
        if (!root.isEnabled || continuousScanProc.running)
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
}