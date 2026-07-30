pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false

    // Цветовая температура в Кельвинах (3000K - 4500K — комфортный теплый свет)
    property int temperature: 5000

    function toggle() {
        if (active) {
            turnOff();
        } else {
            turnOn();
        }
    }

    function turnOn() {
        Quickshell.execDetached(["hyprsunset", "-t", temperature.toString()]);
        syncTimer.triggered();
    }

    function turnOff() {
        Quickshell.execDetached(["killall", "hyprsunset"]);
        syncTimer.triggered();
    }

    // Проверяем наличие процесса по exitCode команды pgrep
    readonly property Process checkProc: Process {
        command: ["pgrep", "-x", "hyprsunset"]
        running: false

        // exitCode === 0 означает, что pgrep нашел процесс hyprsunset
        onExited: (exitCode, exitStatus) => {
            root.active = (exitCode === 0);
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!root.checkProc.running) {
                root.checkProc.running = true;
            }
        }
    }
}
