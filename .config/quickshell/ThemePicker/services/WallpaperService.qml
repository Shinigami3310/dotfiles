pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

// Wallpaper list loading service from a directory.
// Works via Process + SplitParser: accumulates names in an internal buffer,
// and on completion emits the ready sorted list via the loaded() signal.
QtObject {
    id: root

    property var wallpapers: []

    // Internal buffer for accumulating output lines. Marked private:
    // no component should modify it directly.
    property var _buffer: []

    signal loaded()
    signal failed(string message)

    function load() {
        if (listProc.running)
            return;
        root._buffer = [];
        listProc.running = true;
    }

    property Process listProc: Process {
        // Via argument (not bash -c), to not depend on $HOME and to correctly
        // handle paths with spaces.
        command: ["ls", "-1", Configs.wallpaperDir]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const exts = [".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif"];
                const file = data.trim();

                // Check the extension and add to the temporary array
                if (file.length > 0 && exts.some(e => file.toLowerCase().endsWith(e))) {
                    root._buffer.push(file);
                }
            }
        }

        onExited: exitCode => {
            if (exitCode === 0) {
                root._buffer.sort();
                root.wallpapers = root._buffer; // Hand the whole ready list to the UI
                root.loaded();
            } else {
                const msg = "[WallpaperService] Failed to read directory, code: " + exitCode;
                console.warn(msg);
                root.failed(msg);
            }
            root._buffer = []; // Free memory
        }
    }
}