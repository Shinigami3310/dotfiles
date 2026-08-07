pragma Singleton

// Сервис применения обоев. set-themes принимает basename ($1), поэтому из полного
// пути берём имя файла. execDetached — fire‑and‑forget: скрипт (aww/matugen) живёт
// независимо от Qt.quit() окна, поэтому fade‑out + quit не убивают применение
// (правило .clinerules §4: валидируем аргументы перед внешним процессом).
import QtQuick 6.0
import Quickshell        // Quickshell.execDetached, Quickshell.shellPath
import qs.config         // Theme.applyScript / applyBy

QtObject {
    id: root

    function apply(path) {
        var name = String(path).split("/").pop();
        if (!name) { console.warn("WallpaperApplier: empty path"); return; }

        if (Theme.applyBy === "name") {
            var script = Quickshell.shellPath(Theme.applyScript);   // абсолютный путь в shellDir
            Quickshell.execDetached([script, name]);
        } else {
            Quickshell.execDetached([Quickshell.shellPath(Theme.applyScript), path]);
        }
    }
}
