pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var wallpapers: []
    property var _tempFiles: [] // Временный массив для накопления
    property bool loading: false

    function load() {
        if (listProc.running)
            return;
        root.loading = true;
        root._tempFiles = []; // Очищаем массив перед чтением
        listProc.running = true;
    }

    property Process listProc: Process {
        command: ["bash", "-c", "ls -1 \"$HOME/Pictures/Wallpapers\""]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const exts = [".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif"];
                const file = data.trim();

                // Проверяем расширение и добавляем во временный массив
                if (file.length > 0 && exts.some(e => file.toLowerCase().endsWith(e))) {
                    root._tempFiles.push(file);
                }
            }
        }

        onExited: exitCode => {
            root.loading = false;
            if (exitCode === 0) {
                root._tempFiles.sort();
                root.wallpapers = root._tempFiles; // Отдаем в UI разом весь готовый список
            } else {
                console.warn("[WallpaperService] Не удалось прочитать директорию, код:", exitCode);
            }
            root._tempFiles = []; // Очищаем память
        }
    }
}
