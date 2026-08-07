pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false
    property int temperature: 5000

    function toggle() {
        if (active)
            Quickshell.execDetached(["killall", "hyprsunset"]);
        else
            Quickshell.execDetached(["hyprsunset", "-t", temperature.toString()]);
        active = !active;
    }

    property Process initCheck: Process {
        command: ["pgrep", "-x", "hyprsunset"]
        running: true
        onExited: exitCode => {
            root.active = (exitCode === 0);
        }
    }
}
