import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"

// Управление bluetooth: включение/выключение, проверка состояния,
// подключение к устройству по MAC. Выделен из BluetoothService,
// чтобы разделить низкоуровневые процессы от оркестрации.
QtObject {
    id: root

    signal stateChanged(bool enabled)
    signal toggleComplete(bool enabled)
    property bool isToggling: false

    // Проверка состояния bluetooth (Powered: yes/no)
    readonly property Process checkStateProc: Process {
        command: ["bash", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo 1 || echo 0"]
        stdout: SplitParser {
            onRead: data => {
                if (root.isToggling)
                    return;
                const newState = data.trim() === "1";
                root.stateChanged(newState);
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn(`[Bluetooth] bluetoothctl show завершился с кодом ${exitCode}`);
        }
    }

    // Включение/выключение
    readonly property Process toggleProc: Process {
        property string targetState: "on"
        command: ["bluetoothctl", "power", targetState]
        onExited: () => {
            root.isToggling = false;
            root.toggleComplete(targetState === "on");
        }
    }

    // Подключение к устройству
    property Process connectProc: Process {
        stderr: SplitParser {
            onRead: err => console.error(`[Bluetooth] Connect Error: ${err.trim()}`)
        }
        onExited: () => {
            root.connectComplete();
        }
    }
    signal connectComplete

    function toggle(targetEnabled: bool) {
        if (root.isToggling)
            return;
        root.isToggling = true;
        toggleProc.targetState = targetEnabled ? "on" : "off";
        toggleProc.running = false;
        toggleProc.running = true;
    }

    function connectToDevice(mac: string) {
        connectProc.command = ["bash", "-c",
            `bluetoothctl pair "${mac}"; sleep 0.5; bluetoothctl connect "${mac}"; bluetoothctl info "${mac}" | grep -q 'Connected: yes' && echo OK || echo FAIL`];
        connectProc.running = false;
        connectProc.running = true;
    }
}