pragma Singleton

// Глобальное состояние выбора обоев. Единственный способ сменить индекс — move(),
// а UI реагирует на сигнал currentIndexChanged, а не на onValueChanged (правило .clinerules §3).
import QtQuick 6.0
import qs.config

QtObject {
    id: root

    // --- Состояние ---
    // var‑массив строк; мутировать ТОЛЬКО через setPaths (массово) — иначе биндинги не перестроятся.
    property var wallpaperPaths: []
    property int currentIndex: 0

    signal pathsChanged()
    signal currentIndexChanged(int index)

    readonly property int count: wallpaperPaths.length

    // Текущий выбранный путь. Индексация массива — тривиальный view‑state, а не heavy‑логика,
    // поэтому биндинг допустим (правило §3: речь о heavy‑функциях в биндингах).
    readonly property string currentPath: wallpaperPaths.length > 0 ? wallpaperPaths[currentIndex] : ""
    readonly property string currentName: currentPath ? String(currentPath).split("/").pop() : ""

    function setPaths(paths) {
        // Массовое присваивание → один pathsChanged → минимум ре‑eval‑ов (правило §3).
        wallpaperPaths = paths;
        // Индекс всегда валиден: если список сократился — сбрасываем в конец.
        if (currentIndex >= wallpaperPaths.length)
            currentIndex = wallpaperPaths.length > 0 ? wallpaperPaths.length - 1 : 0;
        pathsChanged();
    }

    function pathAt(index) {
        var n = wallpaperPaths.length;
        if (n === 0) return "";
        if (Theme.wrapAround)
            return wallpaperPaths[((index % n) + n) % n];          // true модуль для отрицательных
        return (index < 0 || index >= n) ? "" : wallpaperPaths[index];
    }

    function move(delta) {
        if (count === 0) return;
        var i = currentIndex + delta;
        if (Theme.wrapAround)
            i = ((i % count) + count) % count;
        else
            i = Math.max(0, Math.min(count - 1, i));
        currentIndex = i;                                          // → currentIndexChanged
    }
}
