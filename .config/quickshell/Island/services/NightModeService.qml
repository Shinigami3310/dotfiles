import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false
    property int temperature: 5000

    function toggle() {
        if (active)
            turnOff();
        else
            turnOn();
    }

    function turnOn() {
        Quickshell.execDetached(["hyprsunset", "-t", temperature.toString()]);
        checkProc.running = true;
    }

    function turnOff() {
        Quickshell.execDetached(["killall", "hyprsunset"]);
        checkProc.running = true;
    }

    readonly property Process checkProc: Process {
        command: ["pgrep", "-x", "hyprsunset"]
        running: false
        onExited: exitCode => {
            root.active = (exitCode === 0);
        }
    }

    readonly property Timer syncTimer: Timer {
        interval: 500
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
