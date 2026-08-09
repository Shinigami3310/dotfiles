pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

// Сервис загрузки списка обоев из директории.
// Работает через Process + SplitParser: накапливает имена во внутреннем буфере,
// а по завершении отдаёт готовый отсортированный список сигналом loaded().
QtObject {
    id: root

    property var wallpapers: []

    // Внутренний буфер для накопления строк вывода. Помечен как приватный:
    // ни один компонент не должен изменять его напрямую.
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
        // Через аргумент (не bash -c), чтобы не зависеть от $HOME и корректно
        // обрабатывать пути с пробелами.
        command: ["ls", "-1", Configs.wallpaperDir]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const exts = [".jpg", ".jpeg", ".png", ".webp", ".bmp", ".gif"];
                const file = data.trim();

                // Проверяем расширение и добавляем во временный массив
                if (file.length > 0 && exts.some(e => file.toLowerCase().endsWith(e))) {
                    root._buffer.push(file);
                }
            }
        }

        onExited: exitCode => {
            if (exitCode === 0) {
                root._buffer.sort();
                root.wallpapers = root._buffer; // Отдаем в UI разом весь готовый список
                root.loaded();
            } else {
                const msg = "[WallpaperService] Не удалось прочитать директорию, код: " + exitCode;
                console.warn(msg);
                root.failed(msg);
            }
            root._buffer = []; // Очищаем память
        }
    }
}