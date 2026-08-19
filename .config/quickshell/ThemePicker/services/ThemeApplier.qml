pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../shared/theme"
import "../theme"

// Theme application service: runs scripts/set-theme with the wallpaper name.
// Does not decide the app lifecycle — only emits the applied() signal.
// A 10s timeout guards against a hung process.
QtObject {
    id: root

    signal applied(bool ok)

    // Name validation: forbid path traversal (slashes and ".."),
    // but allow spaces and unicode — real filenames vary.
    // Double protection: QML side + bash script.
    function apply(wallpaperName) {
        if (!wallpaperName) {
            console.warn("[ThemeApplier] Empty wallpaper name, skipping.");
            root.applied(false);
            return;
        }
        if (wallpaperName.indexOf("/") !== -1 || wallpaperName.indexOf("..") !== -1) {
            console.warn("[ThemeApplier] Invalid wallpaper name:", wallpaperName);
            root.applied(false);
            return;
        }
        root.applierProc.command = ["bash", Configs.setThemeScriptPath.replace(/^file:\/\//, ""), wallpaperName];
        root.timeoutTimer.start();
        root.applierProc.running = true;
    }

    property Process applierProc: Process {
        command: []
        running: false
        onExited: exitCode => {
            root.timeoutTimer.stop();
            if (exitCode !== 0)
                console.warn("[ThemeApplier] set-theme exited with code:", exitCode);
            root.applied(exitCode === 0);
        }
    }

    // Timeout: if the script hangs, report an error and unlock the UI.
    property Timer timeoutTimer: Timer {
        interval: Configs.themeApplyTimeout
        repeat: false
        onTriggered: {
            console.warn("[ThemeApplier] set-theme exceeded timeout (" + Configs.themeApplyTimeout + "ms).");
            root.applierProc.running = false;
            root.applied(false);
        }
    }
}
