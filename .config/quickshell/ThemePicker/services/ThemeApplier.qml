pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../shared/theme"
import "../theme"

QtObject {
    id: root

    signal applied(bool ok)

    function apply(wallpaperName) {
        root.applierProc.command = ["bash", Configs.setThemeScriptPath, wallpaperName];
        root.applyTimer.start();
        root.applierProc.running = true;
    }

    property Timer applyTimer: Timer {
        interval: 10000
        onTriggered: {
            root.applierProc.kill();
            root.applied(false);
        }
    }

    property Process applierProc: Process {
        command: []
        running: false
        onExited: exitCode => {
            root.applyTimer.stop();
            root.applied(exitCode === 0);
        }
    }
}
