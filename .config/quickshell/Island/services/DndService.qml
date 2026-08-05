import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property bool active: false

    function toggle() {
        active = !active;
        Quickshell.execDetached(["qs", "-c", "NotificationCenter", "ipc", "call", "notification-center", "toggleDnd"]);
    }

    property Process initCheck: Process {
        command: ["qs", "-c", "NotificationCenter", "ipc", "call", "notification-center", "getDndState"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.active = (data.trim() === "true");
            }
        }
    }
}
