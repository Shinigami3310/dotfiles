pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

QtObject {
    id: root

    property bool active: false

    function toggle() {
        active = !active;
        Quickshell.execDetached(["qs", "-c", Paths.notificationCenterConfig, "ipc", "call", "notification-center", "toggleDnd"]);
    }

    property Process initCheck: Process {
        command: ["qs", "-c", Paths.notificationCenterConfig, "ipc", "call", "notification-center", "getDndState"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.active = (data.trim() === "true");
            }
        }

        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn(`[DndService] getDndState завершился с кодом ${exitCode}`);
        }
    }
}
