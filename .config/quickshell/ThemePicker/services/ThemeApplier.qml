pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string scriptPath: "/home/Rostislav/.config/quickshell/ThemePicker/scripts/set-theme"

    function apply(wallpaperName) {
        if (!wallpaperName) {
            console.warn("[ThemeApplier] Пустое имя обоев, пропускаю.");
            return;
        }
        applierProc.command = ["bash", root.scriptPath, wallpaperName];
        applierProc.running = true;
    }

    property Process applierProc: Process {
        command: []
        running: false
        onExited: exitCode => {
            if (exitCode !== 0)
                console.warn("[ThemeApplier] set-theme завершился с кодом:", exitCode);
            Qt.quit();
        }
    }
}
