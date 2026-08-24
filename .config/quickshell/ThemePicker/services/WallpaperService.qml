pragma Singleton

import QtQuick
import Quickshell.Io
import "../shared/theme"
import "../theme"

QtObject {
    id: root

    property list<string> wallpapers: []
    property list<string> _buffer: []

    signal loaded(bool ok)

    function load() {
        if (listProc.running)
            return;
        root._buffer = [];
        listProc.running = true;
    }

    property Process listProc: Process {
        command: ["ls", "-1", Configs.wallpaperDir]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const exts = [".jpg", ".jpeg", ".png", ".webp", ".gif"];
                const file = data.trim();

                if (file.length > 0 && exts.some(e => file.toLowerCase().endsWith(e))) {
                    root._buffer.push(file);
                }
            }
        }

        onExited: exitCode => {
            if (exitCode === 0) {
                root.wallpapers = root._buffer;
            } 
            root._buffer = [];
            root.loaded(exitCode === 0);
        }
    }
}
