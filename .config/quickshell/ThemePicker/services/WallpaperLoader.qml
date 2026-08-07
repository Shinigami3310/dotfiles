pragma Singleton

// Асинхронный источник данных: сканирует директорию через sh/find. QML/JS никогда
// не парсит списки файлов в биндингах — вывод собирается в onStdout и одним setPaths
// прокидывается в ThemeModel (правило .clinerules §3: без heavy‑JS в биндингах).
import QtQuick 6.0
import Quickshell        // Process, ProcessChannel
import qs.config         // Theme.*

QtObject {
    id: root

    Process {
        id: scanProc
        readableChannel: ProcessChannel.Stdout        // чистый stdout, без stderr‑мусора
        onStdout: function (data) { stdoutBuf += data; }
        onFinished: function (exitCode) {
            if (exitCode === 0) {
                // Одна массовая выборка → один ре‑eval у ThemeModel.
                var lines = stdoutBuf.trim().split("\n").filter(function (s) { return s.length > 0; });
                ThemeModel.setPaths(lines);
            } else {
                console.warn("WallpaperLoader: scan failed (code " + exitCode + ")");
            }
            stdoutBuf = "";
        }
    }

    property string stdoutBuf: ""

    // Запуск сканирования по запросу (не при создании синглетона).
    function scan() {
        if (scanProc.running) return;                           // не параМпельно: защита от каскада
        stdoutBuf = "";
        scanProc.command = buildCommand();
        scanProc.running = true;                                 // пере‑запуск того же Process — документировано
    }

    function buildCommand() {
        // Расширения и путь из конфига (правило §2: никаких хардкодов).
        var dir = Theme.wallpaperDir;                           // относительно $HOME
        var exts = Theme.validExtensions;
        var ign = exts.map(function (e) { return "-iname '*." + e + "'"; })
                     .join(" -o ");
        // $HOME раскрывается sh; 2>/dev/null глушит stderr find (perm‑исключения).
        return ["sh", "-c",
            "find \"$HOME/" + dir + "\" -type f \\( " + ign + " \\) -print 2>/dev/null | sort"];
    }
}
